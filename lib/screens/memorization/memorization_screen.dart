import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memorization_provider.dart';
import '../../utils/constants.dart';
import '../../models/quran_models.dart';

class MemorizationScreen extends StatefulWidget {
  const MemorizationScreen({super.key});

  @override
  State<MemorizationScreen> createState() => _MemorizationScreenState();
}

class _MemorizationScreenState extends State<MemorizationScreen> {
  int _currentVerseIndex = 0;
  bool _showArabic = false;

  final List<Verse> _verses = [
    Verse(
      id: 1,
      surahId: 1,
      verseNumber: 1,
      arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      translation: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang',
      transliteration: 'Bismillaahir rahmaanir raheem',
      audioUrl: '',
    ),
    Verse(
      id: 2,
      surahId: 1,
      verseNumber: 2,
      arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      translation: 'Segala puji bagi Allah, Pemelihara semesta alam',
      transliteration: 'Alhamdu lillaahi rabbil aalameen',
      audioUrl: '',
    ),
    Verse(
      id: 3,
      surahId: 1,
      verseNumber: 3,
      arabicText: 'الرَّحْمَٰنِ الرَّحِيمِ',
      translation: 'Yang Maha Pengasih lagi Maha Penyayang',
      transliteration: 'Ar rahmaanir raheem',
      audioUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressSection(),
            Expanded(child: _buildVerseSection()),
            _buildControlsSection(),
            _buildActionsSection(),
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
          Text('Hafalan', style: AppTextStyles.headingLarge),
          const SizedBox(height: 4),
          Text(
            'حفظ القرآن',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.accentGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Hafalan',
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.66,
            backgroundColor: AppColors.surfaceDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryGreen),
          ),
          const SizedBox(height: 8),
          Text(
            '2 dari 3 ayat Al-Fatihah',
            style: AppTextStyles.captionText,
          ),
        ],
      ),
    );
  }

  Widget _buildVerseSection() {
    final currentVerse = _verses[_currentVerseIndex];
    final isCompleted = _currentVerseIndex < 2; // Mock completion status

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Al-Fatihah - Ayat ${currentVerse.verseNumber}',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isCompleted)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.successGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Selesai',
                      style: AppTextStyles.captionText.copyWith(
                        color: AppColors.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (_showArabic || isCompleted)
                  Text(
                    currentVerse.arabicText,
                    style: AppTextStyles.arabicLarge.copyWith(
                      color: isCompleted ? AppColors.successGreen : AppColors.textWhite,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.accentGold,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Tekan mikrofon untuk mulai menghafal',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.accentGold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  currentVerse.translation,
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentVerseIndex > 0
                ? () => setState(() => _currentVerseIndex--)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceDark,
              foregroundColor: AppColors.textWhite,
            ),
            child: const Text('Sebelumnya'),
          ),
          Consumer<MemorizationProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                onTap: () => _handleMicPress(provider),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: provider.isListening 
                        ? AppColors.errorRed 
                        : AppColors.secondaryGreen,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 32,
                    color: AppColors.textWhite,
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: _currentVerseIndex < _verses.length - 1
                ? () => setState(() => _currentVerseIndex++)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceDark,
              foregroundColor: AppColors.textWhite,
            ),
            child: const Text('Selanjutnya'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow, color: AppColors.primaryDark),
            label: const Text('Audio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryGreen,
              foregroundColor: AppColors.textWhite,
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showArabic = false;
              });
            },
            icon: const Icon(Icons.refresh, color: AppColors.primaryDark),
            label: const Text('Ulang'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGold,
              foregroundColor: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMicPress(MemorizationProvider provider) {
    if (provider.isListening) {
      provider.stopListening();
    } else {
      setState(() {
        _showArabic = true;
      });
      provider.startListening(_verses[_currentVerseIndex]);
    }
  }
}