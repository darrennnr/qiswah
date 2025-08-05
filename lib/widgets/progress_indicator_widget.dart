import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final String title;
  final String subtitle;
  final Color? color;

  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.title,
    required this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.bodyText.copyWith(
                  color: color ?? AppColors.secondaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primaryDark,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.secondaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.captionText,
          ),
        ],
      ),
    );
  }
}