import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentAudioUrl;

  bool get isPlaying => _isPlaying;
  String? get currentAudioUrl => _currentAudioUrl;

  Future<void> playVerse(String audioUrl) async {
    try {
      if (_isPlaying && _currentAudioUrl == audioUrl) {
        await pause();
        return;
      }

      if (_isPlaying) {
        await stop();
      }

      _currentAudioUrl = audioUrl;
      await _audioPlayer.play(UrlSource(audioUrl));
      _isPlaying = true;
    } catch (e) {
      debugPrint('Audio play error: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Audio pause error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentAudioUrl = null;
    } catch (e) {
      debugPrint('Audio stop error: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Audio resume error: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}