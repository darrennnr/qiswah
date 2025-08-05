import 'package:flutter/material.dart';
import '../models/dua_models.dart';
import '../services/dua_service.dart';

class DuaProvider extends ChangeNotifier {
  final DuaService _duaService = DuaService();

  List<DuaCategory> _categories = [];
  List<Dua> _currentDuas = [];
  List<Dua> _favoriteDuas = [];
  List<Dua> _searchResults = [];
  bool _isLoading = false;
  String _searchQuery = '';
  Set<int> _favoriteIds = {};

  List<DuaCategory> get categories => _categories;
  List<Dua> get currentDuas => _currentDuas;
  List<Dua> get favoriteDuas => _favoriteDuas;
  List<Dua> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    _categories = await _duaService.getAllCategories();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDuasByCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();

    _currentDuas = await _duaService.getDuasByCategory(categoryId);
    await _loadFavoriteIds();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchDuas(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _searchResults = await _duaService.searchDuas(query);
    await _loadFavoriteIds();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavoriteDuas() async {
    _isLoading = true;
    notifyListeners();

    _favoriteDuas = await _duaService.getFavoriteDuas();
    await _loadFavoriteIds();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(int duaId) async {
    final success = await _duaService.toggleFavorite(duaId);
    
    if (success) {
      if (_favoriteIds.contains(duaId)) {
        _favoriteIds.remove(duaId);
      } else {
        _favoriteIds.add(duaId);
      }
      notifyListeners();
    }
  }

  bool isFavorite(int duaId) {
    return _favoriteIds.contains(duaId);
  }

  Future<void> _loadFavoriteIds() async {
    final favorites = await _duaService.getFavoriteDuas();
    _favoriteIds = favorites.map((dua) => dua.id).toSet();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }
}