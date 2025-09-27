import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class QuickNotificationNotifier extends StateNotifier<bool> {
  QuickNotificationNotifier() : super(false) {
    _initializeNotifications();
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isQuickCounterActive = false;

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    state = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.actionId == 'increment_action') {
      // Handle increment action - this will be called when user taps the increment button
      _handleQuickIncrement();
    }
  }

  void _handleQuickIncrement() {
    // This will be connected to the main counter later
    // For now, we just update the notification count
    _updateQuickCounterNotification();
  }

  Future<void> showQuickCounterNotification() async {
    if (_isQuickCounterActive) return;

    _isQuickCounterActive = true;

    const androidDetails = AndroidNotificationDetails(
      'quick_counter_channel',
      'Quick Counter',
      channelDescription: 'Quick dhikr counter notification',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      actions: [
        AndroidNotificationAction(
          'increment_action',
          'تسبيح +1',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_add'),
        ),
      ],
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      1, // notification ID
      'عداد السبحة السريع',
      '0 - انقر + للعد',
      notificationDetails,
    );
  }

  Future<void> _updateQuickCounterNotification() async {
    // This will update the notification with current count
    // Implementation will be added when connected to main counter
  }

  Future<void> hideQuickCounterNotification() async {
    if (!_isQuickCounterActive) return;

    _isQuickCounterActive = false;
    await _notificationsPlugin.cancel(1);
  }

  Future<void> updateNotificationCount(int count, String dhikrName) async {
    if (!_isQuickCounterActive) return;

    const androidDetails = AndroidNotificationDetails(
      'quick_counter_channel',
      'Quick Counter',
      channelDescription: 'Quick dhikr counter notification',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      actions: [
        AndroidNotificationAction(
          'increment_action',
          'تسبيح +1',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_add'),
        ),
      ],
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      1, // notification ID
      'عداد السبحة السريع - $dhikrName',
      '$count - انقر + للعد',
      notificationDetails,
    );
  }

  bool get isActive => _isQuickCounterActive;
}

final quickNotificationProvider = StateNotifierProvider<QuickNotificationNotifier, bool>((ref) {
  return QuickNotificationNotifier();
});