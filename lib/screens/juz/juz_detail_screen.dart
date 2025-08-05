import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/juz_provider.dart';
import '../../utils/constants.dart';
import '../../models/quran_models.dart';
import '../../widgets/verse_card.dart';
import '../memorization/advanced_voice_practice_screen.dart';

class JuzDetailScreen extends StatefulWidget {
  final int juzNumber;

  const JuzDetailScreen({
    super.key,
    required this.juzNumber,
  });

  @override
  State<JuzDetailScreen> createState() => _JuzDetailScreenState();
}

class _JuzDetailScreenState extends State<JuzDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JuzProvider>(context, listen: false)
          .loadJuzVerses(widget.juzNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuzProvider>(
      builder: (context, juzProvider, child) {
        final juz = juzProvider.getCurrentJuz();
        final verses = juzProvider.currentJuzVerses;
        
        return Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Juz ${widget.juzNumber}', style: AppTextStyles.headingMedium),
                if (juz != null)
                  Text(
                    juz.arabicName,
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.accentGold,
                    ),
                  ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => _showJuzInfo(juz),
                icon: const Icon(Icons.info_outline, color: AppColors.accentGold),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildJuzInfo(juz, juzProvider),
              Expanded(child: _buildVersesList(verses, juzProvider)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _startAdvancedPractice(verses),
            backgroundColor: AppColors.secondaryGreen,
            icon: const Icon(Icons.psychology, color: AppColors.textWhite),
            label: const Text(
              'Latihan AI',
              style: TextStyle(color: AppColors.textWhite),
            ),
          ),
        );
      },
    );
  }

  Widget _buildJuzInfo(Juz? juz, JuzProvider provider) {
    final progress = provider.getJuzProgress(widget.juzNumber);
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (juz != null && juz.sections.isNotEmpty) ...[
            Text(
              'Dimulai dari ${juz.sections.first.surahName} ayat ${juz.sections.first.startVerse}',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Berisi ${juz.sections.length} bagian surah',
              style: AppTextStyles.captionText.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 16),
          ],
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: AppColors.textWhite.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
          const SizedBox(height: 8),
          Text(
            'Progress Hafalan: ${progress.toStringAsFixed(0)}%',
            style: AppTextStyles.captionText.copyWith(
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesList(List<Verse> verses, JuzProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
        ),
      );
    }

    if (verses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.book_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Ayat sedang dimuat...',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final verse = verses[index];
        return VerseCard(
          verse: verse,
          displayType: 'full',
          isBookmarked: false,
          onBookmarkTap: () {},
          onPlayTap: () => _playVerse(verse),
        );
      },
    );
  }

  void _playVerse(Verse verse) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memutar audio ${verse.surahId}:${verse.verseNumber}'),
        backgroundColor: AppColors.secondaryGreen,
      ),
    );
  }

  void _startAdvancedPractice(List<Verse> verses) {
    if (verses.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedVoicePracticeScreen(
            verses: verses,
            juzNumber: widget.juzNumber,
          ),
        ),
      );
    }
  }

  void _showJuzInfo(Juz? juz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Info Juz ${widget.juzNumber}', style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (juz != null) ...[
              Text('Nama Arab: ${juz.arabicName}', style: AppTextStyles.bodyText),
              const SizedBox(height: 12),
              Text('Bagian Surah:', style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...juz.sections.map((section) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${section.surahName} (${section.startVerse}-${section.endVerse})',
                  style: AppTextStyles.captionText,
                ),
              )),
            ] else ...[
              Text('Informasi juz sedang dimuat...', style: AppTextStyles.bodyText),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.accentGold)),
          ),
        ],
      ),
    );
  }
}