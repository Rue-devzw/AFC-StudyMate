import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsPlayButton extends StatefulWidget {
  const TtsPlayButton({
    required this.text, super.key,
    this.compact = false,
  });

  final String text;
  final bool compact;

  @override
  State<TtsPlayButton> createState() => _TtsPlayButtonState();
}

class _TtsPlayButtonState extends State<TtsPlayButton> {
  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_isPlaying) {
      await _tts.stop();
      if (mounted) {
        setState(() => _isPlaying = false);
      }
      return;
    }
    if (widget.text.trim().isEmpty) {
      return;
    }
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.speak(widget.text);
    if (mounted) {
      setState(() => _isPlaying = true);
    }
    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return IconButton(
        onPressed: _toggle,
        tooltip: _isPlaying ? 'Stop audio' : 'Play audio',
        icon: Icon(_isPlaying ? Icons.stop_circle : Icons.play_circle),
      );
    }
    return FilledButton.icon(
      onPressed: _toggle,
      icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
      label: Text(_isPlaying ? 'Stop Audio' : 'Play Audio'),
    );
  }
}
