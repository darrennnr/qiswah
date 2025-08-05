import 'package:flutter/material.dart';

class AppColors {
  // New Theme - Natural Green
  static const Color primaryDark = Color(0xFF064420);
  static const Color secondaryGreen = Color(0xFF0A5D2C);
  static const Color accentGold = Color(0xFF8B7355);
  static const Color surfaceDark = Color(0xFF0F5A32);
  static const Color textWhite = Color(0xFF064420);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);
  
  // Night Mode Theme
  static const Color nightBackground = Color(0xFFFDFAF6);
  static const Color nightSurface = Color(0xFFF8F5F0);
  static const Color nightText = Color(0xFF064420);
  static const Color nightTextSecondary = Color(0xFF6B7280);
  static const Color nightAccent = Color(0xFF059669);
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