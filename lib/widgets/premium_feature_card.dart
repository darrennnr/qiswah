import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PremiumFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isAvailable;
  final VoidCallback? onTap;
  final List<String>? benefits;

  const PremiumFeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isAvailable,
    this.onTap,
    this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: isAvailable
              ? Border.all(color: AppColors.successGreen, width: 2)
              : Border.all(color: AppColors.accentGold.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isAvailable 
                        ? AppColors.successGreen.withOpacity(0.2)
                        : AppColors.accentGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    icon,
                    color: isAvailable ? AppColors.successGreen : AppColors.accentGold,
                    size: 24,
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
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? AppColors.successGreen : AppColors.accentGold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTextStyles.captionText,
                      ),
                    ],
                  ),
                ),
                if (!isAvailable)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PREMIUM',
                      style: AppTextStyles.captionText.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            if (benefits != null && benefits!.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...benefits!.take(3).map((benefit) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.lock,
                        size: 16,
                        color: isAvailable ? AppColors.successGreen : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: AppTextStyles.captionText.copyWith(
                            color: isAvailable ? AppColors.textWhite : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (benefits!.length > 3) ...[
                const SizedBox(height: 4),
                Text(
                  'Dan ${benefits!.length - 3} benefit lainnya...',
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.accentGold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}