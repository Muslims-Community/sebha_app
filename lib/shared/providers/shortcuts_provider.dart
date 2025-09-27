import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

class ShortcutsNotifier extends StateNotifier<bool> {
  ShortcutsNotifier() : super(false) {
    _initializeShortcuts();
  }

  final QuickActions _quickActions = const QuickActions();

  Future<void> _initializeShortcuts() async {
    try {
      await _setupShortcuts();
      state = true;
    } catch (e) {
      state = false;
    }
  }

  Future<void> _setupShortcuts() async {
    await _quickActions.setShortcutItems([
      const ShortcutItem(
        type: 'subhan_allah',
        localizedTitle: 'سبحان الله',
        icon: 'ic_shortcut_subhan',
      ),
      const ShortcutItem(
        type: 'alhamdulillah',
        localizedTitle: 'الحمد لله',
        icon: 'ic_shortcut_alhamdulillah',
      ),
      const ShortcutItem(
        type: 'allahu_akbar',
        localizedTitle: 'الله أكبر',
        icon: 'ic_shortcut_akbar',
      ),
      const ShortcutItem(
        type: 'la_ilaha_illallah',
        localizedTitle: 'لا إله إلا الله',
        icon: 'ic_shortcut_tahlil',
      ),
    ]);
  }

  void handleShortcut(String type, Function(Map<String, dynamic>) onDhikrSelected) {
    final dhikrData = _getDhikrDataForShortcut(type);
    if (dhikrData != null) {
      onDhikrSelected(dhikrData);
    }
  }

  Map<String, dynamic>? _getDhikrDataForShortcut(String type) {
    switch (type) {
      case 'subhan_allah':
        return {
          'id': 'subhan_allah',
          'title': 'سبحان الله',
          'arabicText': 'سُبْحَانَ اللَّهِ',
          'targetCount': 33,
          'category': 'classical',
          'transliteration': 'SubhanAllah',
          'meaning': 'Glory be to Allah',
        };
      case 'alhamdulillah':
        return {
          'id': 'alhamdulillah',
          'title': 'الحمد لله',
          'arabicText': 'الْحَمْدُ لِلَّهِ',
          'targetCount': 33,
          'category': 'classical',
          'transliteration': 'Alhamdulillah',
          'meaning': 'All praise is due to Allah',
        };
      case 'allahu_akbar':
        return {
          'id': 'allahu_akbar',
          'title': 'الله أكبر',
          'arabicText': 'اللَّهُ أَكْبَرُ',
          'targetCount': 34,
          'category': 'classical',
          'transliteration': 'Allahu Akbar',
          'meaning': 'Allah is the Greatest',
        };
      case 'la_ilaha_illallah':
        return {
          'id': 'la_ilaha_illallah',
          'title': 'لا إله إلا الله',
          'arabicText': 'لَا إِلَٰهَ إِلَّا اللَّهُ',
          'targetCount': 100,
          'category': 'classical',
          'transliteration': 'La ilaha illa Allah',
          'meaning': 'There is no god but Allah',
        };
      default:
        return null;
    }
  }

  void initializeShortcutHandler(Function(String) handler) {
    _quickActions.initialize(handler);
  }
}

final shortcutsProvider = StateNotifierProvider<ShortcutsNotifier, bool>((ref) {
  return ShortcutsNotifier();
});