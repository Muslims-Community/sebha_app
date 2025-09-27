import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/app_settings.dart' as app_models;
import '../../shared/providers/settings_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: l10n.theme,
            children: [
              _buildThemeSelector(context, settings, settingsNotifier, l10n),
              if (settings.themeMode != app_models.ThemeMode.system)
                _buildHighContrastToggle(context, settings, settingsNotifier),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: l10n.language,
            children: [
              _buildLanguageSelector(context, settings, settingsNotifier),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Accessibility',
            children: [
              _buildFontSizeSelector(context, settings, settingsNotifier, l10n),
              _buildVibrationToggle(context, settings, settingsNotifier, l10n),
              _buildToggleOption(
                context,
                title: 'Show Transliteration',
                value: settings.showTransliteration,
                onChanged: settingsNotifier.updateShowTransliteration,
              ),
              _buildToggleOption(
                context,
                title: 'Show Meaning',
                value: settings.showMeaning,
                onChanged: settingsNotifier.updateShowMeaning,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Counter Options',
            children: [
              _buildCounterSizeSlider(context, settings, settingsNotifier),
              _buildToggleOption(
                context,
                title: 'Auto-save Progress',
                value: settings.autoSaveProgress,
                onChanged: settingsNotifier.updateAutoSaveProgress,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'الإشعارات',
            children: [
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('إعدادات الإشعارات'),
                subtitle: const Text('تخصيص تذكيرات الذكر والصلاة'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    app_models.AppSettings settings,
    SettingsNotifier notifier,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        RadioListTile<app_models.ThemeMode>(
          title: Text(l10n.systemTheme),
          value: app_models.ThemeMode.system,
          groupValue: settings.themeMode,
          onChanged: (value) => notifier.updateThemeMode(value!),
        ),
        RadioListTile<app_models.ThemeMode>(
          title: Text(l10n.lightTheme),
          value: app_models.ThemeMode.light,
          groupValue: settings.themeMode,
          onChanged: (value) => notifier.updateThemeMode(value!),
        ),
        RadioListTile<app_models.ThemeMode>(
          title: Text(l10n.darkTheme),
          value: app_models.ThemeMode.dark,
          groupValue: settings.themeMode,
          onChanged: (value) => notifier.updateThemeMode(value!),
        ),
      ],
    );
  }

  Widget _buildHighContrastToggle(
    BuildContext context,
    app_models.AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return SwitchListTile(
      title: const Text('High Contrast'),
      subtitle: const Text('Improves visibility for users with vision difficulties'),
      value: settings.highContrastMode,
      onChanged: notifier.updateHighContrast,
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    app_models.AppSettings settings,
    SettingsNotifier notifier,
  ) {
    const languages = [
      {'code': 'ar', 'name': 'العربية', 'nativeName': 'Arabic'},
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'ur', 'name': 'اردو', 'nativeName': 'Urdu'},
    ];

    return Column(
      children: languages.map((lang) {
        return RadioListTile<String>(
          title: Text('${lang['name']} (${lang['nativeName']})'),
          value: lang['code']!,
          groupValue: settings.languageCode,
          onChanged: (value) => notifier.updateLanguage(value!),
        );
      }).toList(),
    );
  }

  Widget _buildFontSizeSelector(
    BuildContext context,
    app_models.AppSettings settings,
    SettingsNotifier notifier,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        ListTile(
          title: Text(l10n.fontSize),
          subtitle: Text('Current: ${_getFontSizeLabel(settings.fontSize, l10n)}'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: app_models.FontSize.values.map((size) {
              return RadioListTile<app_models.FontSize>(
                title: Text(_getFontSizeLabel(size, l10n)),
                value: size,
                groupValue: settings.fontSize,
                onChanged: (value) => notifier.updateFontSize(value!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getFontSizeLabel(app_models.FontSize size, AppLocalizations l10n) {
    switch (size) {
      case app_models.FontSize.small:
        return l10n.small;
      case app_models.FontSize.medium:
        return l10n.medium;
      case app_models.FontSize.large:
        return l10n.large;
      case app_models.FontSize.extraLarge:
        return l10n.extraLarge;
    }
  }

  Widget _buildVibrationToggle(
    BuildContext context,
    app_models.AppSettings settings,
    SettingsNotifier notifier,
    AppLocalizations l10n,
  ) {
    return SwitchListTile(
      title: Text(l10n.vibration),
      subtitle: const Text('Provides haptic feedback when counting'),
      value: settings.vibrationEnabled,
      onChanged: notifier.updateVibration,
    );
  }

  Widget _buildToggleOption(
    BuildContext context, {
    required String title,
    String? subtitle,
    required bool value,
    required Future<void> Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildCounterSizeSlider(
    BuildContext context,
    app_models.AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return ListTile(
      title: const Text('Counter Button Size'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Size: ${settings.counterButtonSize.round()}px'),
          Slider(
            value: settings.counterButtonSize,
            min: 120,
            max: 300,
            divisions: 18,
            label: '${settings.counterButtonSize.round()}px',
            onChanged: notifier.updateCounterButtonSize,
          ),
        ],
      ),
    );
  }
}