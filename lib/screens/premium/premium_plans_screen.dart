import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../services/premium_comparison_service.dart';
import '../../models/premium_models.dart';
import '../../services/premium_service.dart';

class PremiumPlansScreen extends StatefulWidget {
  const PremiumPlansScreen({super.key});

  @override
  State<PremiumPlansScreen> createState() => _PremiumPlansScreenState();
}

class _PremiumPlansScreenState extends State<PremiumPlansScreen> {
  final PremiumService _premiumService = PremiumService();
  String _selectedPlanId = 'yearly';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final plans = PremiumComparisonService.getAvailablePlans();
    
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Pilih Paket Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            _buildPlansList(plans),
            const SizedBox(height: 24),
            _buildFeaturesPreview(),
            const SizedBox(height: 24),
            _buildTestimonials(),
            const SizedBox(height: 24),
            _buildUpgradeButton(plans),
          ],
        ),
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
            Icons.auto_awesome,
            size: 48,
            color: AppColors.primaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'Tingkatkan Pengalaman Hafalan',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Dapatkan akses ke fitur AI terdepan, analisis mendalam, dan konten eksklusif',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(List<PremiumPlan> plans) {
    return Column(
      children: plans.map((plan) => _buildPlanCard(plan)).toList(),
    );
  }

  Widget _buildPlanCard(PremiumPlan plan) {
    final isSelected = _selectedPlanId == plan.id;
    final isYearly = plan.id == 'yearly';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.accentGold : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          if (plan.isPopular)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: AppColors.successGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'PALING POPULER',
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          RadioListTile<String>(
            value: plan.id,
            groupValue: _selectedPlanId,
            onChanged: (value) {
              setState(() {
                _selectedPlanId = value!;
              });
            },
            activeColor: AppColors.accentGold,
            contentPadding: const EdgeInsets.all(20),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name,
                  style: AppTextStyles.headingMedium.copyWith(
                    color: isSelected ? AppColors.accentGold : AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plan.description,
                  style: AppTextStyles.captionText,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp ${_formatPrice(isYearly ? plan.yearlyPrice : plan.monthlyPrice)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.accentGold : AppColors.textWhite,
                      ),
                    ),
                    Text(
                      isYearly ? '/tahun' : '/bulan',
                      style: AppTextStyles.captionText,
                    ),
                  ],
                ),
                if (isYearly) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Hemat Rp ${_formatPrice(plan.yearlySavings)} (${plan.yearlySavingsPercentage.toStringAsFixed(0)}%)',
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.nightAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Gratis ${plan.freeTrialDays} hari',
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.nightAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesPreview() {
    final premiumFeatures = PremiumComparisonService.getPremiumOnlyFeatures();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yang Akan Anda Dapatkan',
            style: AppTextStyles.headingMedium,
          ),
          const SizedBox(height: 16),
          ...premiumFeatures.take(8).map((feature) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.successGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyles.bodyText,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (premiumFeatures.length > 8) ...[
            const SizedBox(height: 8),
            Text(
              'Dan ${premiumFeatures.length - 8} fitur premium lainnya...',
              style: AppTextStyles.captionText.copyWith(
                color: AppColors.accentGold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    final testimonials = [
      {
        'name': 'Ahmad Fauzi',
        'text': 'Fitur AI voice recognition sangat membantu memperbaiki bacaan saya. Sekarang hafalan jadi lebih cepat dan akurat!',
        'rating': 5,
      },
      {
        'name': 'Siti Nurhaliza',
        'text': 'Mentoring 1-on-1 dengan ustadz benar-benar game changer. Feedback yang diberikan sangat personal dan membantu.',
        'rating': 5,
      },
      {
        'name': 'Muhammad Rizki',
        'text': 'Analytics yang detail membantu saya memahami progress hafalan. Rekomendasi AI-nya juga sangat tepat sasaran.',
        'rating': 5,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apa Kata Pengguna Premium',
          style: AppTextStyles.headingMedium,
        ),
        const SizedBox(height: 16),
        ...testimonials.map((testimonial) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.accentGold,
                      child: Text(
                        testimonial['name'].toString().substring(0, 1),
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testimonial['name'] as String,
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                size: 16,
                                color: index < (testimonial['rating'] as int)
                                    ? AppColors.accentGold
                                    : AppColors.textSecondary,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  testimonial['text'] as String,
                  style: AppTextStyles.captionText.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildUpgradeButton(List<PremiumPlan> plans) {
    final selectedPlan = plans.firstWhere((plan) => plan.id == _selectedPlanId);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.nightAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.nightAccent, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.security, color: AppColors.nightAccent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gratis ${selectedPlan.freeTrialDays} hari • Batalkan kapan saja • Tanpa komitmen',
                  style: AppTextStyles.captionText.copyWith(
                    color: AppColors.nightAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _handleUpgrade(selectedPlan),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGold,
              foregroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: AppColors.primaryDark,
                  )
                : Text(
                    'Mulai Gratis ${selectedPlan.freeTrialDays} Hari',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Setelah trial berakhir: ${_formatPrice(selectedPlan.id == 'yearly' ? selectedPlan.yearlyPrice : selectedPlan.monthlyPrice)}/${selectedPlan.id == 'yearly' ? 'tahun' : 'bulan'}',
          style: AppTextStyles.captionText,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Future<void> _handleUpgrade(PremiumPlan plan) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _premiumService.startFreeTrial();
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selamat! Free trial ${plan.freeTrialDays} hari dimulai'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memulai free trial. Silakan coba lagi.'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}