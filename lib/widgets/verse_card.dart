import 'package:flutter/material.dart';
import '../models/quran_models.dart';
import '../utils/constants.dart';
import '../services/audio_service.dart';

class VerseCard extends StatefulWidget {
  final Verse verse;
  final String displayType;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onPlayTap;

  const VerseCard({
    super.key,
    required this.verse,
    required this.displayType,
    this.isBookmarked = false,
    this.onBookmarkTap,
    this.onPlayTap,
  });

  @override
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard> {
  final AudioService _audioService = AudioService();
  bool _isPlaying = false;

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
          if (widget.displayType == 'full') ...[
            const SizedBox(height: 12),
            _buildTransliteration(),
            const SizedBox(height: 8),
            _buildTranslation(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.accentGold,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '${widget.verse.verseNumber}',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _handlePlayTap,
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.secondaryGreen,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: widget.onBookmarkTap,
              icon: Icon(
                widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: widget.isBookmarked ? AppColors.accentGold : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArabicText() {
    return Text(
      widget.verse.arabicText,
      style: AppTextStyles.arabicLarge,
      textAlign: TextAlign.right,
    );
  }

  Widget _buildTransliteration() {
    return Text(
      widget.verse.transliteration,
      style: AppTextStyles.captionText.copyWith(
        color: AppColors.accentGold,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildTranslation() {
    return Text(
      widget.verse.translation,
      style: AppTextStyles.bodyText.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }

  void _handlePlayTap() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    if (widget.onPlayTap != null) {
      widget.onPlayTap!();
    }
    
    // Simulate audio playback
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    }
  }
}