import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _prayerNotifications = true;
  bool _memorizationReminders = true;
  String _selectedReciter = 'Abdul Rahman Al-Sudais';
  double _audioSpeed = 1.0;

  final List<String> _reciters = [
    'Abdul Rahman Al-Sudais',
    'Mishary Rashid Alafasy',
    'Saad Al-Ghamdi',
    'Maher Al-Muaiqly',
    'Ahmed Al-Ajmi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Tampilan'),
            _buildThemeSettings(),
            const SizedBox(height: 24),
            _buildSectionTitle('Audio'),
            _buildAudioSettings(),
            const SizedBox(height: 24),
            _buildSectionTitle('Notifikasi'),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            _buildSectionTitle('Akun'),
            _buildAccountSettings(),
            const SizedBox(height: 24),
            _buildSectionTitle('Tentang'),
            _buildAboutSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.headingMedium,
      ),
    );
  }

  Widget _buildThemeSettings() {
    return Column(
      children: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return _buildSettingTile(
              icon: Icons.dark_mode,
              title: 'Mode Malam',
              subtitle: 'Aktifkan tema gelap',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
                activeColor: AppColors.secondaryGreen,
              ),
            );
          },
        ),
        _buildSettingTile(
          icon: Icons.text_fields,
          title: 'Ukuran Font Arab',
          subtitle: 'Atur ukuran teks Al-Qur\'an',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () => _showFontSizeDialog(),
        ),
      ],
    );
  }

  Widget _buildAudioSettings() {
    return Column(
      children: [
        _buildSettingTile(
          icon: Icons.person,
          title: 'Qari',
          subtitle: _selectedReciter,
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () => _showReciterDialog(),
        ),
        _buildSettingTile(
          icon: Icons.speed,
          title: 'Kecepatan Audio',
          subtitle: '${_audioSpeed}x',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () => _showSpeedDialog(),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        _buildSettingTile(
          icon: Icons.notifications,
          title: 'Notifikasi',
          subtitle: 'Aktifkan semua notifikasi',
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _updateNotificationSettings();
            },
            activeColor: AppColors.secondaryGreen,
          ),
        ),
        _buildSettingTile(
          icon: Icons.access_time,
          title: 'Notifikasi Adzan',
          subtitle: 'Pengingat waktu shalat',
          trailing: Switch(
            value: _prayerNotifications && _notificationsEnabled,
            onChanged: _notificationsEnabled
                ? (value) {
                    setState(() {
                      _prayerNotifications = value;
                    });
                  }
                : null,
            activeColor: AppColors.secondaryGreen,
          ),
        ),
        _buildSettingTile(
          icon: Icons.psychology,
          title: 'Pengingat Hafalan',
          subtitle: 'Notifikasi untuk berlatih hafalan',
          trailing: Switch(
            value: _memorizationReminders && _notificationsEnabled,
            onChanged: _notificationsEnabled
                ? (value) {
                    setState(() {
                      _memorizationReminders = value;
                    });
                  }
                : null,
            activeColor: AppColors.secondaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        _buildSettingTile(
          icon: Icons.person,
          title: 'Edit Profile',
          subtitle: 'Ubah informasi profil',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.security,
          title: 'Keamanan',
          subtitle: 'Ubah password dan keamanan',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.backup,
          title: 'Backup Data',
          subtitle: 'Sinkronisasi progress hafalan',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAboutSettings() {
    return Column(
      children: [
        _buildSettingTile(
          icon: Icons.help,
          title: 'Bantuan',
          subtitle: 'FAQ dan panduan penggunaan',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.info,
          title: 'Tentang Aplikasi',
          subtitle: 'Versi 1.0.0',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () => _showAboutDialog(),
        ),
        _buildSettingTile(
          icon: Icons.logout,
          title: 'Keluar',
          subtitle: 'Logout dari akun',
          trailing: const Icon(Icons.chevron_right, color: AppColors.errorRed),
          onTap: () => _showLogoutDialog(),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
        subtitle: Text(
          subtitle,
          style: AppTextStyles.captionText,
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Ukuran Font Arab', style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pilih ukuran font yang nyaman untuk dibaca', style: AppTextStyles.captionText),
            const SizedBox(height: 16),
            // Font size options would go here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Simpan', style: TextStyle(color: AppColors.accentGold)),
          ),
        ],
      ),
    );
  }

  void _showReciterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Pilih Qari', style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _reciters.map((reciter) {
            return RadioListTile<String>(
              title: Text(reciter, style: AppTextStyles.bodyText),
              value: reciter,
              groupValue: _selectedReciter,
              activeColor: AppColors.accentGold,
              onChanged: (value) {
                setState(() {
                  _selectedReciter = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Kecepatan Audio', style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0.5, 0.75, 1.0, 1.25, 1.5].map((speed) {
            return RadioListTile<double>(
              title: Text('${speed}x', style: AppTextStyles.bodyText),
              value: speed,
              groupValue: _audioSpeed,
              activeColor: AppColors.accentGold,
              onChanged: (value) {
                setState(() {
                  _audioSpeed = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Tentang Aplikasi', style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Al-Qur\'an Memorization App', style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Versi: 1.0.0', style: AppTextStyles.captionText),
            const SizedBox(height: 8),
            Text('Aplikasi untuk membantu menghafal Al-Qur\'an dengan fitur voice recognition dan AI correction.', style: AppTextStyles.captionText),
            const SizedBox(height: 16),
            Text('Dikembangkan dengan ❤️ untuk umat Muslim', style: AppTextStyles.captionText),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Keluar', style: AppTextStyles.headingMedium),
        content: Text('Apakah Anda yakin ingin keluar dari akun?', style: AppTextStyles.bodyText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            child: const Text('Keluar', style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }

  void _updateNotificationSettings() {
    final notificationService = NotificationService();
    if (_notificationsEnabled) {
      notificationService.initialize();
    } else {
      notificationService.cancelAllNotifications();
    }
  }
}