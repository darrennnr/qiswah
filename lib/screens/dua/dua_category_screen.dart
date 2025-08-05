import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dua_provider.dart';
import '../../utils/constants.dart';
import '../../models/dua_models.dart';
import '../../widgets/dua_card.dart';

class DuaCategoryScreen extends StatefulWidget {
  final String categoryId;

  const DuaCategoryScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<DuaCategoryScreen> createState() => _DuaCategoryScreenState();
}

class _DuaCategoryScreenState extends State<DuaCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DuaProvider>(context, listen: false)
          .loadDuasByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(_getCategoryName()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<DuaProvider>(
        builder: (context, duaProvider, child) {
          if (duaProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            );
          }

          if (duaProvider.currentDuas.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: duaProvider.currentDuas.length,
            itemBuilder: (context, index) {
              final dua = duaProvider.currentDuas[index];
              return DuaCard(
                dua: dua,
                isFavorite: duaProvider.isFavorite(dua.id),
                onFavoriteTap: () => duaProvider.toggleFavorite(dua.id),
                onPlayTap: () => _playDua(dua),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Doa',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Doa untuk kategori ini akan segera ditambahkan',
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCategoryName() {
    switch (widget.categoryId) {
      case 'daily':
        return 'Doa Harian';
      case 'food':
        return 'Doa Makan';
      case 'travel':
        return 'Doa Perjalanan';
      case 'sleep':
        return 'Doa Tidur';
      default:
        return 'Doa';
    }
  }

  void _playDua(Dua dua) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memutar audio: ${dua.title}'),
        backgroundColor: AppColors.secondaryGreen,
      ),
    );
  }
}