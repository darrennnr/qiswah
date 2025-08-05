import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/premium_models.dart';
import 'premium_comparison_service.dart';

class PremiumService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> isPremiumUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .from('user_profiles')
          .select('is_premium, premium_expires_at')
          .eq('id', userId)
          .single();

      final isPremium = response['is_premium'] as bool;
      final expiresAt = response['premium_expires_at'] as String?;

      if (!isPremium) return false;

      if (expiresAt != null) {
        final expiry = DateTime.parse(expiresAt);
        return DateTime.now().isBefore(expiry);
      }

      return isPremium;
    } catch (e) {
      debugPrint('Check premium status error: $e');
      return false;
    }
  }

  Future<bool> startFreeTrial() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final expiryDate = DateTime.now().add(const Duration(days: 7));

      await _supabase
          .from('user_profiles')
          .update({
            'is_premium': true,
            'premium_expires_at': expiryDate.toIso8601String(),
          })
          .eq('id', userId);

      return true;
    } catch (e) {
      debugPrint('Start free trial error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getPremiumFeatures() async {
    final isPremium = await isPremiumUser();
    final features = PremiumComparisonService.getCategoryBenefits();
    
    Map<String, dynamic> result = {};
    
    features.forEach((category, benefits) {
      result[category.toLowerCase().replaceAll(' ', '_')] = {
        'title': category,
        'benefits': benefits,
        'available': isPremium,
      };
    });
    
    return result;
  }

  Future<VoiceAnalysisLimits> getUserLimits() async {
    final isPremium = await isPremiumUser();
    return isPremium 
        ? PremiumComparisonService.getPremiumUserLimits()
        : PremiumComparisonService.getFreeUserLimits();
  }

  Future<bool> canUseVoiceAnalysis() async {
    final limits = await getUserLimits();
    
    if (limits.dailyAnalysisLimit == -1) {
      return true; // Unlimited for premium users
    }
    
    // Check daily usage for free users
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;
    
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final response = await _supabase
          .from('voice_recordings')
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', startOfDay.toIso8601String());
      
      final todayUsage = (response as List).length;
      return todayUsage < limits.dailyAnalysisLimit;
    } catch (e) {
      debugPrint('Check voice analysis usage error: $e');
      return false;
    }
  }

  Future<int> getDailyVoiceAnalysisUsage() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 0;
    
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final response = await _supabase
          .from('voice_recordings')
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', startOfDay.toIso8601String());
      
      return (response as List).length;
    } catch (e) {
      debugPrint('Get daily usage error: $e');
      return 0;
    }
  }

  Future<List<PremiumPlan>> getAvailablePlans() async {
    return PremiumComparisonService.getAvailablePlans();
  }

  Future<void> showPremiumDialog(BuildContext context) async {
    final isPremium = await isPremiumUser();
    
    if (isPremium) {
      _showAlreadyPremiumDialog(context);
      return;
    }
    
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFF1C40F)),
            const SizedBox(width: 8),
            Text(
              'Upgrade Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tingkatkan pengalaman hafalan Anda dengan fitur AI terdepan',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            _buildPremiumFeaturesList(),
          ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nanti', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => _navigateToPremiumPlans(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1C40F),
              foregroundColor: const Color(0xFF2C3E50),
            ),
            child: const Text('Lihat Paket Premium'),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeaturesList() {
    final premiumFeatures = [
      '🎯 Unlimited Voice Analysis',
      '🤖 Advanced AI Accuracy (90-95%)',
      '📊 Real-time Tajwid Correction',
      '💡 Personalized AI Feedback',
      '📱 Offline Mode',
      '🎵 15+ Premium Qari',
      '🔊 HD Audio Quality',
      '📚 Complete Tafsir',
      '📈 Advanced Analytics',
      '👥 Premium Community',
    ];

    return Column(
      children: premiumFeatures.take(6).map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(feature.substring(0, 2), style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature.substring(3),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showAlreadyPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF34495E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Anda Sudah Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Anda sudah memiliki akses ke semua fitur premium. Nikmati pengalaman hafalan terbaik!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFF1C40F))),
          ),
        ],
      ),
    );
  }

  void _navigateToPremiumPlans(BuildContext context) {
    Navigator.pop(context);
    // This would navigate to premium plans screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPlansScreen()));
  }

  Future<bool> hasFeatureAccess(String featureId) async {
    final isPremium = await isPremiumUser();
    
    // Define which features require premium
    final premiumOnlyFeatures = [
      'offline_voice_recognition',
      'advanced_tajwid',
      'detailed_reports',
      'unlimited_analysis',
      'premium_qari',
      'hd_audio',
      'complete_tafsir',
      'mentoring',
      'premium_community',
      'priority_support',
    ];
    
    if (premiumOnlyFeatures.contains(featureId)) {
      return isPremium;
    }
    
    return true; // Free features
  }
}