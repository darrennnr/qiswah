import '../models/premium_models.dart';
import '../utils/constants.dart';

class PremiumComparisonService {
  static List<PremiumComparison> getFeatureComparisons() {
    return [
      // Voice Recognition & AI Features
      PremiumComparison(
        feature: 'Analisis Suara Harian',
        freeVersion: '5 analisis per hari',
        premiumVersion: 'Unlimited',
        category: 'Voice Recognition',
      ),
      PremiumComparison(
        feature: 'Akurasi AI',
        freeVersion: 'Standar (70-80%)',
        premiumVersion: 'Advanced (90-95%)',
        category: 'Voice Recognition',
      ),
      PremiumComparison(
        feature: 'Koreksi Tajwid',
        freeVersion: 'Basic',
        premiumVersion: 'Advanced + Real-time',
        category: 'Voice Recognition',
      ),
      PremiumComparison(
        feature: 'Feedback Personal',
        freeVersion: 'Generic',
        premiumVersion: 'AI-Powered Personal',
        category: 'Voice Recognition',
      ),
      PremiumComparison(
        feature: 'Mode Offline',
        freeVersion: 'Tidak tersedia',
        premiumVersion: 'Tersedia',
        category: 'Voice Recognition',
        isPremiumOnly: true,
      ),

      // Content & Audio
      PremiumComparison(
        feature: 'Audio Qari',
        freeVersion: '3 Qari',
        premiumVersion: '15+ Qari Premium',
        category: 'Content',
      ),
      PremiumComparison(
        feature: 'Kualitas Audio',
        freeVersion: 'Standard (128kbps)',
        premiumVersion: 'HD (320kbps)',
        category: 'Content',
      ),
      PremiumComparison(
        feature: 'Download Audio',
        freeVersion: '10 surah',
        premiumVersion: 'Unlimited',
        category: 'Content',
      ),
      PremiumComparison(
        feature: 'Terjemahan Bahasa',
        freeVersion: 'Indonesia, Inggris',
        premiumVersion: '20+ Bahasa',
        category: 'Content',
      ),
      PremiumComparison(
        feature: 'Tafsir Al-Qur\'an',
        freeVersion: 'Tidak tersedia',
        premiumVersion: 'Tafsir Lengkap',
        category: 'Content',
        isPremiumOnly: true,
      ),

      // Learning & Progress
      PremiumComparison(
        feature: 'Target Hafalan',
        freeVersion: 'Basic',
        premiumVersion: 'Custom + Smart Goals',
        category: 'Learning',
      ),
      PremiumComparison(
        feature: 'Progress Analytics',
        freeVersion: 'Basic Stats',
        premiumVersion: 'Advanced Analytics',
        category: 'Learning',
      ),
      PremiumComparison(
        feature: 'Laporan Bulanan',
        freeVersion: 'Tidak tersedia',
        premiumVersion: 'Detailed Reports',
        category: 'Learning',
        isPremiumOnly: true,
      ),
      PremiumComparison(
        feature: 'Rekomendasi AI',
        freeVersion: 'Basic',
        premiumVersion: 'Personalized AI',
        category: 'Learning',
      ),
      PremiumComparison(
        feature: 'Kompetisi & Leaderboard',
        freeVersion: 'Tidak tersedia',
        premiumVersion: 'Global & Friends',
        category: 'Learning',
        isPremiumOnly: true,
      ),

      // App Experience
      PremiumComparison(
        feature: 'Iklan',
        freeVersion: 'Ada iklan',
        premiumVersion: 'Bebas iklan',
        category: 'Experience',
      ),
      PremiumComparison(
        feature: 'Tema Aplikasi',
        freeVersion: '2 tema',
        premiumVersion: '10+ tema premium',
        category: 'Experience',
      ),
      PremiumComparison(
        feature: 'Widget Home Screen',
        freeVersion: 'Basic',
        premiumVersion: 'Advanced + Custom',
        category: 'Experience',
      ),
      PremiumComparison(
        feature: 'Backup Cloud',
        freeVersion: 'Manual',
        premiumVersion: 'Auto + Multi-device',
        category: 'Experience',
      ),
      PremiumComparison(
        feature: 'Priority Support',
        freeVersion: 'Email (48 jam)',
        premiumVersion: 'Chat + Email (2 jam)',
        category: 'Experience',
        isPremiumOnly: true,
      ),

      // Social & Community
      PremiumComparison(
        feature: 'Grup Belajar',
        freeVersion: 'Tidak tersedia',
        premiumVersion: 'Join Premium Groups',
        category: 'Community',
        isPremiumOnly: true,
      ),
      PremiumComparison(
        feature: 'Mentoring Online',
        freeVersion: 'Tidak tersedia',
        premiumVersion: '1-on-1 dengan Ustadz',
        category: 'Community',
        isPremiumOnly: true,
      ),
      PremiumComparison(
        feature: 'Webinar Eksklusif',
        freeVersion: 'Tidak tersedia',
        premiumVersion: 'Monthly Webinars',
        category: 'Community',
        isPremiumOnly: true,
      ),
    ];
  }

