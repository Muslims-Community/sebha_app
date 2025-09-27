import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr.dart';

class PersonalizationSettings {
  final List<String> favoritesDhikrs;
  final Map<String, int> dhikrCustomCounts;
  final String preferredDhikrOrder;
  final bool showProgressAnimation;
  final bool enableSmartSuggestions;
  final List<String> hiddenCategories;
  final Map<String, String> customDhikrNotes;
  final String preferredTimeOfDay;
  final bool adaptiveReminders;
  final double motivationLevel;

  const PersonalizationSettings({
    this.favoritesDhikrs = const [],
    this.dhikrCustomCounts = const {},
    this.preferredDhikrOrder = 'default',
    this.showProgressAnimation = true,
    this.enableSmartSuggestions = true,
    this.hiddenCategories = const [],
    this.customDhikrNotes = const {},
    this.preferredTimeOfDay = 'any',
    this.adaptiveReminders = false,
    this.motivationLevel = 0.5,
  });

  PersonalizationSettings copyWith({
    List<String>? favoritesDhikrs,
    Map<String, int>? dhikrCustomCounts,
    String? preferredDhikrOrder,
    bool? showProgressAnimation,
    bool? enableSmartSuggestions,
    List<String>? hiddenCategories,
    Map<String, String>? customDhikrNotes,
    String? preferredTimeOfDay,
    bool? adaptiveReminders,
    double? motivationLevel,
  }) {
    return PersonalizationSettings(
      favoritesDhikrs: favoritesDhikrs ?? this.favoritesDhikrs,
      dhikrCustomCounts: dhikrCustomCounts ?? this.dhikrCustomCounts,
      preferredDhikrOrder: preferredDhikrOrder ?? this.preferredDhikrOrder,
      showProgressAnimation: showProgressAnimation ?? this.showProgressAnimation,
      enableSmartSuggestions: enableSmartSuggestions ?? this.enableSmartSuggestions,
      hiddenCategories: hiddenCategories ?? this.hiddenCategories,
      customDhikrNotes: customDhikrNotes ?? this.customDhikrNotes,
      preferredTimeOfDay: preferredTimeOfDay ?? this.preferredTimeOfDay,
      adaptiveReminders: adaptiveReminders ?? this.adaptiveReminders,
      motivationLevel: motivationLevel ?? this.motivationLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoritesDhikrs': favoritesDhikrs,
      'dhikrCustomCounts': dhikrCustomCounts,
      'preferredDhikrOrder': preferredDhikrOrder,
      'showProgressAnimation': showProgressAnimation,
      'enableSmartSuggestions': enableSmartSuggestions,
      'hiddenCategories': hiddenCategories,
      'customDhikrNotes': customDhikrNotes,
      'preferredTimeOfDay': preferredTimeOfDay,
      'adaptiveReminders': adaptiveReminders,
      'motivationLevel': motivationLevel,
    };
  }

  factory PersonalizationSettings.fromJson(Map<String, dynamic> json) {
    return PersonalizationSettings(
      favoritesDhikrs: List<String>.from(json['favoritesDhikrs'] ?? []),
      dhikrCustomCounts: Map<String, int>.from(json['dhikrCustomCounts'] ?? {}),
      preferredDhikrOrder: json['preferredDhikrOrder'] ?? 'default',
      showProgressAnimation: json['showProgressAnimation'] ?? true,
      enableSmartSuggestions: json['enableSmartSuggestions'] ?? true,
      hiddenCategories: List<String>.from(json['hiddenCategories'] ?? []),
      customDhikrNotes: Map<String, String>.from(json['customDhikrNotes'] ?? {}),
      preferredTimeOfDay: json['preferredTimeOfDay'] ?? 'any',
      adaptiveReminders: json['adaptiveReminders'] ?? false,
      motivationLevel: (json['motivationLevel'] ?? 0.5).toDouble(),
    );
  }
}

class PersonalizationNotifier extends StateNotifier<PersonalizationSettings> {
  PersonalizationNotifier() : super(const PersonalizationSettings()) {
    _loadSettings();
  }

