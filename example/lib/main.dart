import 'package:flutter/material.dart';
import 'package:babylon_tts/babylon_tts.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Babylon TTS'),
        ),
        body: const TTSPage(),
      ),
    );
  }
}

class TTSPage extends StatefulWidget {
  const TTSPage({super.key});

  @override
  State<TTSPage> createState() => _TTSPageState();
}

class _TTSPageState extends State<TTSPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isPlaying = false;

  void _generateAndPlaySpeech() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter some text')));
      return;
    }

    try {
      setState(() {
        _isPlaying = true;
      });

      await Babylon.tts(_controller.text);

      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter text to speak',
            ),
            maxLines: 10,
            keyboardType: TextInputType.multiline
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isPlaying ? null : _generateAndPlaySpeech,
            child: Text(_isPlaying ? 'Playing...' : 'Generate Speech'),
          ),
        ],
      ),
    );
  }
}