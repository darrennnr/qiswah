import 'package:flutter/material.dart';

class AppColors {
  // Tartil Classic Theme
  static const Color primaryDark = Color(0xFF2C3E50);
  static const Color secondaryGreen = Color(0xFF27AE60);
  static const Color accentGold = Color(0xFFF1C40F);
  static const Color surfaceDark = Color(0xFF34495E);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFBDC3C7);
  static const Color successGreen = Color(0xFF2ECC71);
  static const Color errorRed = Color(0xFFE74C3C);
  
  // Night Mode Theme
  static const Color nightBackground = Color(0xFF1E1E1E);
  static const Color nightSurface = Color(0xFF2D2D2D);
  static const Color nightText = Color(0xFFDADADA);
  static const Color nightTextSecondary = Color(0xFFA0A0A0);
  static const Color nightAccent = Color(0xFF3498DB);
}

class AppConstants {
  static const String appName = 'Al-Qur\'an Memorization';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String prayerTimesAPI = 'https://api.aladhan.com/v1/timings';
  static const String quranAPI = 'https://api.quran.com/api/v4';
  
  // Audio URLs
  static const String audioBaseURL = 'https://cdn.islamic.network/quran/audio';
  
  // Supabase Edge Functions
  static const String voiceAnalysisFunction = 'voice-analysis';
  static const String progressTrackingFunction = 'progress-tracking';
}

class AppTextStyles {
  static const TextStyle arabicLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 24,
    height: 2.0,
    color: AppColors.textWhite,
  );
  
  static const TextStyle arabicMedium = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18,
    height: 1.8,
    color: AppColors.textWhite,
  );
  
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textWhite,
  );
  
  static const TextStyle captionText = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}