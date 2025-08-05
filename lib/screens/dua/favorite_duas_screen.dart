import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dua_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/dua_card.dart';

class FavoriteDuasScreen extends StatefulWidget {
  const FavoriteDuasScreen({super.key});

  @override
  State<FavoriteDuasScreen> createState() => _FavoriteDuasScreenState();
}

class _FavoriteDuasScreenState extends State<FavoriteDuasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DuaProvider>(context, listen: false).loadFavoriteDuas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Doa Favorit'),
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

          if (duaProvider.favoriteDuas.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: duaProvider.favoriteDuas.length,
            itemBuilder: (context, index) {
              final dua = duaProvider.favoriteDuas[index];
              return DuaCard(
                dua: dua,
                isFavorite: true,
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
            Icons.favorite_border,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Doa Favorit',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan doa ke favorit dengan menekan ikon hati',
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _playDua(dua) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memutar audio: ${dua.title}'),
        backgroundColor: AppColors.secondaryGreen,
      ),
    );
  }
}