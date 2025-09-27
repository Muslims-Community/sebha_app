import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class CustomCategoriesNotifier extends StateNotifier<List<DhikrCategory>> {
  CustomCategoriesNotifier() : super([]) {
    _loadCustomCategories();
  }

  static const String _storageKey = 'custom_categories';

  Future<void> _loadCustomCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getString(_storageKey);

      if (categoriesJson != null) {
        final List<dynamic> categoriesList = json.decode(categoriesJson);
        state = categoriesList.map((json) => DhikrCategory.fromJson(json)).toList();
      }
    } catch (e) {
      // Handle error silently, keep empty state
    }
  }

  Future<void> _saveCustomCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = json.encode(state.map((category) => category.toJson()).toList());
      await prefs.setString(_storageKey, categoriesJson);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> addCategory(DhikrCategory category) async {
    state = [...state, category];
    await _saveCustomCategories();
  }

  Future<void> updateCategory(String categoryId, DhikrCategory updatedCategory) async {
    state = state.map((category) {
      return category.id == categoryId ? updatedCategory : category;
    }).toList();
    await _saveCustomCategories();
  }

  Future<void> deleteCategory(String categoryId) async {
    state = state.where((category) => category.id != categoryId).toList();
    await _saveCustomCategories();
  }

  DhikrCategory? getCategoryById(String id) {
    try {
      return state.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  List<DhikrCategory> getAllCategories() {
    // Combine default categories with custom categories
    return [...DhikrData.categories, ...state];
  }

  bool isCustomCategory(String categoryId) {
    return state.any((category) => category.id == categoryId);
  }
}

final customCategoriesProvider = StateNotifierProvider<CustomCategoriesNotifier, List<DhikrCategory>>((ref) {
  return CustomCategoriesNotifier();
});

// Helper provider to get all categories (default + custom)
final allCategoriesProvider = Provider<List<DhikrCategory>>((ref) {
  final customCategories = ref.watch(customCategoriesProvider);
  return [...DhikrData.categories, ...customCategories];
});