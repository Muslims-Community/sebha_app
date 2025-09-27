import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr.dart';

class CustomDhikrNotifier extends StateNotifier<List<Dhikr>> {
  CustomDhikrNotifier() : super([]) {
    _loadCustomDhikrs();
  }

  static const String _customDhikrsKey = 'custom_dhikrs';

  Future<void> _loadCustomDhikrs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dhikrsJson = prefs.getString(_customDhikrsKey) ?? '[]';
      final dhikrsList = json.decode(dhikrsJson) as List<dynamic>;

      state = dhikrsList
          .map((json) => Dhikr.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      state = [];
    }
  }

  Future<void> _saveCustomDhikrs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dhikrsJson = json.encode(state.map((dhikr) => dhikr.toJson()).toList());
      await prefs.setString(_customDhikrsKey, dhikrsJson);
    } catch (e) {
      // Handle save error gracefully
    }
  }

  Future<void> addCustomDhikr(Dhikr dhikr) async {
    state = [...state, dhikr];
    await _saveCustomDhikrs();
  }

  Future<void> updateCustomDhikr(String id, Dhikr updatedDhikr) async {
    state = state.map((dhikr) => dhikr.id == id ? updatedDhikr : dhikr).toList();
    await _saveCustomDhikrs();
  }

  Future<void> deleteCustomDhikr(String id) async {
    state = state.where((dhikr) => dhikr.id != id).toList();
    await _saveCustomDhikrs();
  }

  List<Dhikr> getCustomDhikrsByCategory(String categoryId) {
    return state.where((dhikr) => dhikr.categoryId == categoryId).toList();
  }

  Dhikr? getCustomDhikrById(String id) {
    try {
      return state.firstWhere((dhikr) => dhikr.id == id);
    } catch (e) {
      return null;
    }
  }
}

final customDhikrProvider = StateNotifierProvider<CustomDhikrNotifier, List<Dhikr>>((ref) {
  return CustomDhikrNotifier();
});

// Provider for all dhikrs (default + custom)
final allDhikrsProvider = Provider<List<Dhikr>>((ref) {
  final customDhikrs = ref.watch(customDhikrProvider);

  // For now, we'll need to convert the default dhikrs to the new format
  // This is a simplified version - in a real app, you'd want to migrate the data properly
  final defaultDhikrs = [
    Dhikr.create(
      titleKey: 'سبحان الله',
      arabicText: 'سُبْحَانَ اللَّهِ',
      targetCount: 33,
      categoryId: 'tasbih_classical',
      transliteration: 'Subhan Allah',
      meaningKey: 'Glory be to Allah',
    ),
    Dhikr.create(
      titleKey: 'الحمد لله',
      arabicText: 'الْحَمْدُ لِلَّهِ',
      targetCount: 33,
      categoryId: 'tasbih_classical',
      transliteration: 'Alhamdulillah',
      meaningKey: 'All praise is due to Allah',
    ),
    Dhikr.create(
      titleKey: 'الله أكبر',
      arabicText: 'اللَّهُ أَكْبَرُ',
      targetCount: 34,
      categoryId: 'tasbih_classical',
      transliteration: 'Allahu Akbar',
      meaningKey: 'Allah is the Greatest',
    ),
    Dhikr.create(
      titleKey: 'لا حول ولا قوة إلا بالله',
      arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      targetCount: 100,
      categoryId: 'morning_adhkar',
      transliteration: 'La hawla wa la quwwata illa billah',
      meaningKey: 'There is no power except with Allah',
    ),
    Dhikr.create(
      titleKey: 'الاستغفار',
      arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ',
      targetCount: 100,
      categoryId: 'morning_adhkar',
      transliteration: 'Astaghfiru Allah al-Azeem',
      meaningKey: 'I seek forgiveness from Allah the Magnificent',
    ),
  ];

  return [...defaultDhikrs, ...customDhikrs];
});

// Provider for dhikrs by category
final dhikrsByCategoryProvider = Provider.family<List<Dhikr>, String>((ref, categoryId) {
  final allDhikrs = ref.watch(allDhikrsProvider);
  return allDhikrs.where((dhikr) => dhikr.categoryId == categoryId).toList();
});

// Provider to get a specific dhikr by ID
final dhikrByIdProvider = Provider.family<Dhikr?, String>((ref, id) {
  final allDhikrs = ref.watch(allDhikrsProvider);
  try {
    return allDhikrs.firstWhere((dhikr) => dhikr.id == id);
  } catch (e) {
    return null;
  }
});