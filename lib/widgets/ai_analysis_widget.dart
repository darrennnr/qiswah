import 'package:flutter/material.dart';
import '../models/quran_models.dart';
import '../utils/constants.dart';

class AIAnalysisWidget extends StatelessWidget {
  final AIAnalysisResult analysis;
  final VoidCallback onRetry;

  const AIAnalysisWidget({
    super.key,
    required this.analysis,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallScore(),
          const SizedBox(height: 16),
          _buildDetailedScores(),
          const SizedBox(height: 16),
          _buildWordAnalysis(),
          const SizedBox(height: 16),
          _buildTajwidAnalysis(),
          const SizedBox(height: 16),
          _buildFeedback(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildOverallScore() {
    final score = analysis.overallAccuracy;
    final color = _getScoreColor(score);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            'Skor Keseluruhan',
            style: AppTextStyles.bodyText.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${score.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getScoreLabel(score),
            style: AppTextStyles.bodyText.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedScores() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analisis Detail',
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildScoreRow('Pengucapan', analysis.pronunciationScore),
          const SizedBox(height: 12),
          _buildScoreRow('Tajwid', analysis.tajwidScore),
          const SizedBox(height: 12),
          _buildScoreRow('Kelancaran', analysis.fluencyScore),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, double score) {
    final color = _getScoreColor(score);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyText),
        Row(
          children: [
            Container(
              width: 100,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: score / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${score.toStringAsFixed(0)}%',
              style: AppTextStyles.bodyText.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWordAnalysis() {
    if (analysis.wordAnalysis.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analisis Per Kata',
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: analysis.wordAnalysis.map((word) {
              final color = _getScoreColor(word.accuracy);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      word.word,
                      style: AppTextStyles.arabicMedium.copyWith(
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${word.accuracy.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTajwidAnalysis() {
    if (analysis.tajwidErrors.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.successGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.successGreen),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.successGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tidak ada kesalahan tajwid ditemukan',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.successGreen,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: AppColors.errorRed),
              const SizedBox(width: 8),
              Text(
                'Koreksi Tajwid',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...analysis.tajwidErrors.map((error) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppColors.errorRed)),
                Expanded(
                  child: Text(
                    error,
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nightAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.nightAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.nightAccent),
              const SizedBox(width: 8),
              Text(
                'Saran AI',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.nightAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            analysis.feedback,
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.nightAccent,
            ),
          ),
          if (analysis.detailedFeedback.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              analysis.detailedFeedback,
              style: AppTextStyles.captionText.copyWith(
                color: AppColors.nightAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Coba Lagi'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGold,
            foregroundColor: AppColors.primaryDark,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.share),
          label: const Text('Bagikan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.nightAccent,
            foregroundColor: AppColors.textWhite,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppColors.successGreen;
    if (score >= 70) return AppColors.accentGold;
    return AppColors.errorRed;
  }

  String _getScoreLabel(double score) {
    if (score >= 95) return 'Sempurna!';
    if (score >= 85) return 'Sangat Baik';
    if (score >= 70) return 'Baik';
    if (score >= 50) return 'Cukup';
    return 'Perlu Latihan';
  }
}