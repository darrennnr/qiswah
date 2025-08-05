import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/quran_models.dart';
import '../../utils/constants.dart';
import '../../widgets/verse_card.dart';
import '../../providers/memorization_provider.dart';
import '../../providers/quran_provider.dart';
import '../memorization/voice_practice_screen.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  final String displayType;

  const SurahDetailScreen({
    super.key,
    required this.surah,
    required this.displayType,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuranProvider>(context, listen: false)
          .loadVerses(widget.surah.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.surah.name, style: AppTextStyles.headingMedium),
                Text(
                  widget.surah.arabicName,
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: AppColors.accentGold),
              ),
              IconButton(
                onPressed: () => _showOptionsMenu(),
                icon: const Icon(Icons.more_vert, color: AppColors.textWhite),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildSurahInfo(),
              Expanded(child: _buildVersesList(quranProvider)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _startMemorization(quranProvider),
            backgroundColor: AppColors.secondaryGreen,
            icon: const Icon(Icons.psychology, color: AppColors.textWhite),
            label: const Text(
              'Mulai Hafalan',
              style: TextStyle(color: AppColors.textWhite),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahInfo() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '${widget.surah.verses} Ayat • ${widget.surah.revelation}',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Consumer<MemorizationProvider>(
            builder: (context, provider, child) {
              final completion = provider.getCompletionPercentage(
                widget.surah.id,
                widget.surah.verses,
              );
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: completion / 100,
                    backgroundColor: AppColors.textWhite.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Progress Hafalan: ${completion.toStringAsFixed(0)}%',
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVersesList(QuranProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.currentVerses.length,
      itemBuilder: (context, index) {
        final verse = provider.currentVerses[index];
        return VerseCard(
          verse: verse,
          displayType: widget.displayType,
          isBookmarked: provider.isBookmarked(verse.surahId, verse.verseNumber),
          onBookmarkTap: () => provider.toggleBookmark(verse.surahId, verse.verseNumber),
          onPlayTap: () => _playVerse(verse),
        );
      },
    );
  }


  void _playVerse(Verse verse) {
    // Audio playback implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memutar audio ayat ${verse.verseNumber}'),
        backgroundColor: AppColors.secondaryGreen,
      ),
    );
  }

  void _startMemorization(QuranProvider provider) {
    if (provider.currentVerses.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoicePracticeScreen(verse: provider.currentVerses.first),
        ),
      );
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.accentGold),
              title: Text('Download Audio', style: AppTextStyles.bodyText),
              onTap: () {
                Navigator.pop(context);
                _downloadAudio();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.accentGold),
              title: Text('Bagikan Surah', style: AppTextStyles.bodyText),
              onTap: () {
                Navigator.pop(context);
                _shareSurah();
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields, color: AppColors.accentGold),
              title: Text('Pengaturan Teks', style: AppTextStyles.bodyText),
              onTap: () {
                Navigator.pop(context);
                _showTextSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _downloadAudio() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mengunduh audio surah...'),
        backgroundColor: AppColors.secondaryGreen,
      ),
    );
  }

  void _shareSurah() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membagikan surah...'),
        backgroundColor: AppColors.secondaryGreen,
      ),
    );
  }

  void _showTextSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Pengaturan Teks', style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Tampilkan Transliterasi', style: AppTextStyles.bodyText),
              value: widget.displayType == 'full',
              onChanged: (value) {
                // Update display type
              },
              activeColor: AppColors.accentGold,
            ),
            SwitchListTile(
              title: Text('Tampilkan Terjemahan', style: AppTextStyles.bodyText),
              value: widget.displayType == 'full',
              onChanged: (value) {
                // Update display type
              },
              activeColor: AppColors.accentGold,
            ),
          ],
        ),
        actions: [
          Text(
            'Tutup',
            style: TextStyle(color: AppColors.accentGold),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.accentGold)),
          ),
          ],
      ),
    );
  }
}