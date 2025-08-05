import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quran_models.dart';

class QuranService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Surah>> getAllSurahs() async {
    try {
      final response = await _supabase
          .from('surahs')
          .select()
          .order('id');

      return (response as List)
          .map((json) => Surah.fromJson(json))
          .toList();
    } catch (e) {
      print('Get surahs error: $e');
      return [];
    }
  }

  Future<List<Verse>> getVersesBySurah(int surahId) async {
    try {
      final response = await _supabase
          .from('verses')
          .select()
          .eq('surah_id', surahId)
          .order('verse_number');

      return (response as List)
          .map((json) => Verse.fromJson(json))
          .toList();
    } catch (e) {
      print('Get verses error: $e');
      return [];
    }
  }

  Future<Verse?> getVerse(int surahId, int verseNumber) async {
    try {
      final response = await _supabase
          .from('verses')
          .select()
          .eq('surah_id', surahId)
          .eq('verse_number', verseNumber)
          .single();

      return Verse.fromJson(response);
    } catch (e) {
      print('Get verse error: $e');
      return null;
    }
  }

  Future<bool> addBookmark(int surahId, int verseNumber, {String? notes}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      await _supabase.from('bookmarks').insert({
        'user_id': userId,
        'surah_id': surahId,
        'verse_number': verseNumber,
        'notes': notes,
      });

      return true;
    } catch (e) {
      print('Add bookmark error: $e');
      return false;
    }
  }

  Future<bool> removeBookmark(int surahId, int verseNumber) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      await _supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('surah_id', surahId)
          .eq('verse_number', verseNumber);

      return true;
    } catch (e) {
      print('Remove bookmark error: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getUserBookmarks() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('bookmarks')
          .select('''
            *,
            surahs (name, arabic_name),
            verses (arabic_text, translation)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get bookmarks error: $e');
      return [];
    }
  }
}