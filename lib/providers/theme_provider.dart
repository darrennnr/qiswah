import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? _nightTheme : _tartilTheme;

  ThemeProvider() {
    _loadThemePreference();
  }

  void _loadThemePreference() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  ThemeData get _tartilTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryGreen,
      tertiary: AppColors.accentGold,
      surface: AppColors.surfaceDark,
      background: AppColors.nightBackground,
      onPrimary: AppColors.nightBackground,
      onSecondary: AppColors.nightBackground,
      onSurface: AppColors.nightBackground,
      onBackground: AppColors.textWhite,
      error: AppColors.errorRed,
    ),
    scaffoldBackgroundColor: AppColors.nightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.nightBackground,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.nightBackground,
    selectedItemColor: AppColors.accentGold,
    unselectedItemColor: AppColors.textSecondary,
    type: BottomNavigationBarType.fixed,
  ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.nightBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  ThemeData get _nightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDark,
      secondary: AppColors.successGreen,
      tertiary: AppColors.nightAccent,
      surface: AppColors.nightSurface,
      background: AppColors.nightBackground,
      onPrimary: AppColors.nightBackground,
      onSecondary: AppColors.nightBackground,
      onSurface: AppColors.nightText,
      onBackground: AppColors.nightText,
      error: AppColors.errorRed,
    ),
    scaffoldBackgroundColor: AppColors.nightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.nightBackground,
      foregroundColor: AppColors.nightText,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
  backgroundColor: AppColors.nightBackground,
  selectedItemColor: AppColors.nightAccent,
  unselectedItemColor: AppColors.nightTextSecondary,
  type: BottomNavigationBarType.fixed,
),

  );
}