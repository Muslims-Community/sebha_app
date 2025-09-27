// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  themeMode:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
      ThemeMode.system,
  fontSize:
      $enumDecodeNullable(_$FontSizeEnumMap, json['fontSize']) ??
      FontSize.medium,
  vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
  highContrastMode: json['highContrastMode'] as bool? ?? false,
  languageCode: json['languageCode'] as String? ?? 'ar',
  soundEnabled: json['soundEnabled'] as bool? ?? false,
  counterButtonSize: (json['counterButtonSize'] as num?)?.toDouble() ?? 200.0,
  showTransliteration: json['showTransliteration'] as bool? ?? true,
  showMeaning: json['showMeaning'] as bool? ?? true,
  autoSaveProgress: json['autoSaveProgress'] as bool? ?? true,
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'fontSize': _$FontSizeEnumMap[instance.fontSize]!,
      'vibrationEnabled': instance.vibrationEnabled,
      'highContrastMode': instance.highContrastMode,
      'languageCode': instance.languageCode,
      'soundEnabled': instance.soundEnabled,
      'counterButtonSize': instance.counterButtonSize,
      'showTransliteration': instance.showTransliteration,
      'showMeaning': instance.showMeaning,
      'autoSaveProgress': instance.autoSaveProgress,
      'onboardingCompleted': instance.onboardingCompleted,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$FontSizeEnumMap = {
  FontSize.small: 'small',
  FontSize.medium: 'medium',
  FontSize.large: 'large',
  FontSize.extraLarge: 'extraLarge',
};
