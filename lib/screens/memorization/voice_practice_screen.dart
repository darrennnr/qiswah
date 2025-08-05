import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memorization_provider.dart';
import '../../models/quran_models.dart';
import '../../utils/constants.dart';

class VoicePracticeScreen extends StatefulWidget {
  final Verse verse;

  const VoicePracticeScreen({
    super.key,
    required this.verse,
  });

  @override
  State<VoicePracticeScreen> createState() => _VoicePracticeScreenState();
}

class _VoicePracticeScreenState extends State<VoicePracticeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
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
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text('Latihan Suara - Ayat ${widget.verse.verseNumber}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<MemorizationProvider>(
        builder: (context, provider, child) {
          if (provider.isListening) {
            _pulseController.repeat(reverse: true);
          } else {
            _pulseController.stop();
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInstructionCard(),
                const SizedBox(height: 24),
                _buildVerseCard(),
                const SizedBox(height: 24),
                _buildRecognitionSection(provider),
                const Spacer(),
                _buildMicrophoneButton(provider),
                const SizedBox(height: 24),
                _buildActionButtons(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nightAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.nightAccent, width: 1),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.nightAccent,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            'Tekan tombol mikrofon dan bacakan ayat dengan jelas',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.nightAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            widget.verse.arabicText,
            style: AppTextStyles.arabicLarge.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            widget.verse.transliteration,
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.accentGold,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            widget.verse.translation,
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecognitionSection(MemorizationProvider provider) {
    if (provider.recognizedText.isEmpty && !provider.isListening) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yang Terdengar:',
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (provider.isListening)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Mendengarkan...',
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            )
          else if (provider.recognizedText.isNotEmpty)
            Text(
              provider.recognizedText,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          if (provider.currentAccuracy > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Akurasi: ',
                  style: AppTextStyles.captionText,
                ),
                Text(
                  '${provider.currentAccuracy.toStringAsFixed(1)}%',
                  style: AppTextStyles.captionText.copyWith(
                    color: provider.currentAccuracy >= 90
                        ? AppColors.successGreen
                        : provider.currentAccuracy >= 70
                            ? AppColors.accentGold
                            : AppColors.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMicrophoneButton(MemorizationProvider provider) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: provider.isListening ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _handleMicTap(provider),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: provider.isListening
                    ? AppColors.errorRed
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
                provider.isListening ? Icons.stop : Icons.mic,
                size: 36,
                color: AppColors.textWhite,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(MemorizationProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.play_arrow),
          label: const Text('Dengar Audio'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.nightAccent,
            foregroundColor: AppColors.textWhite,
          ),
        ),
        ElevatedButton.icon(
          onPressed: provider.recognizedText.isNotEmpty
              ? () => _resetPractice(provider)
              : null,
          icon: const Icon(Icons.refresh),
          label: const Text('Ulangi'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGold,
            foregroundColor: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  void _handleMicTap(MemorizationProvider provider) {
    if (provider.isListening) {
      provider.stopListening();
    } else {
      provider.startListening(widget.verse);
    }
  }

  void _resetPractice(MemorizationProvider provider) {
    provider.stopListening();
    // Reset recognition state if needed
  }
}