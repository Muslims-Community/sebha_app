import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Notification IDs
  static const int dhikrReminderId = 1001;
  static const int morningAdhkarId = 1002;
  static const int eveningAdhkarId = 1003;
  static const int achievementId = 1004;
  static const int goalReminderId = 1005;
  static const int fajrReminderId = 1006;
  static const int dhuhrReminderId = 1007;
  static const int asrReminderId = 1008;
  static const int maghribReminderId = 1009;
  static const int ishaReminderId = 1010;

  // Initialize notifications
  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    final iosImplementation = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Handle notification taps
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }

    // Handle different notification types
    switch (response.payload) {
      case 'morning_adhkar':
        // Navigate to morning adhkar
        break;
      case 'evening_adhkar':
        // Navigate to evening adhkar
        break;
      case 'dhikr_reminder':
        // Open main counter screen
        break;
      case 'achievement':
        // Navigate to achievements screen
        break;
      case 'goal_reminder':
        // Navigate to goals screen
        break;
    }
  }

  // Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    Priority priority = Priority.defaultPriority,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'general_notifications',
      'عام',
      channelDescription: 'الإشعارات العامة للتطبيق',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      color: const Color(0xFF2E3A59),
      enableLights: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Schedule daily dhikr reminder
  Future<void> scheduleDhikrReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
  }) async {
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    const androidDetails = AndroidNotificationDetails(
      'dhikr_reminders',
      'تذكيرات الذكر',
      channelDescription: 'تذكيرات يومية للذكر والتسبيح',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      color: Color(0xFF2E3A59),
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification_sound.wav',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      dhikrReminderId,
      title,
      body,
      scheduledDate,
      details,
      payload: payload ?? 'dhikr_reminder',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Schedule morning adhkar reminder
  Future<void> scheduleMorningAdhkar({
    int hour = 6,
    int minute = 0,
  }) async {
    await _scheduleRepeatingNotification(
      id: morningAdhkarId,
      title: '🌅 أذكار الصباح',
      body: 'حان وقت أذكار الصباح. ابدأ يومك بذكر الله',
      hour: hour,
      minute: minute,
      payload: 'morning_adhkar',
    );
  }

  // Schedule evening adhkar reminder
  Future<void> scheduleEveningAdhkar({
    int hour = 18,
    int minute = 0,
  }) async {
    await _scheduleRepeatingNotification(
      id: eveningAdhkarId,
      title: '🌆 أذكار المساء',
      body: 'حان وقت أذكار المساء. اختتم يومك بذكر الله',
      hour: hour,
      minute: minute,
      payload: 'evening_adhkar',
    );
  }

  // Schedule prayer time reminders
  Future<void> schedulePrayerReminder({
    required int id,
    required String prayerName,
    required int hour,
    required int minute,
  }) async {
    await _scheduleRepeatingNotification(
      id: id,
      title: '🕌 حان وقت $prayerName',
      body: 'تذكير: حان الآن وقت صلاة $prayerName',
      hour: hour,
      minute: minute,
      payload: 'prayer_$prayerName',
    );
  }

  // Schedule goal reminder
  Future<void> scheduleGoalReminder({
    int hour = 20,
    int minute = 0,
  }) async {
    await _scheduleRepeatingNotification(
      id: goalReminderId,
      title: '🎯 تذكير الأهداف اليومية',
      body: 'لا تنس إكمال أهدافك اليومية من الذكر والتسبيح',
      hour: hour,
      minute: minute,
      payload: 'goal_reminder',
    );
  }

  // Show achievement notification
  Future<void> showAchievementNotification({
    required String title,
    required String description,
  }) async {
    await showNotification(
      id: achievementId,
      title: '🏆 $title',
      body: description,
      payload: 'achievement',
    );
  }

  // Generic repeating notification scheduler
  Future<void> _scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    const androidDetails = AndroidNotificationDetails(
      'daily_reminders',
      'التذكيرات اليومية',
      channelDescription: 'تذكيرات يومية للأذكار والصلاة',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      color: Color(0xFF2E3A59),
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ongoing: false,
      autoCancel: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      // Handle exact alarms permission error gracefully
      if (e.toString().contains('exact_alarms_not_permitted')) {
        if (kDebugMode) {
          print('⚠️ Exact alarms not permitted. Falling back to inexact scheduling.');
        }

        // Fallback to inexact scheduling
        try {
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            details,
            payload: payload,
            androidScheduleMode: AndroidScheduleMode.inexact,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
          );
        } catch (fallbackError) {
          if (kDebugMode) {
            print('❌ Failed to schedule notification even with inexact mode: $fallbackError');
          }
        }
      } else {
        if (kDebugMode) {
          print('❌ Failed to schedule notification: $e');
        }
      }
    }
  }

  // Get next instance of specific time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final result = await androidImplementation.areNotificationsEnabled();
      return result ?? false;
    }

    return true; // Assume enabled for iOS
  }

  // Show progress notification for long dhikr sessions
  Future<void> showProgressNotification({
    required int current,
    required int target,
    required String dhikrName,
  }) async {
    final progress = ((current / target) * 100).toInt();

    final androidDetails = AndroidNotificationDetails(
      'dhikr_progress',
      'تقدم الذكر',
      channelDescription: 'إشعارات تقدم جلسة الذكر',
      importance: Importance.low,
      priority: Priority.low,
      icon: '@mipmap/launcher_icon',
      color: const Color(0xFF2E3A59),
      ongoing: true,
      autoCancel: false,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: true,
      presentSound: false,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999, // Special ID for progress notifications
      'جلسة $dhikrName',
      '$current من $target ($progress%)',
      details,
    );
  }

  // Clear progress notification
  Future<void> clearProgressNotification() async {
    await _notifications.cancel(999);
  }
}