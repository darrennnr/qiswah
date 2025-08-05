import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quran_provider.dart';
import '../../utils/constants.dart';
import '../../models/quran_models.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryDark,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildSurahList(quranProvider)),
              ],
            ),
          ),
        );
      },
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
              Text('Al-Qur\'an', style: AppTextStyles.headingLarge),
              const SizedBox(height: 4),
              Text(
                'القرآن الكريم',
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


  Widget _buildSurahList(QuranProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.surahs.length,
      itemBuilder: (context, index) {
        final surah = provider.surahs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${surah.id}',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              surah.name,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  surah.arabicName,
                  style: AppTextStyles.arabicMedium.copyWith(
                    color: AppColors.accentGold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${surah.verses} ayat • ${surah.revelation}',
                  style: AppTextStyles.captionText,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.volume_up,
                    color: AppColors.secondaryGreen,
                    size: 20,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(
                    surah: surah,
                    displayType: provider.displayType,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}