  static List<PremiumPlan> getAvailablePlans() {
    return [
      PremiumPlan(
        id: 'monthly',
        name: 'Premium Monthly',
        description: 'Akses penuh fitur premium selama 1 bulan',
        monthlyPrice: 29000,
        yearlyPrice: 29000,
        freeTrialDays: 7,
        features: [
          'Unlimited voice analysis',
          'Advanced AI accuracy',
          'Real-time Tajwid correction',
          'Personalized feedback',
          'Offline mode',
          '15+ premium Qari',
          'HD audio quality',
          'Unlimited downloads',
          '20+ language translations',
          'Complete Tafsir',
          'Advanced analytics',
          'Monthly reports',
          'AI recommendations',
          'Ad-free experience',
          '10+ premium themes',
          'Auto cloud backup',
          'Priority support',
          'Premium community access',
          '1-on-1 mentoring',
          'Exclusive webinars',
        ],
      ),
      PremiumPlan(
        id: 'yearly',
        name: 'Premium Yearly',
        description: 'Hemat 40% dengan berlangganan tahunan',
        monthlyPrice: 29000,
        yearlyPrice: 199000,
        freeTrialDays: 14,
        isPopular: true,
        features: [
          'Semua fitur Premium Monthly',
          'Extended 14-day free trial',
          'Bonus exclusive content',
          'Priority feature requests',
          'Annual progress report',
          'Exclusive yearly challenges',
        ],
      ),
      PremiumPlan(
        id: 'lifetime',
        name: 'Premium Lifetime',
        description: 'Sekali bayar, akses selamanya',
        monthlyPrice: 29000,
        yearlyPrice: 999000,
        freeTrialDays: 30,
        features: [
          'Semua fitur Premium',
          'Lifetime access',
          '30-day free trial',
          'Future updates included',
          'VIP support',
          'Beta features access',
          'Exclusive lifetime badge',
        ],
      ),
    ];
  }

  static VoiceAnalysisLimits getFreeUserLimits() {
    return VoiceAnalysisLimits(
      dailyAnalysisLimit: 5,
      monthlyAnalysisLimit: 100,
      hasAdvancedTajwid: false,
      hasPersonalizedFeedback: false,
      hasOfflineMode: false,
      hasDetailedReports: false,
    );
  }

  static VoiceAnalysisLimits getPremiumUserLimits() {
    return VoiceAnalysisLimits(
      dailyAnalysisLimit: -1, // Unlimited
      monthlyAnalysisLimit: -1, // Unlimited
      hasAdvancedTajwid: true,
      hasPersonalizedFeedback: true,
      hasOfflineMode: true,
      hasDetailedReports: true,
    );
  }

  static List<String> getPremiumOnlyFeatures() {
    return [
      'Mode Offline untuk Voice Recognition',
      'Tafsir Al-Qur\'an Lengkap',
      'Laporan Progress Bulanan',
      'Kompetisi & Leaderboard Global',
      'Priority Support (2 jam response)',
      'Grup Belajar Premium',
      'Mentoring 1-on-1 dengan Ustadz',
      'Webinar Eksklusif Bulanan',
      'Advanced Analytics Dashboard',
      'Custom Learning Goals',
      'Unlimited Audio Downloads',
      '15+ Qari Premium',
      'HD Audio Quality (320kbps)',
      '20+ Bahasa Terjemahan',
      '10+ Tema Premium',
      'Auto Cloud Backup',
      'Widget Home Screen Advanced',
      'Beta Features Access',
    ];
  }

  static Map<String, List<String>> getCategoryBenefits() {
    return {
      'Voice Recognition': [
        'Unlimited daily voice analysis',
        'Advanced AI with 90-95% accuracy',
        'Real-time Tajwid correction',
        'Personalized AI feedback',
        'Offline voice recognition',
        'Word-by-word analysis',
        'Pronunciation scoring',
        'Fluency assessment',
      ],
      'Content & Audio': [
        '15+ premium Qari voices',
        'HD audio quality (320kbps)',
        'Unlimited audio downloads',
        '20+ language translations',
        'Complete Tafsir Al-Qur\'an',
        'Asbabun Nuzul stories',
        'Hadith related to verses',
        'Historical context',
      ],
      'Learning & Progress': [
        'Advanced progress analytics',
        'Monthly detailed reports',
        'AI-powered recommendations',
        'Custom learning goals',
        'Smart study reminders',
        'Adaptive difficulty',
        'Learning streak rewards',
        'Performance predictions',
      ],
      'Community & Social': [
        'Premium learning groups',
        '1-on-1 mentoring sessions',
        'Monthly exclusive webinars',
        'Global competitions',
        'Friend challenges',
        'Community leaderboards',
        'Expert Q&A sessions',
        'Live study sessions',
      ],
      'App Experience': [
        'Completely ad-free',
        '10+ premium themes',
        'Advanced widgets',
        'Auto cloud backup',
        'Multi-device sync',
        'Priority support',
        'Beta features access',
        'Custom notifications',
      ],
    };
  }
}