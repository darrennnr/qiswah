import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/quran_models.dart';
import '../services/voice_analysis_service.dart';
import '../services/premium_service.dart';
import '../widgets/usage_limit_dialog.dart';

class MemorizationProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final SpeechToText _speechToText = SpeechToText();
  final VoiceAnalysisService _voiceService = VoiceAnalysisService();
  final PremiumService _premiumService = PremiumService();

  List<MemorizationProgress> _progress = [];
  bool _isListening = false;
  String _recognizedText = '';
  double _currentAccuracy = 0.0;
  bool _isAnalyzing = false;

  List<MemorizationProgress> get progress => _progress;
  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;
  double get currentAccuracy => _currentAccuracy;
  bool get isAnalyzing => _isAnalyzing;

  Future<void> loadProgress() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('memorization_progress')
          .select()
          .eq('user_id', userId);

      _progress = (response as List)
          .map((json) => MemorizationProgress.fromJson(json))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Load progress error: $e');
    }
  }

  Future<void> startListening(Verse targetVerse, [BuildContext? context]) async {
    // Check if user can use voice analysis
    final canUse = await _premiumService.canUseVoiceAnalysis();
    if (!canUse && context != null) {
      final usage = await _premiumService.getDailyVoiceAnalysisUsage();
      final limits = await _premiumService.getUserLimits();
      
      UsageLimitDialog.show(
        context,
        featureName: 'Voice Analysis',
        currentUsage: usage,
        maxUsage: limits.dailyAnalysisLimit,
        customMessage: 'Premium users mendapat unlimited voice analysis dengan akurasi AI yang lebih tinggi (90-95%)',
      );
      return;
    }
    
    try {
      bool available = await _speechToText.initialize(
        onStatus: (status) => debugPrint('Speech status: $status'),
        onError: (error) => debugPrint('Speech error: $error'),
      );

      if (available) {
        _isListening = true;
        _recognizedText = '';
        notifyListeners();

        await _speechToText.listen(
          onResult: (result) async {
            _recognizedText = result.recognizedWords;
            notifyListeners();

            if (result.finalResult) {
              await _analyzeRecitation(targetVerse, _recognizedText);
            }
          },
          localeId: 'ar-SA', // Arabic locale
          listenMode: ListenMode.confirmation,
        );
      }
    } catch (e) {
      debugPrint('Start listening error: $e');
      _isListening = false;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    notifyListeners();
  }

  Future<void> _analyzeRecitation(Verse targetVerse, String spokenText) async {
    try {
      _isAnalyzing = true;
      notifyListeners();

      // Check if user has premium for advanced analysis
      final isPremium = await _premiumService.isPremiumUser();
      
      final analysis = await _voiceService.analyzeRecitation(
        targetVerse.arabicText,
        spokenText,
        useAdvancedAI: isPremium,
      );

      _currentAccuracy = analysis.accuracy;
      
      await _updateProgress(
        targetVerse.surahId,
        targetVerse.verseNumber,
        analysis.accuracy,
      );

      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Analyze recitation error: $e');
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> _updateProgress(int surahId, int verseNumber, double accuracy) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final existingProgress = _progress.firstWhere(
        (p) => p.surahId == surahId && p.verseNumber == verseNumber,
        orElse: () => MemorizationProgress(
          id: '',
          userId: userId,
          surahId: surahId,
          verseNumber: verseNumber,
          completed: false,
          accuracy: 0.0,
          lastPracticed: DateTime.now(),
          attempts: 0,
        ),
      );

      final updatedProgress = MemorizationProgress(
        id: existingProgress.id,
        userId: userId,
        surahId: surahId,
        verseNumber: verseNumber,
        completed: accuracy >= 90.0,
        accuracy: accuracy,
        lastPracticed: DateTime.now(),
        attempts: existingProgress.attempts + 1,
      );

      if (existingProgress.id.isEmpty) {
        await _supabase.from('memorization_progress').insert(updatedProgress.toJson());
      } else {
        await _supabase
            .from('memorization_progress')
            .update(updatedProgress.toJson())
            .eq('id', existingProgress.id);
      }

      await loadProgress();
    } catch (e) {
      debugPrint('Update progress error: $e');
    }
  }

  double getCompletionPercentage(int surahId, int totalVerses) {
    final completed = _progress
        .where((p) => p.surahId == surahId && p.completed)
        .length;
    return totalVerses > 0 ? (completed / totalVerses) * 100 : 0.0;
  }

  int getTotalCompletedVerses() {
    return _progress.where((p) => p.completed).length;
  }

  Future<bool> canUseAdvancedFeatures() async {
    return await _premiumService.hasFeatureAccess('advanced_voice_analysis');
  }

  Future<void> showPremiumFeatureDialog(BuildContext context, String featureName) async {
    await _premiumService.showPremiumDialog(context);
  }
}