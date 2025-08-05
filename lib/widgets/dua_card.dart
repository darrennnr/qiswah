import 'package:flutter/material.dart';
import '../models/dua_models.dart';
import '../utils/constants.dart';

class DuaCard extends StatelessWidget {
  final Dua dua;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onPlayTap;

  const DuaCard({
    super.key,
    required this.dua,
    required this.isFavorite,
    this.onFavoriteTap,
    this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.nightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildArabicText(),
          const SizedBox(height: 12),
          _buildTransliteration(),
          const SizedBox(height: 8),
          _buildTranslation(),
          const SizedBox(height: 12),
          _buildOccasion(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            dua.title,
            style: AppTextStyles.bodyText.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.accentGold,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onPlayTap,
              icon: const Icon(
                Icons.play_circle_outline,
                color: AppColors.secondaryGreen,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: onFavoriteTap,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.errorRed : AppColors.textSecondary,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArabicText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        dua.arabicText,
        style: AppTextStyles.arabicLarge.copyWith(fontSize: 22),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildTransliteration() {
    return Text(
      dua.transliteration,
      style: AppTextStyles.bodyText.copyWith(
        color: AppColors.nightAccent,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildTranslation() {
    return Text(
      dua.translation,
      style: AppTextStyles.bodyText.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }

  Widget _buildOccasion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryGreen, width: 1),
      ),
      child: Text(
        dua.occasion,
        style: AppTextStyles.captionText.copyWith(
          color: AppColors.secondaryGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}