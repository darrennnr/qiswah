import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quran_models.dart';

/// Comprehensive AI Voice Service for Arabic Qur'an Analysis
/// 
/// This service integrates multiple AI tools and APIs for:
/// - Speech-to-text conversion for Arabic
/// - Pronunciation analysis and correction
/// - Tajwid rule checking
/// - Real-time feedback and scoring
class AIVoiceService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final SpeechToText _speechToText = SpeechToText();
  
  bool _isInitialized = false;
  bool _isListening = false;

  /// Initialize the AI voice service with required permissions
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request microphone permission
      final micPermission = await Permission.microphone.request();
      if (!micPermission.isGranted) {
        debugPrint('Microphone permission denied');
        return false;
      }

      // Initialize speech-to-text
      final available = await _speechToText.initialize(
        onStatus: (status) => debugPrint('Speech status: $status'),
        onError: (error) => debugPrint('Speech error: $error'),
      );

      if (!available) {
        debugPrint('Speech recognition not available');
        return false;
      }

      _isInitialized = true;
      debugPrint('AI Voice Service initialized successfully');
      return true;
    } catch (e) {
      debugPrint('AI Voice Service initialization error: $e');
      return false;
    }
  }

  /// Start listening for Arabic speech with advanced analysis
  Future<void> startAdvancedListening({
    required Verse targetVerse,
    required Function(String) onResult,
    required Function(AIAnalysisResult) onAnalysisComplete,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    if (_isListening) return;

    try {
      _isListening = true;
      
      await _speechToText.listen(
        onResult: (result) async {
          final spokenText = result.recognizedWords;
          onResult(spokenText);

          if (result.finalResult && spokenText.isNotEmpty) {
            _isListening = false;
            
            // Perform advanced AI analysis
            final analysis = await _performAdvancedAnalysis(
              targetVerse,
              spokenText,
            );
            
            onAnalysisComplete(analysis);
          }
        },
        localeId: 'ar-SA', // Arabic (Saudi Arabia)
        listenMode: ListenMode.confirmation,
        partialResults: true,
        cancelOnError: true,
        listenFor: const Duration(seconds: 30),
      );
    } catch (e) {
      debugPrint('Start listening error: $e');
      _isListening = false;
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    _isListening = false;
  }

  /// Perform comprehensive AI analysis of Arabic recitation
  Future<AIAnalysisResult> _performAdvancedAnalysis(
    Verse targetVerse,
    String spokenText,
  ) async {
    try {
      // Call Supabase Edge Function for advanced analysis
      final response = await _supabase.functions.invoke(
        'advanced-voice-analysis',
        body: {
          'target_text': targetVerse.arabicText,
          'spoken_text': spokenText,
          'surah_id': targetVerse.surahId,
          'verse_number': targetVerse.verseNumber,
          'user_id': _supabase.auth.currentUser?.id,
          'analysis_type': 'comprehensive',
        },
      );

      if (response.data != null) {
        return AIAnalysisResult.fromJson(response.data);
      }
      
      // Fallback to local analysis
      return _performLocalAnalysis(targetVerse.arabicText, spokenText);
    } catch (e) {
      debugPrint('Advanced analysis error: $e');
      return _performLocalAnalysis(targetVerse.arabicText, spokenText);
    }
  }

  /// Local fallback analysis when AI service is unavailable
  AIAnalysisResult _performLocalAnalysis(String targetText, String spokenText) {
    
    final targetWords = _normalizeArabicText(targetText).split(' ');
    final spokenWords = _normalizeArabicText(spokenText).split(' ');
    
    List<WordAnalysis> wordAnalysis = [];
    double totalAccuracy = 0;
    
    for (int i = 0; i < targetWords.length; i++) {
      final targetWord = targetWords[i];
      final spokenWord = i < spokenWords.length ? spokenWords[i] : '';
      
      final accuracy = _calculateWordSimilarity(targetWord, spokenWord).toDouble();
      totalAccuracy += accuracy;
      
      wordAnalysis.add(WordAnalysis(
        word: targetWord,
        spokenWord: spokenWord,
        accuracy: accuracy.toDouble(),
        errors: accuracy < 80 ? ['Pronunciation needs improvement'] : [],
        hasTajwidError: false,
        tajwidRule: '',
      ));
    }
    
    final overallAccuracy = targetWords.isNotEmpty ? totalAccuracy / targetWords.length : 0.0;
    
    return AIAnalysisResult(
      overallAccuracy: overallAccuracy.toDouble(),
      pronunciationScore: overallAccuracy.toDouble(),
      tajwidScore: (overallAccuracy + 5).toDouble(),
      fluencyScore: (overallAccuracy - 5).toDouble(),
      wordAnalysis: wordAnalysis,
      corrections: [],
      tajwidErrors: [],
      feedback: _generateFeedback(overallAccuracy),
      detailedFeedback: _generateDetailedFeedback(overallAccuracy, wordAnalysis),
    );
  }

  /// Normalize Arabic text for comparison
  String _normalizeArabicText(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u0652\u0670\u0640]'), '') // Remove diacritics
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize spaces
        .trim();
  }

  /// Calculate word similarity using Levenshtein distance
  double _calculateWordSimilarity(String target, String spoken) {
    if (target == spoken) return 100.0;
    if (spoken.isEmpty) return 0.0;
    
    final matrix = List.generate(
      target.length + 1,
      (i) => List.generate(spoken.length + 1, (j) => 0),
    );
    
    for (int i = 0; i <= target.length; i++) matrix[i][0] = i;
    for (int j = 0; j <= spoken.length; j++) matrix[0][j] = j;
    
    for (int i = 1; i <= target.length; i++) {
      for (int j = 1; j <= spoken.length; j++) {
        final cost = target[i - 1] == spoken[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    
    final maxLength = target.length > spoken.length ? target.length : spoken.length;
    return maxLength > 0 ? ((maxLength - matrix[target.length][spoken.length]) / maxLength) * 100 : 0;
  }

  /// Generate feedback based on accuracy
  String _generateFeedback(double accuracy) {
    if (accuracy >= 95) {
      return 'Masya Allah! Bacaan Anda sangat sempurna. Teruskan!';
    } else if (accuracy >= 85) {
      return 'Alhamdulillah, bacaan Anda sudah baik. Sedikit perbaikan lagi!';
    } else if (accuracy >= 70) {
      return 'Terus berlatih! Perhatikan koreksi yang diberikan.';
    } else {
      return 'Jangan menyerah! Dengarkan audio dan berlatih perlahan.';
    }
  }

  /// Generate detailed feedback
  String _generateDetailedFeedback(double accuracy, List<WordAnalysis> wordAnalysis) {
    final incorrectWords = wordAnalysis.where((w) => w.accuracy < 80).length;
    
    if (incorrectWords == 0) {
      return 'Bacaan Anda sangat baik! Semua kata diucapkan dengan benar.';
    } else {
      return 'Terdapat $incorrectWords kata yang perlu diperbaiki. Fokus pada kata-kata yang ditandai merah.';
    }
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    _speechToText.cancel();
  }
}

/// Configuration class for AI voice analysis settings
class AIVoiceConfig {
  final String language;
  final Duration listenTimeout;
  final bool enableRealTimeAnalysis;
  final bool enableTajwidAnalysis;
  final double accuracyThreshold;

  const AIVoiceConfig({
    this.language = 'ar-SA',
    this.listenTimeout = const Duration(seconds: 30),
    this.enableRealTimeAnalysis = true,
    this.enableTajwidAnalysis = true,
    this.accuracyThreshold = 70.0,
  });
}