import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dua_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/dua_card.dart';

class DuaSearchScreen extends StatefulWidget {
  const DuaSearchScreen({super.key});

  @override
  State<DuaSearchScreen> createState() => _DuaSearchScreenState();
}

class _DuaSearchScreenState extends State<DuaSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Cari Doa'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.textWhite),
        decoration: InputDecoration(
          hintText: 'Cari doa...',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.accentGold,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<DuaProvider>(context, listen: false).clearSearch();
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                  ),
                )
              : null,
        ),
        onChanged: (query) {
          Provider.of<DuaProvider>(context, listen: false).searchDuas(query);
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<DuaProvider>(
      builder: (context, duaProvider, child) {
        if (duaProvider.searchQuery.isEmpty) {
          return _buildEmptySearch();
        }

        if (duaProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
            ),
          );
        }

        if (duaProvider.searchResults.isEmpty) {
          return _buildNoResults();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: duaProvider.searchResults.length,
          itemBuilder: (context, index) {
            final dua = duaProvider.searchResults[index];
            return DuaCard(
              dua: dua,
              isFavorite: duaProvider.isFavorite(dua.id),
              onFavoriteTap: () => duaProvider.toggleFavorite(dua.id),
              onPlayTap: () => _playDua(dua),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Cari Doa',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ketik kata kunci untuk mencari doa',
            style: AppTextStyles.captionText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ditemukan',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
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