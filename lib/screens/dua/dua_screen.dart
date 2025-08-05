import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dua_provider.dart';
import '../../utils/constants.dart';
import '../../models/dua_models.dart';
import 'dua_category_screen.dart';
import 'dua_search_screen.dart';
import 'favorite_duas_screen.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DuaProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildQuickActions(),
            Expanded(child: _buildCategoriesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceDark, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doa-Doa', style: AppTextStyles.headingLarge),
              const SizedBox(height: 4),
              Text(
                'أدعية',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DuaSearchScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  color: AppColors.accentGold,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteDuasScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.favorite,
                  color: AppColors.errorRed,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              'Doa Harian',
              'أدعية يومية',
              Icons.wb_sunny,
              AppColors.secondaryGreen,
              () => _navigateToCategory('daily'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              'Doa Makan',
              'أدعية الطعام',
              Icons.restaurant,
              AppColors.accentGold,
              () => _navigateToCategory('food'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String arabicTitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyText.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              arabicTitle,
              style: AppTextStyles.captionText.copyWith(
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Consumer<DuaProvider>(
      builder: (context, duaProvider, child) {
        if (duaProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: duaProvider.categories.length,
          itemBuilder: (context, index) {
            final category = duaProvider.categories[index];
            return _buildCategoryCard(category);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(DuaCategory category) {
    final iconData = _getIconData(category.icon);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        tileColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.accentGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            iconData,
            color: AppColors.accentGold,
            size: 24,
          ),
        ),
        title: Text(
          category.name,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              category.arabicName,
              style: AppTextStyles.captionText.copyWith(
                color: AppColors.accentGold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${category.duaCount} doa • ${category.description}',
              style: AppTextStyles.captionText,
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: () => _navigateToCategory(category.id),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sun':
        return Icons.wb_sunny;
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'bedtime':
        return Icons.bedtime;
      case 'mosque':
        return Icons.mosque;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.menu_book;
    }
  }

  void _navigateToCategory(String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuaCategoryScreen(categoryId: categoryId),
      ),
    );
  }
}