import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/prayer_provider.dart';
import '../../utils/constants.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Consumer<PrayerProvider>(
          builder: (context, prayerProvider, child) {
            return Column(
              children: [
                _buildHeader(),
                _buildLocationSection(prayerProvider),
                _buildCurrentTimeSection(),
                _buildNextPrayerSection(prayerProvider),
                Expanded(child: _buildPrayerTimesList(prayerProvider)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceDark, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Waktu Shalat', style: AppTextStyles.headingLarge),
              const SizedBox(height: 4),
              Text(
                'أوقات الصلاة',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: AppColors.accentGold,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(PrayerProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on,
            color: AppColors.accentGold,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            provider.location,
            style: AppTextStyles.captionText,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTimeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              final now = DateTime.now();
              return Text(
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            _getCurrentDate(),
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerSection(PrayerProvider provider) {
    final nextPrayer = provider.prayerTimes.isNotEmpty
        ? provider.prayerTimes.firstWhere(
            (prayer) => prayer.isNext,
            orElse: () => provider.prayerTimes.first,
          )
        : null;

    if (nextPrayer == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Shalat Selanjutnya',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${nextPrayer.name} • ${nextPrayer.arabicName}',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nextPrayer.time,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            provider.calculateTimeUntilNext(),
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textWhite.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesList(PrayerProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jadwal Hari Ini',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: provider.prayerTimes.length,
              itemBuilder: (context, index) {
                final prayer = provider.prayerTimes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: prayer.isNext ? AppColors.accentGold : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prayer.name,
                            style: AppTextStyles.bodyText.copyWith(
                              color: prayer.isNext ? AppColors.primaryDark : AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prayer.arabicName,
                            style: AppTextStyles.captionText.copyWith(
                              color: prayer.isNext ? AppColors.primaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            prayer.time,
                            style: AppTextStyles.bodyText.copyWith(
                              color: prayer.isNext ? AppColors.primaryDark : AppColors.textWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.volume_up,
                              color: prayer.isNext ? AppColors.primaryDark : AppColors.textSecondary,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final weekdays = [
      'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
    ];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${weekdays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}