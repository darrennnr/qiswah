import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dua_models.dart';

class DuaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<DuaCategory>> getAllCategories() async {
    try {
      final response = await _supabase
          .from('dua_categories')
          .select('''
            *,
            duas!inner(id)
          ''')
          .order('name');

      return (response as List).map((json) {
        final duaCount = (json['duas'] as List).length;
        return DuaCategory(
          id: json['id'],
          name: json['name'],
          arabicName: json['arabic_name'],
          description: json['description'],
          icon: json['icon'],
          duaCount: duaCount,
        );
      }).toList();
    } catch (e) {
      print('Get dua categories error: $e');
      return _getDefaultCategories();
    }
  }

  Future<List<Dua>> getDuasByCategory(String categoryId) async {
    try {
      final response = await _supabase
          .from('duas')
          .select()
          .eq('category_id', categoryId)
          .order('title');

      return (response as List)
          .map((json) => Dua.fromJson(json))
          .toList();
    } catch (e) {
      print('Get duas by category error: $e');
      return _getDefaultDuas(categoryId);
    }
  }

  Future<List<Dua>> searchDuas(String query) async {
    try {
      final response = await _supabase
          .from('duas')
          .select()
          .or('title.ilike.%$query%,translation.ilike.%$query%')
          .order('title');

      return (response as List)
          .map((json) => Dua.fromJson(json))
          .toList();
    } catch (e) {
      print('Search duas error: $e');
      return [];
    }
  }

  Future<List<Dua>> getFavoriteDuas() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('user_favorite_duas')
          .select('''
            duas (*)
          ''')
          .eq('user_id', userId);

      return (response as List)
          .map((json) => Dua.fromJson(json['duas']))
          .toList();
    } catch (e) {
      print('Get favorite duas error: $e');
      return [];
    }
  }

  Future<bool> toggleFavorite(int duaId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final existing = await _supabase
          .from('user_favorite_duas')
          .select()
          .eq('user_id', userId)
          .eq('dua_id', duaId)
          .maybeSingle();

      if (existing != null) {
        await _supabase
            .from('user_favorite_duas')
            .delete()
            .eq('user_id', userId)
            .eq('dua_id', duaId);
      } else {
        await _supabase
            .from('user_favorite_duas')
            .insert({
              'user_id': userId,
              'dua_id': duaId,
            });
      }

      return true;
    } catch (e) {
      print('Toggle favorite error: $e');
      return false;
    }
  }

  List<DuaCategory> _getDefaultCategories() {
    return [
      DuaCategory(
        id: 'daily',
        name: 'Doa Harian',
        arabicName: 'أدعية يومية',
        description: 'Doa-doa untuk aktivitas sehari-hari',
        icon: 'sun',
        duaCount: 15,
      ),
      DuaCategory(
        id: 'food',
        name: 'Doa Makan',
        arabicName: 'أدعية الطعام',
        description: 'Doa sebelum dan sesudah makan',
        icon: 'restaurant',
        duaCount: 4,
      ),
      DuaCategory(
        id: 'travel',
        name: 'Doa Perjalanan',
        arabicName: 'أدعية السفر',
        description: 'Doa untuk bepergian',
        icon: 'directions_car',
        duaCount: 6,
      ),
      DuaCategory(
        id: 'sleep',
        name: 'Doa Tidur',
        arabicName: 'أدعية النوم',
        description: 'Doa sebelum dan bangun tidur',
        icon: 'bedtime',
        duaCount: 8,
      ),
    ];
  }

  List<Dua> _getDefaultDuas(String categoryId) {
    switch (categoryId) {
      case 'food':
        return [
          Dua(
            id: 1,
            title: 'Doa Sebelum Makan',
            arabicTitle: 'دعاء قبل الطعام',
            arabicText: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
            transliteration: 'Bismillaahi wa \'alaa barakatillaah',
            translation: 'Dengan nama Allah dan atas berkah Allah',
            category: 'food',
            occasion: 'Sebelum makan',
            audioUrl: '',
          ),
          Dua(
            id: 2,
            title: 'Doa Sesudah Makan',
            arabicTitle: 'دعاء بعد الطعام',
            arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
            transliteration: 'Alhamdu lillaahil ladzii ath\'amanaa wa saqaanaa wa ja\'alanaa muslimiin',
            translation: 'Segala puji bagi Allah yang telah memberi kami makan dan minum serta menjadikan kami orang-orang muslim',
            category: 'food',
            occasion: 'Sesudah makan',
            audioUrl: '',
          ),
          Dua(
            id: 3,
            title: 'Doa Sebelum Minum',
            arabicTitle: 'دعاء قبل الشرب',
            arabicText: 'بِسْمِ اللَّهِ',
            transliteration: 'Bismillaah',
            translation: 'Dengan nama Allah',
            category: 'food',
            occasion: 'Sebelum minum',
            audioUrl: '',
          ),
          Dua(
            id: 4,
            title: 'Doa Sesudah Minum',
            arabicTitle: 'دعاء بعد الشرب',
            arabicText: 'الْحَمْدُ لِلَّهِ',
            transliteration: 'Alhamdu lillaah',
            translation: 'Segala puji bagi Allah',
            category: 'food',
            occasion: 'Sesudah minum',
            audioUrl: '',
          ),
        ];
      case 'daily':
        return [
          Dua(
            id: 5,
            title: 'Doa Bangun Tidur',
            arabicTitle: 'دعاء الاستيقاظ',
            arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
            transliteration: 'Alhamdu lillaahil ladzii ahyaanaa ba\'da maa amaatanaa wa ilaihin nusyuur',
            translation: 'Segala puji bagi Allah yang telah menghidupkan kami sesudah kami mati (tidur) dan kepada-Nya kami akan dibangkitkan',
            category: 'daily',
            occasion: 'Bangun tidur',
            audioUrl: '',
          ),
          Dua(
            id: 6,
            title: 'Doa Masuk Kamar Mandi',
            arabicTitle: 'دعاء دخول الخلاء',
            arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
            transliteration: 'Allaahumma innii a\'uudzu bika minal khubutsi wal khabaa\'its',
            translation: 'Ya Allah, sesungguhnya aku berlindung kepada-Mu dari godaan setan laki-laki dan setan perempuan',
            category: 'daily',
            occasion: 'Masuk kamar mandi',
            audioUrl: '',
          ),
        ];
      case 'travel':
        return [
          Dua(
            id: 7,
            title: 'Doa Naik Kendaraan',
            arabicTitle: 'دعاء ركوب الدابة',
            arabicText: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
            transliteration: 'Subhaanalladhii sakhkhara lanaa haadzaa wa maa kunnaa lahu muqriniin wa innaa ilaa rabbinaa lamunqalibuum',
            translation: 'Maha Suci Allah yang telah menundukkan semua ini bagi kami padahal kami sebelumnya tidak mampu menguasainya, dan sesungguhnya kami akan kembali kepada Tuhan kami',
            category: 'travel',
            occasion: 'Naik kendaraan',
            audioUrl: '',
          ),
        ];
      default:
        return [];
    }
  }
}