import 'package:flutter/material.dart';
import '../models/quran_models.dart';
import '../services/quran_service.dart';

class QuranProvider extends ChangeNotifier {
  final QuranService _quranService = QuranService();

  List<Surah> _surahs = [];
  List<Verse> _currentVerses = [];
  Surah? _currentSurah;
  bool _isLoading = false;
  String _displayType = 'full';
  Set<String> _bookmarkedVerses = {};

  List<Surah> get surahs => _surahs;
  List<Verse> get currentVerses => _currentVerses;
  Surah? get currentSurah => _currentSurah;
  bool get isLoading => _isLoading;
  String get displayType => _displayType;
  Set<String> get bookmarkedVerses => _bookmarkedVerses;

  Future<void> loadSurahs() async {
    _isLoading = true;
    notifyListeners();

    _surahs = await _quranService.getAllSurahs();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadVerses(int surahId) async {
    _isLoading = true;
    notifyListeners();

    _currentVerses = await _quranService.getVersesBySurah(surahId);
    _currentSurah = _surahs.firstWhere((s) => s.id == surahId);
    
    _isLoading = false;
    notifyListeners();
  }

  void setDisplayType(String type) {
    _displayType = type;
    notifyListeners();
  }

  Future<void> toggleBookmark(int surahId, int verseNumber) async {
    final key = '$surahId:$verseNumber';
    
    if (_bookmarkedVerses.contains(key)) {
      final success = await _quranService.removeBookmark(surahId, verseNumber);
      if (success) {
        _bookmarkedVerses.remove(key);
      }
    } else {
      final success = await _quranService.addBookmark(surahId, verseNumber);
      if (success) {
        _bookmarkedVerses.add(key);
      }
    }
    
    notifyListeners();
  }

  bool isBookmarked(int surahId, int verseNumber) {
    return _bookmarkedVerses.contains('$surahId:$verseNumber');
  }

  Future<void> loadBookmarks() async {
    try {
      final bookmarks = await _quranService.getUserBookmarks();
      _bookmarkedVerses = bookmarks
          .map((b) => '${b['surah_id']}:${b['verse_number']}')
          .toSet();
      notifyListeners();
    } catch (e) {
      print('Load bookmarks error: $e');
    }
  }
}