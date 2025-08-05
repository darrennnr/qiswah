import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/premium_service.dart';

class UsageLimitDialog extends StatelessWidget {
  final String featureName;
  final int currentUsage;
  final int maxUsage;
  final String upgradeMessage;

  const UsageLimitDialog({
    super.key,
    required this.featureName,
    required this.currentUsage,
    required this.maxUsage,
    required this.upgradeMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.nightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(Icons.warning, color: AppColors.errorRed),
          const SizedBox(width: 8),
          Text(
            'Batas Penggunaan',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.errorRed,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anda telah mencapai batas penggunaan $featureName untuk hari ini.',
            style: AppTextStyles.bodyText,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Penggunaan Hari Ini:', style: AppTextStyles.captionText),
                    Text(
                      '$currentUsage/$maxUsage',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: currentUsage / maxUsage,
                  backgroundColor: AppColors.surfaceDark,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.errorRed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentGold, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.crop, color: AppColors.accentGold, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Premium Benefits',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  upgradeMessage,
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Nanti', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            PremiumService().showPremiumDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGold,
            foregroundColor: AppColors.primaryDark,
          ),
          child: const Text('Upgrade Premium'),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required String featureName,
    required int currentUsage,
    required int maxUsage,
    String? customMessage,
  }) {
    showDialog(
      context: context,
      builder: (context) => UsageLimitDialog(
        featureName: featureName,
        currentUsage: currentUsage,
        maxUsage: maxUsage,
        upgradeMessage: customMessage ?? 
            'Dengan Premium, Anda mendapat akses unlimited ke semua fitur tanpa batasan harian.',
      ),
    );
  }
}