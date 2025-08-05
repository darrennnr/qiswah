import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/advanced_ai_provider.dart';
import '../../models/quran_models.dart';
import '../../utils/constants.dart';
import '../../widgets/ai_analysis_widget.dart';

class AdvancedVoicePracticeScreen extends StatefulWidget {
  final List<Verse> verses;
  final int juzNumber;

  const AdvancedVoicePracticeScreen({
    super.key,
    required this.verses,
    required this.juzNumber,
  });

  @override
  State<AdvancedVoicePracticeScreen> createState() => _AdvancedVoicePracticeScreenState();
}

class _AdvancedVoicePracticeScreenState extends State<AdvancedVoicePracticeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _currentVerseIndex = 0;
  bool _showAnalysis = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verses.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: AppBar(title: const Text('Latihan AI')),
        body: const Center(
          child: Text('Tidak ada ayat untuk dilatih'),
        ),
      );
    }

    final currentVerse = widget.verses[_currentVerseIndex];

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text('Latihan AI - Juz ${widget.juzNumber}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showAIFeatures(),
            icon: const Icon(Icons.auto_awesome, color: AppColors.accentGold),
          ),
        ],
      ),
      body: Consumer<AdvancedAIProvider>(
        builder: (context, aiProvider, child) {
          if (aiProvider.isListening) {
            _pulseController.repeat(reverse: true);
          } else {
            _pulseController.stop();
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProgressIndicator(),
                const SizedBox(height: 16),
                _buildVerseCard(currentVerse),
                const SizedBox(height: 20),
                if (_showAnalysis && aiProvider.currentAnalysis != null)
                  Expanded(
                    child: AIAnalysisWidget(
                      analysis: aiProvider.currentAnalysis!,
                      onRetry: () => _startAdvancedAnalysis(aiProvider, currentVerse),
                    ),
                  )
                else
                  Expanded(child: _buildRecognitionSection(aiProvider)),
                _buildMicrophoneButton(aiProvider, currentVerse),
                const SizedBox(height: 20),
                _buildNavigationButtons(aiProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ayat ${_currentVerseIndex + 1} dari ${widget.verses.length}',
                style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '${((_currentVerseIndex + 1) / widget.verses.length * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentVerseIndex + 1) / widget.verses.length,
            backgroundColor: AppColors.primaryDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseCard(Verse verse) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Surah ${verse.surahId} - Ayat ${verse.verseNumber}',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            verse.arabicText,
            style: AppTextStyles.arabicLarge.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            verse.transliteration,
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.accentGold,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            verse.translation,
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecognitionSection(AdvancedAIProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (provider.isListening) ...[
            const Icon(
              Icons.mic,
              size: 48,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Mendengarkan...',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.errorRed,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bacakan ayat dengan jelas',
              style: AppTextStyles.captionText,
            ),
          ] else if (provider.isAnalyzing) ...[
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
            ),
            const SizedBox(height: 16),
            Text(
              'AI sedang menganalisis...',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.accentGold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mohon tunggu sebentar',
              style: AppTextStyles.captionText,
            ),
          ] else if (provider.recognizedText.isNotEmpty) ...[
            const Icon(
              Icons.check_circle,
              size: 48,
              color: AppColors.successGreen,
            ),
            const SizedBox(height: 16),
            Text(
              'Bacaan Selesai',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.successGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan "Lihat Analisis" untuk hasil detail',
              style: AppTextStyles.captionText,
            ),
          ] else ...[
            const Icon(
              Icons.psychology,
              size: 48,
              color: AppColors.accentGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Latihan dengan AI',
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.accentGold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol mikrofon untuk memulai',
              style: AppTextStyles.captionText,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMicrophoneButton(AdvancedAIProvider provider, Verse verse) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: provider.isListening ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _handleMicTap(provider, verse),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: provider.isListening
                    ? AppColors.errorRed
                    : provider.isAnalyzing
                        ? AppColors.textSecondary
                        : AppColors.secondaryGreen,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: (provider.isListening
                            ? AppColors.errorRed
                            : AppColors.secondaryGreen)
                        .withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: provider.isListening ? 10 : 0,
                  ),
                ],
              ),
              child: Icon(
                provider.isListening
                    ? Icons.stop
                    : provider.isAnalyzing
                        ? Icons.hourglass_empty
                        : Icons.mic,
                size: 36,
                color: AppColors.textWhite,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(AdvancedAIProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: _currentVerseIndex > 0 ? _previousVerse : null,
          icon: const Icon(Icons.skip_previous),
          label: const Text('Sebelumnya'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceDark,
            foregroundColor: AppColors.textWhite,
          ),
        ),
        if (provider.currentAnalysis != null)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showAnalysis = !_showAnalysis;
              });
            },
            icon: Icon(_showAnalysis ? Icons.visibility_off : Icons.analytics),
            label: Text(_showAnalysis ? 'Sembunyikan' : 'Lihat Analisis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.nightAccent,
              foregroundColor: AppColors.textWhite,
            ),
          ),
        ElevatedButton.icon(
          onPressed: _currentVerseIndex < widget.verses.length - 1 ? _nextVerse : null,
          icon: const Icon(Icons.skip_next),
          label: const Text('Selanjutnya'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceDark,
            foregroundColor: AppColors.textWhite,
          ),
        ),
      ],
    );
  }

  void _handleMicTap(AdvancedAIProvider provider, Verse verse) {
    if (provider.isListening) {
      provider.stopListening();
    } else if (!provider.isAnalyzing) {
      _startAdvancedAnalysis(provider, verse);
    }
  }

  void _startAdvancedAnalysis(AdvancedAIProvider provider, Verse verse) {
    provider.startAdvancedListening(verse);
    setState(() {
      _showAnalysis = false;
    });
  }

  void _previousVerse() {
    if (_currentVerseIndex > 0) {
      setState(() {
        _currentVerseIndex--;
        _showAnalysis = false;
      });
      Provider.of<AdvancedAIProvider>(context, listen: false).clearAnalysis();
    }
  }

  void _nextVerse() {
    if (_currentVerseIndex < widget.verses.length - 1) {
      setState(() {
        _currentVerseIndex++;
        _showAnalysis = false;
      });
      Provider.of<AdvancedAIProvider>(context, listen: false).clearAnalysis();
    }
  }

  void _showAIFeatures() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.accentGold),
            const SizedBox(width: 8),
            Text('Fitur AI Premium', style: AppTextStyles.headingMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeatureItem('🎯', 'Analisis Akurasi Real-time'),
            _buildFeatureItem('📊', 'Skor Tajwid Otomatis'),
            _buildFeatureItem('🔍', 'Koreksi Per Kata'),
            _buildFeatureItem('💡', 'Rekomendasi Personal'),
            _buildFeatureItem('📈', 'Progress Tracking Detail'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.accentGold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodyText),
        ],
      ),
    );
  }
}