import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memorization_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/progress_indicator_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Statistik'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildOverviewCards(),
            const SizedBox(height: 24),
            _buildProgressChart(),
            const SizedBox(height: 24),
            _buildAccuracyStats(),
            const SizedBox(height: 24),
            _buildStreakInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPeriodButton('Minggu', 'week'),
          _buildPeriodButton('Bulan', 'month'),
          _buildPeriodButton('Tahun', 'year'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String title, String value) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Consumer<MemorizationProvider>(
      builder: (context, provider, child) {
        final totalCompleted = provider.getTotalCompletedVerses();
        
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Ayat Dihafal',
                '$totalCompleted',
                Icons.check_circle,
                AppColors.successGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Rata-rata Akurasi',
                '87%',
                Icons.trending_up,
                AppColors.accentGold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress Hafalan', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bar_chart,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Grafik Progress',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fitur ini akan menampilkan grafik progress hafalan Anda',
                style: AppTextStyles.captionText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccuracyStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tingkat Akurasi', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        ProgressIndicatorWidget(
          progress: 0.87,
          title: 'Akurasi Keseluruhan',
          subtitle: 'Berdasarkan semua latihan',
          color: AppColors.secondaryGreen,
        ),
        const SizedBox(height: 12),
        ProgressIndicatorWidget(
          progress: 0.92,
          title: 'Akurasi Minggu Ini',
          subtitle: 'Peningkatan dari minggu lalu',
          color: AppColors.accentGold,
        ),
      ],
    );
  }

  Widget _buildStreakInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Konsistensi Hafalan', style: AppTextStyles.headingMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Streak Saat Ini',
                    style: AppTextStyles.captionText,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '7 Hari',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Streak Terpanjang',
                    style: AppTextStyles.captionText,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '15 Hari',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Terus pertahankan konsistensi Anda! Hafalan yang konsisten akan memberikan hasil yang lebih baik.',
            style: AppTextStyles.captionText,
          ),
        ],
      ),
    );
  }
}