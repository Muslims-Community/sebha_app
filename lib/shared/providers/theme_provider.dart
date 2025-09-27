import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart' as app_models;
import 'settings_provider.dart';

class AppThemeData {
  // Light theme colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryColorDark = Color(0xFF1B5E20);
  static const Color accentColor = Color(0xFF4CAF50);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF4CAF50);
  static const Color darkSecondary = Color(0xFF81C784);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF2D2D2D);

  // High contrast colors
  static const Color highContrastPrimary = Color(0xFF000000);
  static const Color highContrastSecondary = Color(0xFFFFFFFF);
  static const Color highContrastAccent = Color(0xFF0066CC);

  static ThemeData lightTheme(app_models.AppSettings settings) {
    final baseTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: settings.highContrastMode ? highContrastPrimary : primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.highContrastMode ? highContrastPrimary : primaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: 'Amiri',
    );

    return _applyCustomizations(baseTheme, settings);
  }

  static ThemeData darkTheme(app_models.AppSettings settings) {
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: settings.highContrastMode ? highContrastSecondary : darkPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.highContrastMode ? highContrastSecondary : darkPrimary,
        brightness: Brightness.dark,
        surface: darkSurface,
      ),
      scaffoldBackgroundColor: darkBackground,
      dividerColor: Colors.grey[800],
      useMaterial3: true,
      fontFamily: 'Amiri',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkPrimary),
        ),
        labelStyle: TextStyle(color: Colors.grey[400]),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: darkPrimary,
      ),
    );

    return _applyCustomizations(baseTheme, settings);
  }

  static ThemeData _applyCustomizations(ThemeData baseTheme, app_models.AppSettings settings) {
    final fontMultiplier = settings.fontSizeMultiplier;

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.copyWith(
        displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
          fontSize: (baseTheme.textTheme.displayLarge?.fontSize ?? 32) * fontMultiplier,
        ),
        displayMedium: baseTheme.textTheme.displayMedium?.copyWith(
          fontSize: (baseTheme.textTheme.displayMedium?.fontSize ?? 28) * fontMultiplier,
        ),
        displaySmall: baseTheme.textTheme.displaySmall?.copyWith(
          fontSize: (baseTheme.textTheme.displaySmall?.fontSize ?? 24) * fontMultiplier,
        ),
        headlineLarge: baseTheme.textTheme.headlineLarge?.copyWith(
          fontSize: (baseTheme.textTheme.headlineLarge?.fontSize ?? 22) * fontMultiplier,
        ),
        headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
          fontSize: (baseTheme.textTheme.headlineMedium?.fontSize ?? 20) * fontMultiplier,
        ),
        headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
          fontSize: (baseTheme.textTheme.headlineSmall?.fontSize ?? 18) * fontMultiplier,
        ),
        titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
          fontSize: (baseTheme.textTheme.titleLarge?.fontSize ?? 16) * fontMultiplier,
        ),
        titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
          fontSize: (baseTheme.textTheme.titleMedium?.fontSize ?? 14) * fontMultiplier,
        ),
        titleSmall: baseTheme.textTheme.titleSmall?.copyWith(
          fontSize: (baseTheme.textTheme.titleSmall?.fontSize ?? 12) * fontMultiplier,
        ),
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
          fontSize: (baseTheme.textTheme.bodyLarge?.fontSize ?? 16) * fontMultiplier,
        ),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
          fontSize: (baseTheme.textTheme.bodyMedium?.fontSize ?? 14) * fontMultiplier,
        ),
        bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
          fontSize: (baseTheme.textTheme.bodySmall?.fontSize ?? 12) * fontMultiplier,
        ),
        labelLarge: baseTheme.textTheme.labelLarge?.copyWith(
          fontSize: (baseTheme.textTheme.labelLarge?.fontSize ?? 14) * fontMultiplier,
        ),
        labelMedium: baseTheme.textTheme.labelMedium?.copyWith(
          fontSize: (baseTheme.textTheme.labelMedium?.fontSize ?? 12) * fontMultiplier,
        ),
        labelSmall: baseTheme.textTheme.labelSmall?.copyWith(
          fontSize: (baseTheme.textTheme.labelSmall?.fontSize ?? 10) * fontMultiplier,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            settings.highContrastMode ? 60 : 48,
            settings.highContrastMode ? 60 : 48,
          ),
        ),
      ),
      iconTheme: baseTheme.iconTheme.copyWith(
        size: (baseTheme.iconTheme.size ?? 24) * fontMultiplier,
      ),
    );
  }
}

final themeProvider = Provider<ThemeData>((ref) {
  final settings = ref.watch(settingsProvider);

  switch (settings.themeMode) {
    case app_models.ThemeMode.light:
      return AppThemeData.lightTheme(settings);
    case app_models.ThemeMode.dark:
      return AppThemeData.darkTheme(settings);
    case app_models.ThemeMode.system:
      // This will be handled in the main app where we can access MediaQuery
      return AppThemeData.lightTheme(settings);
  }
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final settings = ref.watch(settingsProvider);
  return AppThemeData.darkTheme(settings);
});