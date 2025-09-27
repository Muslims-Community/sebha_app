import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  static const String _settingsKey = 'app_settings';

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        state = AppSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // If loading fails, keep default settings
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

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _saveSettings();
  }

  Future<void> updateFontSize(FontSize fontSize) async {
    state = state.copyWith(fontSize: fontSize);
    await _saveSettings();
  }

  Future<void> updateVibration(bool enabled) async {
    state = state.copyWith(vibrationEnabled: enabled);
    await _saveSettings();
  }

  Future<void> updateHighContrast(bool enabled) async {
    state = state.copyWith(highContrastMode: enabled);
    await _saveSettings();
  }

  Future<void> updateLanguage(String languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _saveSettings();
  }

  Future<void> updateSound(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _saveSettings();
  }

  Future<void> updateCounterButtonSize(double size) async {
    state = state.copyWith(counterButtonSize: size);
    await _saveSettings();
  }

  Future<void> updateShowTransliteration(bool show) async {
    state = state.copyWith(showTransliteration: show);
    await _saveSettings();
  }

  Future<void> updateShowMeaning(bool show) async {
    state = state.copyWith(showMeaning: show);
    await _saveSettings();
  }

  Future<void> updateAutoSaveProgress(bool autoSave) async {
    state = state.copyWith(autoSaveProgress: autoSave);
    await _saveSettings();
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    state = state.copyWith(onboardingCompleted: completed);
    await _saveSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});