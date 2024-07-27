
import 'dart:ffi';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:ffi/ffi.dart';
import 'bindings.dart';

class Babylon {
  static File? _dpModel;
  static File? _vitsModel;
  static babylon? _lib;

  /// Getter for the Llama library.
  ///
  /// Loads the library based on the current platform.
  static babylon get lib {
    if (_lib == null) {
      if (Platform.isWindows) {
        _lib = babylon(DynamicLibrary.open('babylon.dll'));
      } 
      else if (Platform.isLinux || Platform.isAndroid) {
        _lib = babylon(DynamicLibrary.open('libbabylon.so'));
      } 
      else if (Platform.isMacOS || Platform.isIOS) {
        _lib = babylon(DynamicLibrary.open('libbabylon.dylib'));
      } 
      else {
        throw Exception('Unsupported platform');
      }
    }
    return _lib!;
  }

  static Future<File> tts(String text) async {
    if (_dpModel == null) {
      final dpModel = await rootBundle.load('packages/babylon_tts/src/babylon.cpp/models/deep_phonemizer.onnx');
      _dpModel = File('${(await Directory.systemTemp.createTemp()).path}/deep_phonemizer.onnx');
      await _dpModel!.writeAsBytes(Uint8List.view(dpModel.buffer));
    }

    if (_vitsModel == null) {
      final vitsModel = await rootBundle.load('packages/babylon_tts/src/babylon.cpp/models/curie.onnx');
      _vitsModel = File('${(await Directory.systemTemp.createTemp()).path}/curie.onnx');
      await _vitsModel!.writeAsBytes(Uint8List.view(vitsModel.buffer));
    }

    final dpModelPath = _dpModel!.path.toNativeUtf8().cast<Char>();
    final language = "en_us".toNativeUtf8().cast<Char>();

    final result = lib.babylon_g2p_init(dpModelPath, language, 1);

    if (result != 0) {
      throw Exception('Failed to initialize g2p');
    }

    final vitsModelPath = _vitsModel!.path.toNativeUtf8().cast<Char>();
    final result2 = lib.babylon_tts_init(vitsModelPath);

    if (result2 != 0) {
      throw Exception('Failed to initialize tts');
    }

    final textPtr = text.toNativeUtf8().cast<Char>();

    final textHash = sha256.convert(text.codeUnits).toString();

    final outputFile = File('${(await Directory.systemTemp.createTemp()).path}/$textHash.wav');

    final outputFilePath = outputFile.path.toNativeUtf8().cast<Char>();

    lib.babylon_tts(textPtr, outputFilePath);

    lib.babylon_tts_free();

    lib.babylon_g2p_free();

    return outputFile;
  }
}