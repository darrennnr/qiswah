class Surah {
  final int id;
  final String name;
  final String arabicName;
  final String englishName;
  final int verses;
  final String revelation;
  final String description;
  final int juzNumber;

  Surah({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.englishName,
    required this.verses,
    required this.revelation,
    required this.description,
    required this.juzNumber,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabic_name'],
      englishName: json['english_name'],
      verses: json['verses'],
      revelation: json['revelation'],
      description: json['description'] ?? '',
      juzNumber: json['juz_number'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arabic_name': arabicName,
      'english_name': englishName,
      'verses': verses,
      'revelation': revelation,
      'description': description,
      'juz_number': juzNumber,
    };
  }
}

class Verse {
  final int id;
  final int surahId;
  final int verseNumber;
  final String arabicText;
  final String translation;
  final String transliteration;
  final String audioUrl;

  Verse({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    required this.arabicText,
    required this.translation,
    required this.transliteration,
    required this.audioUrl,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      surahId: json['surah_id'],
      verseNumber: json['verse_number'],
      arabicText: json['arabic_text'],
      translation: json['translation'],
      transliteration: json['transliteration'],
      audioUrl: json['audio_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surah_id': surahId,
      'verse_number': verseNumber,
      'arabic_text': arabicText,
      'translation': translation,
      'transliteration': transliteration,
      'audio_url': audioUrl,
    };
  }
}

class Juz {
  final int number;
  final String name;
  final String arabicName;
  final List<JuzSection> sections;

  Juz({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.sections,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      number: json['number'],
      name: json['name'],
      arabicName: json['arabic_name'],
      sections: (json['sections'] as List)
          .map((section) => JuzSection.fromJson(section))
          .toList(),
    );
  }
}

class JuzSection {
  final int surahId;
  final String surahName;
  final int startVerse;
  final int endVerse;

  JuzSection({
    required this.surahId,
    required this.surahName,
    required this.startVerse,
    required this.endVerse,
  });

  factory JuzSection.fromJson(Map<String, dynamic> json) {
    return JuzSection(
      surahId: json['surah_id'],
      surahName: json['surah_name'],
      startVerse: json['start_verse'],
      endVerse: json['end_verse'],
    );
  }
}

class AIAnalysisResult {
  final double overallAccuracy;
  final double pronunciationScore;
  final double tajwidScore;
  final double fluencyScore;
  final List<WordAnalysis> wordAnalysis;
  final List<String> corrections;
  final List<String> tajwidErrors;
  final String feedback;
  final String detailedFeedback;

  AIAnalysisResult({
    required this.overallAccuracy,
    required this.pronunciationScore,
    required this.tajwidScore,
    required this.fluencyScore,
    required this.wordAnalysis,
    required this.corrections,
    required this.tajwidErrors,
    required this.feedback,
    required this.detailedFeedback,
  });

  factory AIAnalysisResult.fromJson(Map<String, dynamic> json) {
    return AIAnalysisResult(
      overallAccuracy: json['overall_accuracy'].toDouble(),
      pronunciationScore: json['pronunciation_score'].toDouble(),
      tajwidScore: json['tajwid_score'].toDouble(),
      fluencyScore: json['fluency_score'].toDouble(),
      wordAnalysis: (json['word_analysis'] as List)
          .map((word) => WordAnalysis.fromJson(word))
          .toList(),
      corrections: List<String>.from(json['corrections'] ?? []),
      tajwidErrors: List<String>.from(json['tajwid_errors'] ?? []),
      feedback: json['feedback'] ?? '',
      detailedFeedback: json['detailed_feedback'] ?? '',
    );
  }
}

class WordAnalysis {
  final String word;
  final String spokenWord;
  final double accuracy;
  final List<String> errors;
  final bool hasTajwidError;
  final String tajwidRule;

  WordAnalysis({
    required this.word,
    required this.spokenWord,
    required this.accuracy,
    required this.errors,
    required this.hasTajwidError,
    required this.tajwidRule,
  });

  factory WordAnalysis.fromJson(Map<String, dynamic> json) {
    return WordAnalysis(
      word: json['word'],
      spokenWord: json['spoken_word'],
      accuracy: json['accuracy'].toDouble(),
      errors: List<String>.from(json['errors'] ?? []),
      hasTajwidError: json['has_tajwid_error'] ?? false,
      tajwidRule: json['tajwid_rule'] ?? '',
    );
  }
}
class MemorizationProgress {
  final String id;
  final String userId;
  final int surahId;
  final int verseNumber;
  final bool completed;
  final double accuracy;
  final DateTime lastPracticed;
  final int attempts;

  MemorizationProgress({
    required this.id,
    required this.userId,
    required this.surahId,
    required this.verseNumber,
    required this.completed,
    required this.accuracy,
    required this.lastPracticed,
    required this.attempts,
  });

  factory MemorizationProgress.fromJson(Map<String, dynamic> json) {
    return MemorizationProgress(
      id: json['id'],
      userId: json['user_id'],
      surahId: json['surah_id'],
      verseNumber: json['verse_number'],
      completed: json['completed'],
      accuracy: json['accuracy'].toDouble(),
      lastPracticed: DateTime.parse(json['last_practiced']),
      attempts: json['attempts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'surah_id': surahId,
      'verse_number': verseNumber,
      'completed': completed,
      'accuracy': accuracy,
      'last_practiced': lastPracticed.toIso8601String(),
      'attempts': attempts,
    };
  }
}