library;

export 'src/bindings.dart';

class babylon {
  static const String _libraryName = 'babylon_tts';

  static final babylon _instance = babylon._();

  factory babylon() => _instance;

  babylon._();
}