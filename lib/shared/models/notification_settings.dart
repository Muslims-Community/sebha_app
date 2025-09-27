import 'package:json_annotation/json_annotation.dart';

part 'notification_settings.g.dart';

@JsonSerializable()
class NotificationSettings {
  final bool notificationsEnabled;
  final bool dhikrRemindersEnabled;
  final bool morningAdhkarEnabled;
  final bool eveningAdhkarEnabled;
  final bool prayerRemindersEnabled;
  final bool achievementNotificationsEnabled;
  final bool goalRemindersEnabled;
  final bool progressNotificationsEnabled;

  // Timing settings
  final int morningAdhkarHour;
  final int morningAdhkarMinute;
  final int eveningAdhkarHour;
  final int eveningAdhkarMinute;
  final int goalReminderHour;
  final int goalReminderMinute;

  // Prayer times
  final int fajrHour;
  final int fajrMinute;
  final int dhuhrHour;
  final int dhuhrMinute;
  final int asrHour;
  final int asrMinute;
  final int maghribHour;
  final int maghribMinute;
  final int ishaHour;
  final int ishaMinute;

  // Dhikr reminder intervals (in hours)
  final List<int> dhikrReminderIntervals;

  const NotificationSettings({
    this.notificationsEnabled = true,
    this.dhikrRemindersEnabled = true,
    this.morningAdhkarEnabled = true,
    this.eveningAdhkarEnabled = true,
    this.prayerRemindersEnabled = false,
    this.achievementNotificationsEnabled = true,
    this.goalRemindersEnabled = true,
    this.progressNotificationsEnabled = false,

    // Default timing
    this.morningAdhkarHour = 6,
    this.morningAdhkarMinute = 0,
    this.eveningAdhkarHour = 18,
    this.eveningAdhkarMinute = 0,
    this.goalReminderHour = 20,
    this.goalReminderMinute = 0,

    // Default prayer times (these should be updated based on location)
    this.fajrHour = 5,
    this.fajrMinute = 30,
    this.dhuhrHour = 12,
    this.dhuhrMinute = 30,
    this.asrHour = 15,
    this.asrMinute = 30,
    this.maghribHour = 18,
    this.maghribMinute = 0,
    this.ishaHour = 19,
    this.ishaMinute = 30,

    // Default dhikr reminder intervals (every 3, 6, 9 hours)
    this.dhikrReminderIntervals = const [3, 6, 9],
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);

  NotificationSettings copyWith({
    bool? notificationsEnabled,
    bool? dhikrRemindersEnabled,
    bool? morningAdhkarEnabled,
    bool? eveningAdhkarEnabled,
    bool? prayerRemindersEnabled,
    bool? achievementNotificationsEnabled,
    bool? goalRemindersEnabled,
    bool? progressNotificationsEnabled,
    int? morningAdhkarHour,
    int? morningAdhkarMinute,
    int? eveningAdhkarHour,
    int? eveningAdhkarMinute,
    int? goalReminderHour,
    int? goalReminderMinute,
    int? fajrHour,
    int? fajrMinute,
    int? dhuhrHour,
    int? dhuhrMinute,
    int? asrHour,
    int? asrMinute,
    int? maghribHour,
    int? maghribMinute,
    int? ishaHour,
    int? ishaMinute,
    List<int>? dhikrReminderIntervals,
  }) {
    return NotificationSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dhikrRemindersEnabled: dhikrRemindersEnabled ?? this.dhikrRemindersEnabled,
      morningAdhkarEnabled: morningAdhkarEnabled ?? this.morningAdhkarEnabled,
      eveningAdhkarEnabled: eveningAdhkarEnabled ?? this.eveningAdhkarEnabled,
      prayerRemindersEnabled: prayerRemindersEnabled ?? this.prayerRemindersEnabled,
      achievementNotificationsEnabled: achievementNotificationsEnabled ?? this.achievementNotificationsEnabled,
      goalRemindersEnabled: goalRemindersEnabled ?? this.goalRemindersEnabled,
      progressNotificationsEnabled: progressNotificationsEnabled ?? this.progressNotificationsEnabled,
      morningAdhkarHour: morningAdhkarHour ?? this.morningAdhkarHour,
      morningAdhkarMinute: morningAdhkarMinute ?? this.morningAdhkarMinute,
      eveningAdhkarHour: eveningAdhkarHour ?? this.eveningAdhkarHour,
      eveningAdhkarMinute: eveningAdhkarMinute ?? this.eveningAdhkarMinute,
      goalReminderHour: goalReminderHour ?? this.goalReminderHour,
      goalReminderMinute: goalReminderMinute ?? this.goalReminderMinute,
      fajrHour: fajrHour ?? this.fajrHour,
      fajrMinute: fajrMinute ?? this.fajrMinute,
      dhuhrHour: dhuhrHour ?? this.dhuhrHour,
      dhuhrMinute: dhuhrMinute ?? this.dhuhrMinute,
      asrHour: asrHour ?? this.asrHour,
      asrMinute: asrMinute ?? this.asrMinute,
      maghribHour: maghribHour ?? this.maghribHour,
      maghribMinute: maghribMinute ?? this.maghribMinute,
      ishaHour: ishaHour ?? this.ishaHour,
      ishaMinute: ishaMinute ?? this.ishaMinute,
      dhikrReminderIntervals: dhikrReminderIntervals ?? this.dhikrReminderIntervals,
    );
  }

  // Helper methods for display
  String get morningAdhkarTimeString => '${morningAdhkarHour.toString().padLeft(2, '0')}:${morningAdhkarMinute.toString().padLeft(2, '0')}';
  String get eveningAdhkarTimeString => '${eveningAdhkarHour.toString().padLeft(2, '0')}:${eveningAdhkarMinute.toString().padLeft(2, '0')}';
  String get goalReminderTimeString => '${goalReminderHour.toString().padLeft(2, '0')}:${goalReminderMinute.toString().padLeft(2, '0')}';

  String get fajrTimeString => '${fajrHour.toString().padLeft(2, '0')}:${fajrMinute.toString().padLeft(2, '0')}';
  String get dhuhrTimeString => '${dhuhrHour.toString().padLeft(2, '0')}:${dhuhrMinute.toString().padLeft(2, '0')}';
  String get asrTimeString => '${asrHour.toString().padLeft(2, '0')}:${asrMinute.toString().padLeft(2, '0')}';
  String get maghribTimeString => '${maghribHour.toString().padLeft(2, '0')}:${maghribMinute.toString().padLeft(2, '0')}';
  String get ishaTimeString => '${ishaHour.toString().padLeft(2, '0')}:${ishaMinute.toString().padLeft(2, '0')}';
}