import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quran_models.dart';


class JuzService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Juz>> getAllJuz() async {
    try {
      final response = await _supabase
          .from('juz')
          .select('''
            *,
            juz_sections (
              surah_id,
              start_verse,
              end_verse,
              surahs (name)
            )
          ''')
          .order('number');

      return (response as List).map((json) {
        final sections = (json['juz_sections'] as List).map((section) {
          return JuzSection(
            surahId: section['surah_id'],
            surahName: section['surahs']['name'],
            startVerse: section['start_verse'],
            endVerse: section['end_verse'],
          );
        }).toList();

        return Juz(
          number: json['number'],
          name: json['name'],
          arabicName: json['arabic_name'],
          sections: sections,
        );
      }).toList();
    } catch (e) {
      print('Get juz error: $e');
      return [];
    }
  }

  Future<Juz?> getJuzByNumber(int juzNumber) async {
    try {
      final response = await _supabase
          .from('juz')
          .select('''
            *,
            juz_sections (
              surah_id,
              start_verse,
              end_verse,
              surahs (name)
            )
          ''')
          .eq('number', juzNumber)
          .single();

      final sections = (response['juz_sections'] as List).map((section) {
        return JuzSection(
          surahId: section['surah_id'],
          surahName: section['surahs']['name'],
          startVerse: section['start_verse'],
          endVerse: section['end_verse'],
        );
      }).toList();

      return Juz(
        number: response['number'],
        name: response['name'],
        arabicName: response['arabic_name'],
        sections: sections,
      );
    } catch (e) {
      print('Get juz by number error: $e');
      return null;
    }
  }

  Future<List<Verse>> getJuzVerses(int juzNumber) async {
    try {
      final response = await _supabase
          .from('verses')
          .select('''
            *,
            surahs (name, arabic_name)
          ''')
          .eq('juz_number', juzNumber)
          .order('surah_id')
          .order('verse_number');

      return (response as List)
          .map((json) => Verse.fromJson(json))
          .toList();
    } catch (e) {
      print('Get juz verses error: $e');
      return [];
    }
  }

  Future<double> getJuzProgress(int juzNumber) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0.0;

      // Get total verses in juz
      final totalVersesResponse = await _supabase
          .from('verses')
          .select('id')
          .eq('juz_number', juzNumber);

      final totalVerses = (totalVersesResponse as List).length;

      if (totalVerses == 0) return 0.0;

      // Get completed verses in juz
      final verseIds = (totalVersesResponse as List).map((v) => v['id']).toList();

      final completedResponse = await _supabase
          .from('memorization_progress')
          .select('id')
          .eq('user_id', userId)
          .eq('completed', true)
          .filter('verse_id', 'in', '(${verseIds.join(',')})');


      final completedVerses = (completedResponse as List).length;

      return (completedVerses / totalVerses) * 100;
    } catch (e) {
      print('Get juz progress error: $e');
      return 0.0;
    }
  }
}