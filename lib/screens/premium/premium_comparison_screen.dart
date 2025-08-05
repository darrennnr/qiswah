import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../services/premium_comparison_service.dart';
import '../../models/premium_models.dart';

class PremiumComparisonScreen extends StatefulWidget {
  const PremiumComparisonScreen({super.key});

  @override
  State<PremiumComparisonScreen> createState() => _PremiumComparisonScreenState();
}

class _PremiumComparisonScreenState extends State<PremiumComparisonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Voice Recognition',
    'Content',
    'Learning',
    'Experience',
    'Community',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Premium vs Gratis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentGold,
          labelColor: AppColors.accentGold,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Perbandingan'),
            Tab(text: 'Keuntungan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComparisonTab(),
          _buildBenefitsTab(),
        ],
      ),
      bottomNavigationBar: _buildUpgradeButton(),
    );
  }

  Widget _buildComparisonTab() {
    final comparisons = PremiumComparisonService.getFeatureComparisons();
    final filteredComparisons = _selectedCategory == 'All'
        ? comparisons
        : comparisons.where((c) => c.category == _selectedCategory).toList();

    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: filteredComparisons.length,
            itemBuilder: (context, index) {
              final comparison = filteredComparisons[index];
              return _buildComparisonCard(comparison);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsTab() {
    final benefits = PremiumComparisonService.getCategoryBenefits();
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: benefits.keys.length,
      itemBuilder: (context, index) {
        final category = benefits.keys.elementAt(index);
        final categoryBenefits = benefits[category]!;
        
        return _buildBenefitCategory(category, categoryBenefits);
      },
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: AppColors.surfaceDark,
              selectedColor: AppColors.accentGold,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primaryDark : AppColors.textWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildComparisonCard(PremiumComparison comparison) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: comparison.isPremiumOnly
            ? Border.all(color: AppColors.accentGold, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    comparison.feature,
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: comparison.isPremiumOnly 
                          ? AppColors.accentGold 
                          : AppColors.textWhite,
                    ),
                  ),
                ),
                if (comparison.isPremiumOnly)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PREMIUM',
                      style: AppTextStyles.captionText.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(color: AppColors.primaryDark, height: 1),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GRATIS',
                        style: AppTextStyles.captionText.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comparison.freeVersion,
                        style: AppTextStyles.bodyText.copyWith(
                          color: comparison.freeVersion.contains('Tidak tersedia')
                              ? AppColors.errorRed
                              : AppColors.textWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppColors.primaryDark,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREMIUM',
                        style: AppTextStyles.captionText.copyWith(
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comparison.premiumVersion,
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCategory(String category, List<String> benefits) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: AppColors.primaryDark,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  category,
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: benefits.map((benefit) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.successGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: AppTextStyles.bodyText,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.primaryDark, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: AppColors.accentGold, size: 20),
              const SizedBox(width: 8),
              Text(
                'Upgrade ke Premium',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Mulai dari Rp 29.000/bulan',
                style: AppTextStyles.captionText,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to premium upgrade screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGold,
                foregroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Coba Gratis 7 Hari',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Voice Recognition':
        return Icons.mic;
      case 'Content & Audio':
        return Icons.library_music;
      case 'Learning & Progress':
        return Icons.trending_up;
      case 'Community & Social':
        return Icons.people;
      case 'App Experience':
        return Icons.smartphone;
      default:
        return Icons.star;
    }
  }
}