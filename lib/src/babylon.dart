import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:audioplayers/audioplayers.dart';
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

  static Future<void> init() async {
    final dpModel = await rootBundle.load('packages/babylon_tts/models/deep_phonemizer.onnx');
    _dpModel = File('${(await Directory.systemTemp.createTemp()).path}/deep_phonemizer.onnx');
    await _dpModel!.writeAsBytes(Uint8List.view(dpModel.buffer));

    final vitsModel = await rootBundle.load('packages/babylon_tts/models/curie.onnx');
    _vitsModel = File('${(await Directory.systemTemp.createTemp()).path}/curie.onnx');
    await _vitsModel!.writeAsBytes(Uint8List.view(vitsModel.buffer));

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
  }

  static Future<void> tts(String text) async {
    final outputFile = await textToSpeechFile(text);

    final source = DeviceFileSource(outputFile.path);

    final audioPlayer = AudioPlayer();

    await audioPlayer.play(source);

    await audioPlayer.onPlayerComplete.first;
  }

  static Future<void> stringStreamToSpeech(Stream<String> stream) async {
    String buffer = '';

    await for (final text in stream) {
      buffer += text;

      if (text.contains(RegExp(r'[.!?]'))) {
        String input = buffer;

        final lastSentenceEnd = input.lastIndexOf(RegExp(r'[.!?]'));

        input = input.substring(0, lastSentenceEnd + 1);
        buffer = buffer.substring(input.length);

        await tts(input);
      }
    }

    if (buffer.isNotEmpty) {
      await tts(buffer);
    }
  }

  static Future<File> textToSpeechFile(String text) async {
    final textHash = sha256.convert(text.codeUnits).toString();

    final outputFile = File('${(await Directory.systemTemp.createTemp()).path}/$textHash.wav');

    final receivePort = ReceivePort();
    
    Isolate.spawn(
      textToSpeechIsolate,
      (text, outputFile.path, receivePort.sendPort)
    );

    await receivePort.first; // Wait for the isolate to complete its task

    return outputFile;
  }

  static void textToSpeechIsolate((String, String, SendPort) args) async {
    final (text, outputPath, sendPort) = args;

    if (_dpModel == null || _vitsModel == null) {
      await init();
    }

    final textPtr = text.toNativeUtf8().cast<Char>();
    final outputFilePath = outputPath.toNativeUtf8().cast<Char>();

    lib.babylon_tts(textPtr, outputFilePath);

    sendPort.send(null); // Notify the main isolate that the task is complete
  }

  static dispose() {
    lib.babylon_g2p_free();
    lib.babylon_tts_free();
  }
}
