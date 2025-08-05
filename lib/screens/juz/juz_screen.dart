import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/juz_provider.dart';
import '../../utils/constants.dart';
import '../../models/quran_models.dart';
import 'juz_detail_screen.dart';

class JuzScreen extends StatefulWidget {
  const JuzScreen({super.key});

  @override
  State<JuzScreen> createState() => _JuzScreenState();
}

class _JuzScreenState extends State<JuzScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JuzProvider>(context, listen: false).loadAllJuz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildJuzList()),
          ],
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
              Text('30 Juz Al-Qur\'an', style: AppTextStyles.headingLarge),
              const SizedBox(height: 4),
              Text(
                'أجزاء القرآن الثلاثون',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: AppColors.accentGold,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJuzList() {
    return Consumer<JuzProvider>(
      builder: (context, juzProvider, child) {
        if (juzProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final juzNumber = index + 1;
            final juz = juzProvider.juzList.isNotEmpty && index < juzProvider.juzList.length
                ? juzProvider.juzList[index]
                : null;
            
            return _buildJuzCard(juzNumber, juz);
          },
        );
      },
    );
  }

  Widget _buildJuzCard(int juzNumber, Juz? juz) {
    return Consumer<JuzProvider>(
      builder: (context, juzProvider, child) {
        final progress = juzProvider.getJuzProgress(juzNumber);
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JuzDetailScreen(juzNumber: juzNumber),
              ),
            );
          },
          child: Container(
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
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'JUZ $juzNumber',
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          juz?.arabicName ?? 'الجزء ${_getArabicNumber(juzNumber)}',
                          style: AppTextStyles.arabicMedium.copyWith(
                            color: AppColors.accentGold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        if (juz != null && juz.sections.isNotEmpty) ...[
                          Text(
                            'Dimulai dari:',
                            style: AppTextStyles.captionText,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            juz.sections.first.surahName,
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: AppColors.primaryDark,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${progress.toStringAsFixed(0)}% selesai',
                          style: AppTextStyles.captionText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getArabicNumber(int number) {
    const arabicNumbers = [
      '', 'الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس',
      'السادس', 'السابع', 'الثامن', 'التاسع', 'العاشر',
      'الحادي عشر', 'الثاني عشر', 'الثالث عشر', 'الرابع عشر', 'الخامس عشر',
      'السادس عشر', 'السابع عشر', 'الثامن عشر', 'التاسع عشر', 'العشرون',
      'الحادي والعشرون', 'الثاني والعشرون', 'الثالث والعشرون', 'الرابع والعشرون', 'الخامس والعشرون',
      'السادس والعشرون', 'السابع والعشرون', 'الثامن والعشرون', 'التاسع والعشرون', 'الثلاثون'
    ];
    
    return number <= 30 ? arabicNumbers[number] : number.toString();
  }
}