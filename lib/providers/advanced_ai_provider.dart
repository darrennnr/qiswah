import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/quran_models.dart';
import '../services/advanced_ai_service.dart';

class AdvancedAIProvider extends ChangeNotifier {
  final AdvancedAIService _aiService = AdvancedAIService();
  final SpeechToText _speechToText = SpeechToText();

  bool _isListening = false;
  bool _isAnalyzing = false;
  String _recognizedText = '';
  AIAnalysisResult? _currentAnalysis;
  List<String> _recommendations = [];

  bool get isListening => _isListening;
  bool get isAnalyzing => _isAnalyzing;
  String get recognizedText => _recognizedText;
  AIAnalysisResult? get currentAnalysis => _currentAnalysis;
  List<String> get recommendations => _recommendations;

  Future<void> startAdvancedListening(Verse targetVerse) async {
    try {
      bool available = await _speechToText.initialize(
        onStatus: (status) => debugPrint('Speech status: $status'),
        onError: (error) => debugPrint('Speech error: $error'),
      );

      if (available) {
        _isListening = true;
        _recognizedText = '';
        _currentAnalysis = null;
        notifyListeners();

        await _speechToText.listen(
          onResult: (result) async {
            _recognizedText = result.recognizedWords;
            notifyListeners();

            if (result.finalResult) {
              await _performAdvancedAnalysis(targetVerse, _recognizedText);
            }
          },
          localeId: 'ar-SA',
          listenMode: ListenMode.confirmation,
        );
      }
    } catch (e) {
      debugPrint('Start advanced listening error: $e');
      _isListening = false;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    notifyListeners();
  }

  Future<void> _performAdvancedAnalysis(Verse targetVerse, String spokenText) async {
    try {
      _isListening = false;
      _isAnalyzing = true;
      notifyListeners();

      // Perform comprehensive AI analysis
      final analysis = await _aiService.analyzeRecitationAdvanced(
        targetText: targetVerse.arabicText,
        spokenText: spokenText,
        audioPath: '', // Would be actual audio path in real implementation
        surahId: targetVerse.surahId,
        verseNumber: targetVerse.verseNumber,
      );

      _currentAnalysis = analysis;
      
      // Get personalized recommendations
      _recommendations = await _aiService.getPersonalizedRecommendations();

      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Advanced analysis error: $e');
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> analyzeTajwidOnly(Verse targetVerse, String spokenText) async {
    try {
      _isAnalyzing = true;
      notifyListeners();

      final analysis = await _aiService.analyzeTajwidRules(
        targetText: targetVerse.arabicText,
        spokenText: spokenText,
        surahId: targetVerse.surahId,
        verseNumber: targetVerse.verseNumber,
      );

      _currentAnalysis = analysis;
      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Tajwid analysis error: $e');
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  void clearAnalysis() {
    _currentAnalysis = null;
    _recognizedText = '';
    _recommendations.clear();
    notifyListeners();
  }

  Future<void> loadRecommendations() async {
    _recommendations = await _aiService.getPersonalizedRecommendations();
    notifyListeners();
  }

  double getOverallProgress() {
    if (_currentAnalysis == null) return 0.0;
    return _currentAnalysis!.overallAccuracy;
  }

  String getProgressFeedback() {
    if (_currentAnalysis == null) return '';
    return _currentAnalysis!.feedback;
  }

  List<WordAnalysis> getWordAnalysis() {
    if (_currentAnalysis == null) return [];
    return _currentAnalysis!.wordAnalysis;
  }

  List<String> getTajwidErrors() {
    if (_currentAnalysis == null) return [];
    return _currentAnalysis!.tajwidErrors;
  }
}