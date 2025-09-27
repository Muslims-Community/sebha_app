import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class DhikrFavoritesNotifier extends StateNotifier<Set<String>> {
  DhikrFavoritesNotifier() : super(<String>{}) {
    _loadFavorites();
  }

  static const String _favoritesKey = 'dhikr_favorites';

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey) ?? '[]';
      final favoritesList = json.decode(favoritesJson) as List<dynamic>;
      state = Set<String>.from(favoritesList.cast<String>());
    } catch (e) {
      state = <String>{};
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(state.toList());
      await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      // Handle save error gracefully
    }
  }

  Future<void> toggleFavorite(String dhikrId) async {
    if (state.contains(dhikrId)) {
      state = Set.from(state)..remove(dhikrId);
    } else {
      state = Set.from(state)..add(dhikrId);
    }
    await _saveFavorites();
  }

  bool isFavorite(String dhikrId) {
    return state.contains(dhikrId);
  }

  List<Dhikr> getFavoriteDhikrs() {
    return DhikrData.categories
        .expand((category) => category.dhikrs)
        .where((dhikr) => state.contains(dhikr.id))
        .toList();
  }
}

class DhikrRecentlyUsedNotifier extends StateNotifier<List<String>> {
  DhikrRecentlyUsedNotifier() : super([]) {
    _loadRecentlyUsed();
  }

  static const String _recentlyUsedKey = 'dhikr_recently_used';
  static const int maxRecentItems = 10;

  Future<void> _loadRecentlyUsed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentlyUsedJson = prefs.getString(_recentlyUsedKey) ?? '[]';
      final recentlyUsedList = json.decode(recentlyUsedJson) as List<dynamic>;
      state = List<String>.from(recentlyUsedList.cast<String>());
    } catch (e) {
      state = [];
    }
  }

  Future<void> _saveRecentlyUsed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentlyUsedJson = json.encode(state);
      await prefs.setString(_recentlyUsedKey, recentlyUsedJson);
    } catch (e) {
      // Handle save error gracefully
    }
  }

  Future<void> addToRecentlyUsed(String dhikrId) async {
    final newState = List<String>.from(state);

    // Remove if already exists
    newState.remove(dhikrId);

    // Add to the beginning
    newState.insert(0, dhikrId);

    // Keep only the most recent items
    if (newState.length > maxRecentItems) {
      newState.removeRange(maxRecentItems, newState.length);
    }

    state = newState;
    await _saveRecentlyUsed();
  }

  List<Dhikr> getRecentlyUsedDhikrs() {
    final allDhikrs = DhikrData.categories
        .expand((category) => category.dhikrs)
        .toList();

    return state
        .map((dhikrId) {
          try {
            return allDhikrs.firstWhere((dhikr) => dhikr.id == dhikrId);
          } catch (e) {
            return null;
          }
        })
        .where((dhikr) => dhikr != null)
        .cast<Dhikr>()
        .toList();
  }

  Future<void> clearRecentlyUsed() async {
    state = [];
    await _saveRecentlyUsed();
  }
}

// Providers
final dhikrFavoritesProvider = StateNotifierProvider<DhikrFavoritesNotifier, Set<String>>((ref) {
  return DhikrFavoritesNotifier();
});

final dhikrRecentlyUsedProvider = StateNotifierProvider<DhikrRecentlyUsedNotifier, List<String>>((ref) {
  return DhikrRecentlyUsedNotifier();
});

// Helper providers
final favoriteDhikrsProvider = Provider<List<Dhikr>>((ref) {
  final favoritesNotifier = ref.read(dhikrFavoritesProvider.notifier);
  return favoritesNotifier.getFavoriteDhikrs();
});

final recentlyUsedDhikrsProvider = Provider<List<Dhikr>>((ref) {
  final recentlyUsedNotifier = ref.read(dhikrRecentlyUsedProvider.notifier);
  return recentlyUsedNotifier.getRecentlyUsedDhikrs();
});