import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/notification_settings_provider.dart';
import '../../l10n/generated/app_localizations.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الإشعارات'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master notification toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'تفعيل الإشعارات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: notificationSettings.notificationsEnabled,
                          onChanged: notifier.toggleNotifications,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تفعيل أو إلغاء جميع الإشعارات في التطبيق',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dhikr & Adhkar Notifications Section
            const Text(
              'إشعارات الذكر والأذكار',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Morning Adhkar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🌅 أذكار الصباح',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'تذكير يومي لأذكار الصباح',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: notificationSettings.morningAdhkarEnabled,
                          onChanged: notificationSettings.notificationsEnabled
                              ? notifier.toggleMorningAdhkar
                              : null,
                        ),
                      ],
                    ),
                    if (notificationSettings.morningAdhkarEnabled) ...[
                      const SizedBox(height: 12),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: const Text('وقت التذكير'),
                        subtitle: Text(notificationSettings.morningAdhkarTimeString),
                        onTap: () => _selectTime(
                          context,
                          notificationSettings.morningAdhkarHour,
                          notificationSettings.morningAdhkarMinute,
                          (hour, minute) => notifier.updateMorningAdhkarTime(hour, minute),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Evening Adhkar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🌆 أذكار المساء',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'تذكير يومي لأذكار المساء',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: notificationSettings.eveningAdhkarEnabled,
                          onChanged: notificationSettings.notificationsEnabled
                              ? notifier.toggleEveningAdhkar
                              : null,
                        ),
                      ],
                    ),
                    if (notificationSettings.eveningAdhkarEnabled) ...[
                      const SizedBox(height: 12),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: const Text('وقت التذكير'),
                        subtitle: Text(notificationSettings.eveningAdhkarTimeString),
                        onTap: () => _selectTime(
                          context,
                          notificationSettings.eveningAdhkarHour,
                          notificationSettings.eveningAdhkarMinute,
                          (hour, minute) => notifier.updateEveningAdhkarTime(hour, minute),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Dhikr Reminders
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🤲 تذكيرات الذكر',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'تذكيرات دورية للذكر والتسبيح',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: notificationSettings.dhikrRemindersEnabled,
                          onChanged: notificationSettings.notificationsEnabled
                              ? notifier.toggleDhikrReminders
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Prayer Reminders Section
            const Text(
              'تذكيرات الصلاة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🕌 تذكيرات الصلاة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'تذكير بأوقات الصلوات الخمس',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: notificationSettings.prayerRemindersEnabled,
                          onChanged: notificationSettings.notificationsEnabled
                              ? notifier.togglePrayerReminders
                              : null,
                        ),
                      ],
                    ),
                    if (notificationSettings.prayerRemindersEnabled) ...[
                      const SizedBox(height: 16),
                      _buildPrayerTimeRow('الفجر', notificationSettings.fajrTimeString, () {
                        _selectTime(
                          context,
                          notificationSettings.fajrHour,
                          notificationSettings.fajrMinute,
                          (hour, minute) => notifier.updatePrayerTime('fajr', hour, minute),
                        );
                      }),
                      _buildPrayerTimeRow('الظهر', notificationSettings.dhuhrTimeString, () {
                        _selectTime(
                          context,
                          notificationSettings.dhuhrHour,
                          notificationSettings.dhuhrMinute,
                          (hour, minute) => notifier.updatePrayerTime('dhuhr', hour, minute),
                        );
                      }),
                      _buildPrayerTimeRow('العصر', notificationSettings.asrTimeString, () {
                        _selectTime(
                          context,
                          notificationSettings.asrHour,
                          notificationSettings.asrMinute,
                          (hour, minute) => notifier.updatePrayerTime('asr', hour, minute),
                        );
                      }),
                      _buildPrayerTimeRow('المغرب', notificationSettings.maghribTimeString, () {
                        _selectTime(
                          context,
                          notificationSettings.maghribHour,
                          notificationSettings.maghribMinute,
                          (hour, minute) => notifier.updatePrayerTime('maghrib', hour, minute),
                        );
                      }),
                      _buildPrayerTimeRow('العشاء', notificationSettings.ishaTimeString, () {
                        _selectTime(
                          context,
                          notificationSettings.ishaHour,
                          notificationSettings.ishaMinute,
                          (hour, minute) => notifier.updatePrayerTime('isha', hour, minute),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Other Notifications Section
            const Text(
              'إشعارات أخرى',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Achievement Notifications
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🏆 إشعارات الإنجازات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'إشعار عند تحقيق إنجاز جديد',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: notificationSettings.achievementNotificationsEnabled,
                      onChanged: notificationSettings.notificationsEnabled
                          ? notifier.toggleAchievementNotifications
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            // Goal Reminders
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎯 تذكيرات الأهداف',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'تذكير يومي بالأهداف المحددة',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: notificationSettings.goalRemindersEnabled,
                          onChanged: notificationSettings.notificationsEnabled
                              ? notifier.toggleGoalReminders
                              : null,
                        ),
                      ],
                    ),
                    if (notificationSettings.goalRemindersEnabled) ...[
                      const SizedBox(height: 12),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: const Text('وقت التذكير'),
                        subtitle: Text(notificationSettings.goalReminderTimeString),
                        onTap: () => _selectTime(
                          context,
                          notificationSettings.goalReminderHour,
                          notificationSettings.goalReminderMinute,
                          (hour, minute) => notifier.updateGoalReminderTime(hour, minute),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Progress Notifications
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📊 إشعارات التقدم',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'إظهار تقدم الجلسة الحالية',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: notificationSettings.progressNotificationsEnabled,
                      onChanged: notificationSettings.notificationsEnabled
                          ? notifier.toggleProgressNotifications
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(String prayer, String time, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayer,
            style: const TextStyle(fontSize: 14),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    int initialHour,
    int initialMinute,
    Function(int hour, int minute) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeSelected(picked.hour, picked.minute);
    }
  }
}