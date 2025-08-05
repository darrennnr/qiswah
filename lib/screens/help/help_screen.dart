import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Cara Menggunakan Aplikasi',
              [
                _buildFAQItem(
                  'Bagaimana cara memulai hafalan?',
                  'Pilih surah yang ingin dihafal dari menu Al-Qur\'an, lalu tekan tombol "Mulai Hafalan". Anda dapat berlatih dengan fitur voice recognition untuk mendapatkan koreksi otomatis.',
                ),
                _buildFAQItem(
                  'Bagaimana cara kerja voice recognition?',
                  'Tekan tombol mikrofon dan bacakan ayat dengan jelas. Aplikasi akan menganalisis bacaan Anda dan memberikan skor akurasi serta koreksi jika diperlukan.',
                ),
                _buildFAQItem(
                  'Apa itu sistem poin dan achievement?',
                  'Setiap kali Anda berhasil menghafal ayat atau mencapai target tertentu, Anda akan mendapatkan poin dan badge achievement. Ini untuk memotivasi konsistensi hafalan.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Fitur Premium',
              [
                _buildFAQItem(
                  'Apa keuntungan upgrade ke Premium?',
                  'Fitur Premium memberikan akses ke voice recognition yang lebih akurat, koreksi Tajwid otomatis, analisis detail, dan konten eksklusif.',
                ),
                _buildFAQItem(
                  'Bagaimana cara upgrade ke Premium?',
                  'Buka menu Profile dan pilih "Upgrade Premium". Anda dapat mencoba gratis selama 7 hari sebelum berlangganan.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Troubleshooting',
              [
                _buildFAQItem(
                  'Voice recognition tidak berfungsi',
                  'Pastikan Anda memberikan izin mikrofon dan berada di tempat yang tenang. Periksa juga koneksi internet untuk fitur AI analysis.',
                ),
                _buildFAQItem(
                  'Data hafalan hilang',
                  'Data hafalan disimpan secara otomatis di cloud. Pastikan Anda login dengan akun yang sama dan memiliki koneksi internet.',
                ),
                _buildFAQItem(
                  'Notifikasi tidak muncul',
                  'Periksa pengaturan notifikasi di menu Settings dan pastikan aplikasi memiliki izin notifikasi di pengaturan sistem.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: AppTextStyles.captionText.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Butuh Bantuan Lebih Lanjut?', style: AppTextStyles.headingMedium),
          const SizedBox(height: 16),
          Text(
            'Jika Anda masih memiliki pertanyaan atau mengalami masalah, jangan ragu untuk menghubungi tim support kami.',
            style: AppTextStyles.captionText.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.email, color: AppColors.accentGold, size: 20),
              const SizedBox(width: 12),
              Text(
                'support@quranapp.com',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.accentGold, size: 20),
              const SizedBox(width: 12),
              Text(
                'Senin - Jumat, 09:00 - 17:00 WIB',
                style: AppTextStyles.captionText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}