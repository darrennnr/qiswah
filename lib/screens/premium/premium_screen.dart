import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../services/premium_service.dart';
import '../../services/premium_comparison_service.dart';
import '../../widgets/premium_feature_card.dart';
import 'premium_comparison_screen.dart';
import 'premium_plans_screen.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PremiumService _premiumService = PremiumService();
  Map<String, dynamic> _features = {};
  bool _isPremium = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPremiumFeatures();
    _checkPremiumStatus();
  }

  Future<void> _loadPremiumFeatures() async {
    _features = await _premiumService.getPremiumFeatures();
    setState(() => _isLoading = false);
  }

  Future<void> _checkPremiumStatus() async {
    _isPremium = await _premiumService.isPremiumUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(_isPremium ? 'Premium Active' : 'Upgrade Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PremiumComparisonScreen(),
                ),
              );
            },
            icon: const Icon(Icons.compare_arrows, color: AppColors.accentGold),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isPremium ? _buildPremiumActiveCard() : _buildHeaderCard(),
                  const SizedBox(height: 24),
                  if (!_isPremium) ...[
                    _buildQuickStats(),
                    const SizedBox(height: 24),
                  ],
                  _buildFeaturesList(),
                  const SizedBox(height: 24),
                  if (!_isPremium) ...[
                    _buildPricingCard(),
                    const SizedBox(height: 24),
                    _buildUpgradeButton(),
                  ] else ...[
                    _buildPremiumManagement(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPremiumActiveCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.successGreen, Color(0xFF27AE60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            size: 48,
            color: AppColors.textWhite,
          ),
          const SizedBox(height: 16),
          Text(
            'Premium Active',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda memiliki akses penuh ke semua fitur premium',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textWhite,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentGold, Color(0xFFE67E22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium,
            size: 48,
            color: AppColors.primaryDark,
          ),

          const SizedBox(height: 16),
          Text(
            'Al-Qur\'an Premium',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tingkatkan pengalaman hafalan Anda dengan fitur-fitur eksklusif',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return FutureBuilder<int>(
      future: _premiumService.getDailyVoiceAnalysisUsage(),
      builder: (context, snapshot) {
        final usage = snapshot.data ?? 0;
        final limits = PremiumComparisonService.getFreeUserLimits();
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                'Penggunaan Hari Ini',
                style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUsageItem(
                    'Voice Analysis',
                    '$usage/${limits.dailyAnalysisLimit}',
                    usage / limits.dailyAnalysisLimit,
                  ),
                  _buildUsageItem(
                    'Audio Downloads',
                    '3/10',
                    0.3,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Upgrade ke Premium untuk akses unlimited!',
                style: AppTextStyles.captionText.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsageItem(String title, String usage, double progress) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.captionText),
        const SizedBox(height: 8),
        Text(
          usage,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.bold,
            color: progress > 0.8 ? AppColors.errorRed : AppColors.accentGold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: progress > 0.8 ? AppColors.errorRed : AppColors.accentGold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    if (_features.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isPremium ? 'Fitur Yang Anda Miliki' : 'Fitur Premium',
          style: AppTextStyles.headingMedium,
        ),
        const SizedBox(height: 16),
        ..._features.entries.map((entry) {
          final feature = entry.value;
          return PremiumFeatureCard(
            title: feature['title'],
            description: 'Akses ke ${(feature['benefits'] as List).length} fitur premium',
            icon: _getCategoryIcon(feature['title']),
            isAvailable: feature['available'],
            benefits: List<String>.from(feature['benefits']),
            onTap: () => _showFeatureDetails(feature),
          );
        }).toList(),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'voice recognition':
        return Icons.mic;
      case 'content & audio':
        return Icons.library_music;
      case 'learning & progress':
        return Icons.trending_up;
      case 'community & social':
        return Icons.people;
      case 'app experience':
        return Icons.smartphone;
      default:
        return Icons.star;
    }
  }

  void _showFeatureDetails(Map<String, dynamic> feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(feature['title'], style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur yang tersedia:',
              style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...(feature['benefits'] as List).map((benefit) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      feature['available'] ? Icons.check_circle : Icons.lock,
                      size: 16,
                      color: feature['available'] ? AppColors.successGreen : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: AppTextStyles.captionText,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGold, width: 2),
      ),
      child: Column(
        children: [
          Text('Paket Berlangganan', style: AppTextStyles.headingMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp 29.000',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGold,
                ),
              ),
              Text(
                '/bulan',
                style: AppTextStyles.captionText,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'GRATIS 7 HARI PERTAMA',
              style: AppTextStyles.captionText.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '• Batalkan kapan saja\n• Tanpa komitmen jangka panjang\n• Akses penuh ke semua fitur',
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PremiumPlansScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGold,
          foregroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Lihat Paket Premium',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumManagement() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kelola Premium', style: AppTextStyles.headingMedium),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.receipt, color: AppColors.accentGold),
            title: Text('Riwayat Pembayaran', style: AppTextStyles.bodyText),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.accentGold),
            title: Text('Pengaturan Langganan', style: AppTextStyles.bodyText),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help, color: AppColors.accentGold),
            title: Text('Bantuan Premium', style: AppTextStyles.bodyText),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}