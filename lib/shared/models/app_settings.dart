import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

enum ThemeMode {
  system,
  light,
  dark,
}

enum FontSize {
  small,
  medium,
  large,
  extraLarge,
}

@JsonSerializable()
class AppSettings {
  final ThemeMode themeMode;
  final FontSize fontSize;
  final bool vibrationEnabled;
  final bool highContrastMode;
  final String languageCode;
  final bool soundEnabled;
  final double counterButtonSize;
  final bool showTransliteration;
  final bool showMeaning;
  final bool autoSaveProgress;
  final bool onboardingCompleted;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.fontSize = FontSize.medium,
    this.vibrationEnabled = true,
    this.highContrastMode = false,
    this.languageCode = 'ar',
    this.soundEnabled = false,
    this.counterButtonSize = 200.0,
    this.showTransliteration = true,
    this.showMeaning = true,
    this.autoSaveProgress = true,
    this.onboardingCompleted = false,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  AppSettings copyWith({
    ThemeMode? themeMode,
    FontSize? fontSize,
    bool? vibrationEnabled,
    bool? highContrastMode,
    String? languageCode,
    bool? soundEnabled,
    double? counterButtonSize,
    bool? showTransliteration,
    bool? showMeaning,
    bool? autoSaveProgress,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      languageCode: languageCode ?? this.languageCode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      counterButtonSize: counterButtonSize ?? this.counterButtonSize,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showMeaning: showMeaning ?? this.showMeaning,
      autoSaveProgress: autoSaveProgress ?? this.autoSaveProgress,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  double get fontSizeMultiplier {
    switch (fontSize) {
      case FontSize.small:
        return 0.8;
      case FontSize.medium:
        return 1.0;
      case FontSize.large:
        return 1.2;
      case FontSize.extraLarge:
        return 1.5;
    }
  }
}