class PremiumFeature {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isAvailable;
  final String category;
  final List<String> benefits;

  PremiumFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isAvailable,
    required this.category,
    required this.benefits,
  });

  factory PremiumFeature.fromJson(Map<String, dynamic> json) {
    return PremiumFeature(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      isAvailable: json['is_available'] ?? false,
      category: json['category'],
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }
}

class PremiumPlan {
  final String id;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final int freeTrialDays;
  final List<String> features;
  final bool isPopular;
  final String currency;

  PremiumPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.freeTrialDays,
    required this.features,
    this.isPopular = false,
    this.currency = 'IDR',
  });

  double get yearlySavings => (monthlyPrice * 12) - yearlyPrice;
  double get yearlySavingsPercentage => (yearlySavings / (monthlyPrice * 12)) * 100;
}

class PremiumComparison {
  final String feature;
  final String freeVersion;
  final String premiumVersion;
  final String category;
  final bool isPremiumOnly;

  PremiumComparison({
    required this.feature,
    required this.freeVersion,
    required this.premiumVersion,
    required this.category,
    this.isPremiumOnly = false,
  });
}

class VoiceAnalysisLimits {
  final int dailyAnalysisLimit;
  final int monthlyAnalysisLimit;
  final bool hasAdvancedTajwid;
  final bool hasPersonalizedFeedback;
  final bool hasOfflineMode;
  final bool hasDetailedReports;

  VoiceAnalysisLimits({
    required this.dailyAnalysisLimit,
    required this.monthlyAnalysisLimit,
    required this.hasAdvancedTajwid,
    required this.hasPersonalizedFeedback,
    required this.hasOfflineMode,
    required this.hasDetailedReports,
  });
}