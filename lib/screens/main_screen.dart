import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/memorization_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/quran_provider.dart';
import '../utils/constants.dart';
import 'quran/quran_screen.dart';
import 'memorization/memorization_screen.dart';
import 'prayer/prayer_screen.dart';
import 'rewards/rewards_screen.dart';
import 'profile/profile_screen.dart';
import 'juz/juz_screen.dart';
import 'settings/settings_screen.dart';
import 'bookmarks/bookmarks_screen.dart';
import 'statistics/statistics_screen.dart';
import 'help/help_screen.dart';
import 'dua/dua_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QuranScreen(),
    const JuzScreen(),
    const DuaScreen(),
    const MemorizationScreen(),
    const PrayerScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MemorizationProvider>(context, listen: false).loadProgress();
      Provider.of<PrayerProvider>(context, listen: false).getCurrentLocation();
      Provider.of<QuranProvider>(context, listen: false).loadSurahs();
      Provider.of<QuranProvider>(context, listen: false).loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      drawer: _buildDrawer(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.surfaceDark, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.nightBackground,
          selectedItemColor: AppColors.accentGold,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Al-Qur\'an',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_module),
              label: 'Juz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Doa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: 'Hafalan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Shalat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Rewards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      size: 40,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Al-Qur\'an Memorization',
                    style: AppTextStyles.headingMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.surfaceDark),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: 'Beranda',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.bookmark,
                    title: 'Bookmark',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookmarksScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: 'Riwayat Hafalan',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatisticsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.analytics,
                    title: 'Statistik',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatisticsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: AppColors.surfaceDark),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Pengaturan',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help,
                    title: 'Bantuan',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accentGold),
      title: Text(
        title,
        style: AppTextStyles.bodyText,
      ),
      onTap: onTap,
    );
  }
}