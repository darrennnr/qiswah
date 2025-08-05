import 'package:flutter/material.dart';
import '../models/quran_models.dart';
import '../services/juz_service.dart';

class JuzProvider extends ChangeNotifier {
  final JuzService _juzService = JuzService();

  List<Juz> _juzList = [];
  List<Verse> _currentJuzVerses = [];
  Juz? _currentJuz;
  bool _isLoading = false;
  Map<int, double> _juzProgress = {};

  List<Juz> get juzList => _juzList;
  List<Verse> get currentJuzVerses => _currentJuzVerses;
  Juz? getCurrentJuz() => _currentJuz;
  bool get isLoading => _isLoading;

  Future<void> loadAllJuz() async {
    _isLoading = true;
    notifyListeners();

    _juzList = await _juzService.getAllJuz();
    
    // Load progress for all juz
    for (int i = 1; i <= 30; i++) {
      _juzProgress[i] = await _juzService.getJuzProgress(i);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadJuzVerses(int juzNumber) async {
    _isLoading = true;
    notifyListeners();

    _currentJuz = await _juzService.getJuzByNumber(juzNumber);
    _currentJuzVerses = await _juzService.getJuzVerses(juzNumber);
    
    _isLoading = false;
    notifyListeners();
  }

  double getJuzProgress(int juzNumber) {
    return _juzProgress[juzNumber] ?? 0.0;
  }

  Future<void> refreshJuzProgress(int juzNumber) async {
    _juzProgress[juzNumber] = await _juzService.getJuzProgress(juzNumber);
    notifyListeners();
  }

  List<Juz> getJuzByRange(int startJuz, int endJuz) {
    return _juzList.where((juz) => 
      juz.number >= startJuz && juz.number <= endJuz
    ).toList();
  }

  Juz? getJuzByNumber(int juzNumber) {
    try {
      return _juzList.firstWhere((juz) => juz.number == juzNumber);
    } catch (e) {
      return null;
    }
  }
}