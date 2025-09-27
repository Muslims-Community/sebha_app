// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => NotificationSettings(
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  dhikrRemindersEnabled: json['dhikrRemindersEnabled'] as bool? ?? true,
  morningAdhkarEnabled: json['morningAdhkarEnabled'] as bool? ?? true,
  eveningAdhkarEnabled: json['eveningAdhkarEnabled'] as bool? ?? true,
  prayerRemindersEnabled: json['prayerRemindersEnabled'] as bool? ?? false,
  achievementNotificationsEnabled:
      json['achievementNotificationsEnabled'] as bool? ?? true,
  goalRemindersEnabled: json['goalRemindersEnabled'] as bool? ?? true,
  progressNotificationsEnabled:
      json['progressNotificationsEnabled'] as bool? ?? false,
  morningAdhkarHour: (json['morningAdhkarHour'] as num?)?.toInt() ?? 6,
  morningAdhkarMinute: (json['morningAdhkarMinute'] as num?)?.toInt() ?? 0,
  eveningAdhkarHour: (json['eveningAdhkarHour'] as num?)?.toInt() ?? 18,
  eveningAdhkarMinute: (json['eveningAdhkarMinute'] as num?)?.toInt() ?? 0,
  goalReminderHour: (json['goalReminderHour'] as num?)?.toInt() ?? 20,
  goalReminderMinute: (json['goalReminderMinute'] as num?)?.toInt() ?? 0,
  fajrHour: (json['fajrHour'] as num?)?.toInt() ?? 5,
  fajrMinute: (json['fajrMinute'] as num?)?.toInt() ?? 30,
  dhuhrHour: (json['dhuhrHour'] as num?)?.toInt() ?? 12,
  dhuhrMinute: (json['dhuhrMinute'] as num?)?.toInt() ?? 30,
  asrHour: (json['asrHour'] as num?)?.toInt() ?? 15,
  asrMinute: (json['asrMinute'] as num?)?.toInt() ?? 30,
  maghribHour: (json['maghribHour'] as num?)?.toInt() ?? 18,
  maghribMinute: (json['maghribMinute'] as num?)?.toInt() ?? 0,
  ishaHour: (json['ishaHour'] as num?)?.toInt() ?? 19,
  ishaMinute: (json['ishaMinute'] as num?)?.toInt() ?? 30,
  dhikrReminderIntervals:
      (json['dhikrReminderIntervals'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [3, 6, 9],
);

Map<String, dynamic> _$NotificationSettingsToJson(
  NotificationSettings instance,
) => <String, dynamic>{
  'notificationsEnabled': instance.notificationsEnabled,
  'dhikrRemindersEnabled': instance.dhikrRemindersEnabled,
  'morningAdhkarEnabled': instance.morningAdhkarEnabled,
  'eveningAdhkarEnabled': instance.eveningAdhkarEnabled,
  'prayerRemindersEnabled': instance.prayerRemindersEnabled,
  'achievementNotificationsEnabled': instance.achievementNotificationsEnabled,
  'goalRemindersEnabled': instance.goalRemindersEnabled,
  'progressNotificationsEnabled': instance.progressNotificationsEnabled,
  'morningAdhkarHour': instance.morningAdhkarHour,
  'morningAdhkarMinute': instance.morningAdhkarMinute,
  'eveningAdhkarHour': instance.eveningAdhkarHour,
  'eveningAdhkarMinute': instance.eveningAdhkarMinute,
  'goalReminderHour': instance.goalReminderHour,
  'goalReminderMinute': instance.goalReminderMinute,
  'fajrHour': instance.fajrHour,
  'fajrMinute': instance.fajrMinute,
  'dhuhrHour': instance.dhuhrHour,
  'dhuhrMinute': instance.dhuhrMinute,
  'asrHour': instance.asrHour,
  'asrMinute': instance.asrMinute,
  'maghribHour': instance.maghribHour,
  'maghribMinute': instance.maghribMinute,
  'ishaHour': instance.ishaHour,
  'ishaMinute': instance.ishaMinute,
  'dhikrReminderIntervals': instance.dhikrReminderIntervals,
};
