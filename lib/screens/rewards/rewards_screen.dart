import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildPointsSection(),
                    const SizedBox(height: 24),
                    _buildBadgesSection(),
                    const SizedBox(height: 24),
                    _buildAchievementsSection(),
                    const SizedBox(height: 24),
                    _buildStreakSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceDark, width: 1),
        ),
      ),
      child: Column(
        children: [
          Text('Rewards', style: AppTextStyles.headingLarge),
          const SizedBox(height: 4),
          Text(
            'جوائز',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.accentGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Total Poin',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '250',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Terus kumpulkan untuk hadiah menarik!',
            style: AppTextStyles.captionText.copyWith(
              color: AppColors.textWhite,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    final badges = [
      {'name': 'Pemula', 'color': AppColors.textSecondary, 'earned': true},
      {'name': 'Rajin', 'color': AppColors.nightAccent, 'earned': true},
      {'name': 'Konsisten', 'color': AppColors.accentGold, 'earned': false},
      {'name': 'Master', 'color': AppColors.errorRed, 'earned': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Badge Pencapaian', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        Row(
          children: badges.map((badge) {
            final earned = badge['earned'] as bool;
            final color = badge['color'] as Color;
            
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: earned ? color : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 24,
                      color: earned ? AppColors.textWhite : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      badge['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: earned ? AppColors.textWhite : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = [
      {
        'title': 'Hafal Al-Fatihah',
        'description': 'Menyelesaikan hafalan surah Al-Fatihah',
        'points': 100,
        'completed': true,
      },
      {
        'title': 'Konsistensi 7 Hari',
        'description': 'Menggunakan aplikasi 7 hari berturut-turut',
        'points': 150,
        'completed': true,
      },
      {
        'title': 'Target Harian',
        'description': 'Menyelesaikan target hafalan harian',
        'points': 50,
        'completed': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pencapaian', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        ...achievements.map((achievement) {
          final completed = achievement['completed'] as bool;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: completed
                  ? Border.all(color: AppColors.accentGold, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    size: 24,
                    color: completed ? AppColors.accentGold : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement['title'] as String,
                        style: AppTextStyles.bodyText.copyWith(
                          color: completed ? AppColors.textWhite : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement['description'] as String,
                        style: AppTextStyles.captionText,
                      ),
                    ],
                  ),
                ),
                Text(
                  '+${achievement['points']}',
                  style: AppTextStyles.bodyText.copyWith(
                    color: completed ? AppColors.accentGold : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStreakSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('Streak Hafalan', style: AppTextStyles.headingMedium),
          const SizedBox(height: 20),
          const Text(
            '7',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hari Berturut-turut',
            style: AppTextStyles.bodyText,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final completed = index < 7;
              return Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: completed ? AppColors.secondaryGreen : AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: completed ? AppColors.textWhite : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}