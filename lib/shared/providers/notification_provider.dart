import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  final bool enabled;
  final TimeOfDay? morningTime;
  final TimeOfDay? eveningTime;
  final bool weeklyReminder;
  final bool completionCelebration;

  const NotificationSettings({
    this.enabled = false,
    this.morningTime,
    this.eveningTime,
    this.weeklyReminder = true,
    this.completionCelebration = true,
  });

  NotificationSettings copyWith({
    bool? enabled,
    TimeOfDay? morningTime,
    TimeOfDay? eveningTime,
    bool? weeklyReminder,
    bool? completionCelebration,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,
      weeklyReminder: weeklyReminder ?? this.weeklyReminder,
      completionCelebration: completionCelebration ?? this.completionCelebration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'morningTime': morningTime != null ? '${morningTime!.hour}:${morningTime!.minute}' : null,
      'eveningTime': eveningTime != null ? '${eveningTime!.hour}:${eveningTime!.minute}' : null,
      'weeklyReminder': weeklyReminder,
      'completionCelebration': completionCelebration,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? timeString) {
      if (timeString == null) return null;
      final parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return NotificationSettings(
      enabled: json['enabled'] ?? false,
      morningTime: parseTime(json['morningTime']),
      eveningTime: parseTime(json['eveningTime']),
      weeklyReminder: json['weeklyReminder'] ?? true,
      completionCelebration: json['completionCelebration'] ?? true,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationSettings> {
  NotificationNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  static const String _notificationSettingsKey = 'notification_settings';
  Timer? _reminderTimer;

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_notificationSettingsKey);
      if (settingsJson != null) {
        final Map<String, dynamic> settingsMap = {};
        // Simple parsing for demonstration - in production, use proper JSON
        state = NotificationSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // Keep default settings
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Simple save for demonstration
      await prefs.setString(_notificationSettingsKey, 'saved');
    } catch (e) {
      // Handle error gracefully
    }
  }

  Future<void> updateEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await _saveSettings();

    if (enabled) {
      _scheduleReminders();
    } else {
      _cancelReminders();
    }
  }

  Future<void> updateMorningTime(TimeOfDay? time) async {
    state = state.copyWith(morningTime: time);
    await _saveSettings();
    _scheduleReminders();
  }

  Future<void> updateEveningTime(TimeOfDay? time) async {
    state = state.copyWith(eveningTime: time);
    await _saveSettings();
    _scheduleReminders();
  }

  Future<void> updateWeeklyReminder(bool enabled) async {
    state = state.copyWith(weeklyReminder: enabled);
    await _saveSettings();
  }

  Future<void> updateCompletionCelebration(bool enabled) async {
    state = state.copyWith(completionCelebration: enabled);
    await _saveSettings();
  }

  void _scheduleReminders() {
    _cancelReminders();

    if (!state.enabled) return;

    // Schedule daily reminders
    _reminderTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      final now = TimeOfDay.now();

      // Check morning reminder
      if (state.morningTime != null &&
          now.hour == state.morningTime!.hour &&
          now.minute == state.morningTime!.minute) {
        _showReminder('Morning Dhikr Reminder', 'Start your day with remembrance of Allah');
      }

      // Check evening reminder
      if (state.eveningTime != null &&
          now.hour == state.eveningTime!.hour &&
          now.minute == state.eveningTime!.minute) {
        _showReminder('Evening Dhikr Reminder', 'End your day with gratitude and remembrance');
      }
    });
  }

  void _cancelReminders() {
    _reminderTimer?.cancel();
    _reminderTimer = null;
  }

  void _showReminder(String title, String body) {
    // In a real implementation, this would use local notifications
    // For now, we'll just track that a reminder was triggered
    print('Notification: $title - $body');
  }

  void showCompletionCelebration() {
    if (state.completionCelebration) {
      _showReminder('Dhikr Completed!', 'Congratulations on completing your dhikr session!');
    }
  }

  @override
  void dispose() {
    _cancelReminders();
    super.dispose();
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationSettings>((ref) {
  return NotificationNotifier();
});

// Helper provider for quick access to notification functions
final notificationControllerProvider = Provider<NotificationController>((ref) {
  final notifier = ref.read(notificationProvider.notifier);
  final settings = ref.watch(notificationProvider);

  return NotificationController(notifier: notifier, settings: settings);
});

class NotificationController {
  final NotificationNotifier notifier;
  final NotificationSettings settings;

  const NotificationController({
    required this.notifier,
    required this.settings,
  });

  void celebrateCompletion() {
    notifier.showCompletionCelebration();
  }
}