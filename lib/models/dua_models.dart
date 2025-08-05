class Dua {
  final int id;
  final String title;
  final String arabicTitle;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String category;
  final String occasion;
  final String audioUrl;
  final bool isFavorite;

  Dua({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.category,
    required this.occasion,
    required this.audioUrl,
    this.isFavorite = false,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'],
      title: json['title'],
      arabicTitle: json['arabic_title'],
      arabicText: json['arabic_text'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      category: json['category'],
      occasion: json['occasion'],
      audioUrl: json['audio_url'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabic_title': arabicTitle,
      'arabic_text': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'category': category,
      'occasion': occasion,
      'audio_url': audioUrl,
      'is_favorite': isFavorite,
    };
  }
}

class DuaCategory {
  final String id;
  final String name;
  final String arabicName;
  final String description;
  final String icon;
  final int duaCount;

  DuaCategory({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.description,
    required this.icon,
    required this.duaCount,
  });

  factory DuaCategory.fromJson(Map<String, dynamic> json) {
    return DuaCategory(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabic_name'],
      description: json['description'],
      icon: json['icon'],
      duaCount: json['dua_count'] ?? 0,
    );
  }
}