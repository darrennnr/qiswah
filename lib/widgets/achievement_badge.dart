import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final String description;
  final int points;
  final bool isUnlocked;
  final Color badgeColor;
  final IconData icon;

  const AchievementBadge({
    super.key,
    required this.title,
    required this.description,
    required this.points,
    required this.isUnlocked,
    required this.badgeColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? badgeColor : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: isUnlocked
            ? Border.all(color: AppColors.accentGold, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.textWhite : AppColors.primaryDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isUnlocked ? badgeColor : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyText.copyWith(
                    color: isUnlocked ? AppColors.textWhite : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.captionText.copyWith(
                    color: isUnlocked ? AppColors.textWhite : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+$points',
            style: AppTextStyles.bodyText.copyWith(
              color: isUnlocked ? AppColors.accentGold : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}