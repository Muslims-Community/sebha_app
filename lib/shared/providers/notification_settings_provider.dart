import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_settings.dart';
import '../services/notification_service.dart';

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  static const String _settingsKey = 'notification_settings';
  final NotificationService _notificationService = NotificationService();

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        state = NotificationSettings.fromJson(settingsMap);
      }

      // Apply current settings to notification service
      await _applyNotificationSettings();
    } catch (e) {
      // Use default settings if loading fails
      state = const NotificationSettings();
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(state.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      // Handle save error
    }
  }

  // Initialize notification service
  Future<void> initializeNotifications() async {
    await _notificationService.initialize();
    await _applyNotificationSettings();
  }

  // Apply current settings to notification service
  Future<void> _applyNotificationSettings() async {
    // Cancel all existing notifications first
    await _notificationService.cancelAllNotifications();

    if (!state.notificationsEnabled) return;

    // Schedule morning adhkar
    if (state.morningAdhkarEnabled) {
      await _notificationService.scheduleMorningAdhkar(
        hour: state.morningAdhkarHour,
        minute: state.morningAdhkarMinute,
      );
    }

    // Schedule evening adhkar
    if (state.eveningAdhkarEnabled) {
      await _notificationService.scheduleEveningAdhkar(
        hour: state.eveningAdhkarHour,
        minute: state.eveningAdhkarMinute,
      );
    }

    // Schedule goal reminder
    if (state.goalRemindersEnabled) {
      await _notificationService.scheduleGoalReminder(
        hour: state.goalReminderHour,
        minute: state.goalReminderMinute,
      );
    }

    // Schedule prayer reminders
    if (state.prayerRemindersEnabled) {
      await _schedulePrayerReminders();
    }

    // Schedule dhikr reminders
    if (state.dhikrRemindersEnabled) {
      await _scheduleDhikrReminders();
    }
  }

  Future<void> _schedulePrayerReminders() async {
    await _notificationService.schedulePrayerReminder(
      id: NotificationService.fajrReminderId,
      prayerName: 'الفجر',
      hour: state.fajrHour,
      minute: state.fajrMinute,
    );

    await _notificationService.schedulePrayerReminder(
      id: NotificationService.dhuhrReminderId,
      prayerName: 'الظهر',
      hour: state.dhuhrHour,
      minute: state.dhuhrMinute,
    );

    await _notificationService.schedulePrayerReminder(
      id: NotificationService.asrReminderId,
      prayerName: 'العصر',
      hour: state.asrHour,
      minute: state.asrMinute,
    );

    await _notificationService.schedulePrayerReminder(
      id: NotificationService.maghribReminderId,
      prayerName: 'المغرب',
      hour: state.maghribHour,
      minute: state.maghribMinute,
    );

    await _notificationService.schedulePrayerReminder(
      id: NotificationService.ishaReminderId,
      prayerName: 'العشاء',
      hour: state.ishaHour,
      minute: state.ishaMinute,
    );
  }

  Future<void> _scheduleDhikrReminders() async {
    for (int i = 0; i < state.dhikrReminderIntervals.length; i++) {
      final interval = state.dhikrReminderIntervals[i];
      await _notificationService.scheduleDhikrReminder(
        hour: interval,
        minute: 0,
        title: '🤲 تذكير الذكر',
        body: 'حان وقت الذكر. تذكر الله في هذه اللحظة المباركة',
        payload: 'dhikr_reminder_$interval',
      );
    }
  }

  // Update settings methods
  Future<void> toggleNotifications(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> toggleDhikrReminders(bool enabled) async {
    state = state.copyWith(dhikrRemindersEnabled: enabled);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> toggleMorningAdhkar(bool enabled) async {
    state = state.copyWith(morningAdhkarEnabled: enabled);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> toggleEveningAdhkar(bool enabled) async {
    state = state.copyWith(eveningAdhkarEnabled: enabled);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> togglePrayerReminders(bool enabled) async {
    state = state.copyWith(prayerRemindersEnabled: enabled);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> toggleAchievementNotifications(bool enabled) async {
    state = state.copyWith(achievementNotificationsEnabled: enabled);
    await _saveSettings();
  }

  Future<void> toggleGoalReminders(bool enabled) async {
    state = state.copyWith(goalRemindersEnabled: enabled);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> toggleProgressNotifications(bool enabled) async {
    state = state.copyWith(progressNotificationsEnabled: enabled);
    await _saveSettings();
  }

  // Update timing methods
  Future<void> updateMorningAdhkarTime(int hour, int minute) async {
    state = state.copyWith(morningAdhkarHour: hour, morningAdhkarMinute: minute);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> updateEveningAdhkarTime(int hour, int minute) async {
    state = state.copyWith(eveningAdhkarHour: hour, eveningAdhkarMinute: minute);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> updateGoalReminderTime(int hour, int minute) async {
    state = state.copyWith(goalReminderHour: hour, goalReminderMinute: minute);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> updatePrayerTime(String prayer, int hour, int minute) async {
    switch (prayer) {
      case 'fajr':
        state = state.copyWith(fajrHour: hour, fajrMinute: minute);
        break;
      case 'dhuhr':
        state = state.copyWith(dhuhrHour: hour, dhuhrMinute: minute);
        break;
      case 'asr':
        state = state.copyWith(asrHour: hour, asrMinute: minute);
        break;
      case 'maghrib':
        state = state.copyWith(maghribHour: hour, maghribMinute: minute);
        break;
      case 'isha':
        state = state.copyWith(ishaHour: hour, ishaMinute: minute);
        break;
    }
    await _saveSettings();
    await _applyNotificationSettings();
  }

  Future<void> updateDhikrReminderIntervals(List<int> intervals) async {
    state = state.copyWith(dhikrReminderIntervals: intervals);
    await _saveSettings();
    await _applyNotificationSettings();
  }

  // Notification actions
  Future<void> showAchievementNotification(String title, String description) async {
    if (state.achievementNotificationsEnabled) {
      await _notificationService.showAchievementNotification(
        title: title,
        description: description,
      );
    }
  }

  Future<void> showProgressNotification(int current, int target, String dhikrName) async {
    if (state.progressNotificationsEnabled) {
      await _notificationService.showProgressNotification(
        current: current,
        target: target,
        dhikrName: dhikrName,
      );
    }
  }

  Future<void> clearProgressNotification() async {
    await _notificationService.clearProgressNotification();
  }

  Future<void> showCustomNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (state.notificationsEnabled) {
      await _notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  // Utility methods
  Future<bool> areNotificationsEnabled() async {
    return await _notificationService.areNotificationsEnabled();
  }

  Future<List<String>> getPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    return pending.map((n) => '${n.title}: ${n.body}').toList();
  }
}

// Provider
final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);