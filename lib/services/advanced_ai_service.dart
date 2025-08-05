import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../models/quran_models.dart';

class AdvancedAIService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AIAnalysisResult> analyzeRecitationAdvanced({
    required String targetText,
    required String spokenText,
    required String audioPath,
    required int surahId,
    required int verseNumber,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'advanced-voice-analysis',
        body: {
          'target_text': targetText,
          'spoken_text': spokenText,
          'audio_path': audioPath,
          'surah_id': surahId,
          'verse_number': verseNumber,
          'user_id': _supabase.auth.currentUser?.id,
          'analysis_type': 'comprehensive',
        },
      );

      if (response.data != null) {
        return AIAnalysisResult.fromJson(response.data);
      }
      
      return _fallbackAnalysis(targetText, spokenText);
    } catch (e) {
      print('Advanced AI analysis error: $e');
      return _fallbackAnalysis(targetText, spokenText);
    }
  }

  Future<AIAnalysisResult> analyzeTajwidRules({
    required String targetText,
    required String spokenText,
    required int surahId,
    required int verseNumber,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'tajwid-analysis',
        body: {
          'target_text': targetText,
          'spoken_text': spokenText,
          'surah_id': surahId,
          'verse_number': verseNumber,
          'user_id': _supabase.auth.currentUser?.id,
        },
      );

      if (response.data != null) {
        return AIAnalysisResult.fromJson(response.data);
      }
      
      return _fallbackTajwidAnalysis(targetText, spokenText);
    } catch (e) {
      print('Tajwid analysis error: $e');
      return _fallbackTajwidAnalysis(targetText, spokenText);
    }
  }

  Future<List<String>> getPersonalizedRecommendations() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase.functions.invoke(
        'personalized-recommendations',
        body: {
          'user_id': userId,
        },
      );

      if (response.data != null && response.data['recommendations'] != null) {
        return List<String>.from(response.data['recommendations']);
      }
      
      return _getDefaultRecommendations();
    } catch (e) {
      print('Get recommendations error: $e');
      return _getDefaultRecommendations();
    }
  }

  Future<Map<String, dynamic>> getDetailedProgress() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return {};

      final response = await _supabase.functions.invoke(
        'detailed-progress-analysis',
        body: {
          'user_id': userId,
        },
      );

      return response.data ?? {};
    } catch (e) {
      print('Get detailed progress error: $e');
      return {};
    }
  }

  AIAnalysisResult _fallbackAnalysis(String target, String spoken) {
    final targetWords = target.split(' ');
    final spokenWords = spoken.split(' ');
    
    List<WordAnalysis> wordAnalysis = [];
    double totalAccuracy = 0;
    
    for (int i = 0; i < targetWords.length; i++) {
      final targetWord = targetWords[i];
      final spokenWord = i < spokenWords.length ? spokenWords[i] : '';
      
      final accuracy = _calculateWordSimilarity(targetWord, spokenWord);
      totalAccuracy += accuracy;
      
      wordAnalysis.add(WordAnalysis(
        word: targetWord,
        spokenWord: spokenWord,
        accuracy: accuracy,
        errors: accuracy < 80 ? ['Pronunciation needs improvement'] : [],
        hasTajwidError: false,
        tajwidRule: '',
      ));
    }
    
    final overallAccuracy = targetWords.isNotEmpty ? totalAccuracy / targetWords.length : 0.0;
    
    return AIAnalysisResult(
      overallAccuracy: overallAccuracy,
      pronunciationScore: overallAccuracy,
      tajwidScore: overallAccuracy + 5,
      fluencyScore: overallAccuracy - 5,
      wordAnalysis: wordAnalysis,
      corrections: [],
      tajwidErrors: [],
      feedback: _generateFeedback(overallAccuracy),
      detailedFeedback: _generateDetailedFeedback(overallAccuracy, wordAnalysis),
    );
  }

  AIAnalysisResult _fallbackTajwidAnalysis(String target, String spoken) {
    final analysis = _fallbackAnalysis(target, spoken);
    
    // Add basic Tajwid checking
    List<String> tajwidErrors = [];
    if (target.contains('الله')) {
      tajwidErrors.add('Perhatikan lafadz Allah - harus dibaca dengan tebal');
    }
    if (target.contains('الرحمن')) {
      tajwidErrors.add('Ar-Rahman memerlukan ghunnah (dengung)');
    }
    
    return AIAnalysisResult(
      overallAccuracy: analysis.overallAccuracy,
      pronunciationScore: analysis.pronunciationScore,
      tajwidScore: analysis.tajwidScore,
      fluencyScore: analysis.fluencyScore,
      wordAnalysis: analysis.wordAnalysis,
      corrections: analysis.corrections,
      tajwidErrors: tajwidErrors,
      feedback: analysis.feedback,
      detailedFeedback: analysis.detailedFeedback,
    );
  }

  double _calculateWordSimilarity(String target, String spoken) {
    if (target == spoken) return 100.0;
    if (spoken.isEmpty) return 0.0;
    
    // Simple Levenshtein distance calculation
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
    return maxLength > 0 ? ((maxLength - matrix[target.length][spoken.length]) / maxLength) * 100.0 : 0.0;
  }

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

  String _generateDetailedFeedback(double accuracy, List<WordAnalysis> wordAnalysis) {
    final incorrectWords = wordAnalysis.where((w) => w.accuracy < 80).length;
    
    if (incorrectWords == 0) {
      return 'Bacaan Anda sangat baik! Semua kata diucapkan dengan benar.';
    } else {
      return 'Terdapat $incorrectWords kata yang perlu diperbaiki. Fokus pada kata-kata yang ditandai merah.';
    }
  }

  List<String> _getDefaultRecommendations() {
    return [
      'Berlatih membaca Al-Fatihah setiap hari',
      'Dengarkan audio Qur\'an dari qari favorit',
      'Pelajari kaidah tajwid dasar',
      'Berlatih dengan ayat-ayat pendek terlebih dahulu',
      'Konsisten berlatih 15 menit setiap hari',
    ];
  }
}