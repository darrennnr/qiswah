import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';
import '../premium/premium_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                    _buildProfileSection(context),
                    const SizedBox(height: 24),
                    _buildStatsSection(),
                    const SizedBox(height: 24),
                    _buildSettingsSection(context),
                    const SizedBox(height: 24),
                    _buildPremiumSection(context),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context),
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
          Text('Profile', style: AppTextStyles.headingLarge),
          const SizedBox(height: 4),
          Text(
            'الملف الشخصي',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.accentGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.person,
            size: 48,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ahmad Fauzi',
          style: AppTextStyles.headingLarge.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          'ahmad.fauzi@email.com',
          style: AppTextStyles.bodyText.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PremiumScreen(),
              ),
            );
          },
          icon: const Icon(Icons.crop, color: AppColors.primaryDark),
          label: const Text('Upgrade Premium'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGold,
            foregroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    final stats = [
      {'label': 'Ayat Dihafal', 'value': '25', 'color': AppColors.secondaryGreen},
      {'label': 'Hari Streak', 'value': '7', 'color': AppColors.accentGold},
      {'label': 'Total Poin', 'value': '250', 'color': AppColors.nightAccent},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistik', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: stats.map((stat) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      stat['value'] as String,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: stat['color'] as Color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat['label'] as String,
                      style: AppTextStyles.captionText,
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

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pengaturan', style: AppTextStyles.headingMedium),
        const SizedBox(height: 16),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'Mode Malam',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
                activeColor: AppColors.secondaryGreen,
              ),
            );
          },
        ),
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'Notifikasi',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.secondaryGreen,
          ),
        ),
        _buildSettingItem(
          icon: Icons.volume_up,
          title: 'Notifikasi Adzan',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.secondaryGreen,
          ),
        ),
        _buildSettingItem(
          icon: Icons.edit,
          title: 'Edit Profile',
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        tileColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(icon, color: AppColors.accentGold),
        title: Text(
          title,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildPremiumSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGold, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.crop,
            size: 32,
            color: AppColors.accentGold,
          ),
          const SizedBox(height: 12),
          Text(
            'Upgrade ke Premium',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Dapatkan akses ke semua fitur termasuk voice recognition, koreksi otomatis, dan rewards eksklusif',
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PremiumScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGold,
              foregroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Mulai Gratis 7 Hari',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).signOut();
        },
        icon: const Icon(Icons.logout, color: AppColors.errorRed),
        label: const Text(
          'Keluar',
          style: TextStyle(
            color: AppColors.errorRed,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