  static const String _settingsKey = 'personalization_settings';

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        state = PersonalizationSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // Keep default settings
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(state.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      // Handle save error gracefully
    }
  }

  Future<void> addToFavorites(String dhikrId) async {
    if (!state.favoritesDhikrs.contains(dhikrId)) {
      state = state.copyWith(
        favoritesDhikrs: [...state.favoritesDhikrs, dhikrId],
      );
      await _saveSettings();
    }
  }

  Future<void> removeFromFavorites(String dhikrId) async {
    state = state.copyWith(
      favoritesDhikrs: state.favoritesDhikrs.where((id) => id != dhikrId).toList(),
    );
    await _saveSettings();
  }

  Future<void> setCustomCount(String dhikrId, int count) async {
    final newCounts = Map<String, int>.from(state.dhikrCustomCounts);
    newCounts[dhikrId] = count;

    state = state.copyWith(dhikrCustomCounts: newCounts);
    await _saveSettings();
  }

  Future<void> setDhikrOrder(String order) async {
    state = state.copyWith(preferredDhikrOrder: order);
    await _saveSettings();
  }

  Future<void> toggleProgressAnimation(bool enabled) async {
    state = state.copyWith(showProgressAnimation: enabled);
    await _saveSettings();
  }

  Future<void> toggleSmartSuggestions(bool enabled) async {
    state = state.copyWith(enableSmartSuggestions: enabled);
    await _saveSettings();
  }

  Future<void> hideCategory(String categoryId) async {
    if (!state.hiddenCategories.contains(categoryId)) {
      state = state.copyWith(
        hiddenCategories: [...state.hiddenCategories, categoryId],
      );
      await _saveSettings();
    }
  }

  Future<void> showCategory(String categoryId) async {
    state = state.copyWith(
      hiddenCategories: state.hiddenCategories.where((id) => id != categoryId).toList(),
    );
    await _saveSettings();
  }

  Future<void> addDhikrNote(String dhikrId, String note) async {
    final newNotes = Map<String, String>.from(state.customDhikrNotes);
    newNotes[dhikrId] = note;

    state = state.copyWith(customDhikrNotes: newNotes);
    await _saveSettings();
  }

  Future<void> removeDhikrNote(String dhikrId) async {
    final newNotes = Map<String, String>.from(state.customDhikrNotes);
    newNotes.remove(dhikrId);

    state = state.copyWith(customDhikrNotes: newNotes);
    await _saveSettings();
  }

  Future<void> setPreferredTimeOfDay(String timeOfDay) async {
    state = state.copyWith(preferredTimeOfDay: timeOfDay);
    await _saveSettings();
  }

  Future<void> toggleAdaptiveReminders(bool enabled) async {
    state = state.copyWith(adaptiveReminders: enabled);
    await _saveSettings();
  }

  Future<void> setMotivationLevel(double level) async {
    state = state.copyWith(motivationLevel: level.clamp(0.0, 1.0));
    await _saveSettings();
  }

  bool isFavorite(String dhikrId) {
    return state.favoritesDhikrs.contains(dhikrId);
  }

  int getCustomCount(String dhikrId, int defaultCount) {
    return state.dhikrCustomCounts[dhikrId] ?? defaultCount;
  }

  bool isCategoryHidden(String categoryId) {
    return state.hiddenCategories.contains(categoryId);
  }

  String? getDhikrNote(String dhikrId) {
    return state.customDhikrNotes[dhikrId];
  }
}

final personalizationProvider = StateNotifierProvider<PersonalizationNotifier, PersonalizationSettings>((ref) {
  return PersonalizationNotifier();
});

// Smart suggestions provider
final smartSuggestionsProvider = Provider<List<String>>((ref) {
  final personalization = ref.watch(personalizationProvider);
  final sessionHistory = ref.watch(sessionHistoryProvider);

  if (!personalization.enableSmartSuggestions) {
    return [];
  }

  return sessionHistory.when(
    data: (sessions) => _generateSmartSuggestions(sessions, personalization),
    loading: () => [],
    error: (_, __) => [],
  );
});

List<String> _generateSmartSuggestions(List<DhikrSession> sessions, PersonalizationSettings settings) {
  final suggestions = <String>[];
  final now = DateTime.now();

  // Time-based suggestions
  final hour = now.hour;
  if (hour >= 6 && hour < 12) {
    suggestions.add('Start your day with morning adhkar');
  } else if (hour >= 17 && hour < 21) {
    suggestions.add('Complete evening remembrance');
  }

  // Pattern-based suggestions
  if (sessions.isNotEmpty) {
    final recentSessions = sessions.where((s) =>
        now.difference(s.startedAt).inDays < 7).toList();

    if (recentSessions.isEmpty) {
      suggestions.add('It\'s been a while - start with a simple dhikr');
    } else {
      final averageDaily = recentSessions.length / 7;
      if (averageDaily < 1) {
        suggestions.add('Try to maintain daily consistency');
      }
    }
  }

  // Favorites suggestions
  if (settings.favoritesDhikrs.isNotEmpty) {
    suggestions.add('Continue with your favorite dhikr');
  }

  // Motivation-based suggestions
  if (settings.motivationLevel > 0.7) {
    suggestions.add('Challenge yourself with a longer session');
  } else if (settings.motivationLevel < 0.3) {
    suggestions.add('Start small - even 10 repetitions count');
  }

  return suggestions.take(3).toList();
}

// Provider to get session history (referenced in suggestions)
final sessionHistoryProvider = FutureProvider<List<DhikrSession>>((ref) async {
  // This would normally come from the session provider
  // For now, returning empty list as placeholder
  return <DhikrSession>[];
});