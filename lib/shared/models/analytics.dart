import 'package:json_annotation/json_annotation.dart';

part 'analytics.g.dart';

@JsonSerializable()
class DailyAnalytics {
  final DateTime date;
  final int sessionsCount;
  final int totalCount;
  final Duration totalTime;
  final Map<String, int> dhikrCounts;
  final double completionRate;

  const DailyAnalytics({
    required this.date,
    required this.sessionsCount,
    required this.totalCount,
    required this.totalTime,
    required this.dhikrCounts,
    required this.completionRate,
  });

  factory DailyAnalytics.fromJson(Map<String, dynamic> json) => _$DailyAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$DailyAnalyticsToJson(this);

  static DailyAnalytics empty(DateTime date) {
    return DailyAnalytics(
      date: date,
      sessionsCount: 0,
      totalCount: 0,
      totalTime: Duration.zero,
      dhikrCounts: {},
      completionRate: 0.0,
    );
  }
}

@JsonSerializable()
class WeeklyAnalytics {
  final DateTime weekStart;
  final List<DailyAnalytics> dailyData;
  final int totalSessions;
  final int totalCount;
  final Duration totalTime;
  final double averageCompletionRate;
  final String mostUsedDhikr;
  final int streak;

  const WeeklyAnalytics({
    required this.weekStart,
    required this.dailyData,
    required this.totalSessions,
    required this.totalCount,
    required this.totalTime,
    required this.averageCompletionRate,
    required this.mostUsedDhikr,
    required this.streak,
  });

  factory WeeklyAnalytics.fromJson(Map<String, dynamic> json) => _$WeeklyAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyAnalyticsToJson(this);
}

@JsonSerializable()
class MonthlyAnalytics {
  final DateTime monthStart;
  final List<WeeklyAnalytics> weeklyData;
  final int totalSessions;
  final int totalCount;
  final Duration totalTime;
  final double averageCompletionRate;
  final Map<String, int> dhikrBreakdown;
  final List<Achievement> achievements;
  final int longestStreak;

  const MonthlyAnalytics({
    required this.monthStart,
    required this.weeklyData,
    required this.totalSessions,
    required this.totalCount,
    required this.totalTime,
    required this.averageCompletionRate,
    required this.dhikrBreakdown,
    required this.achievements,
    required this.longestStreak,
  });

  factory MonthlyAnalytics.fromJson(Map<String, dynamic> json) => _$MonthlyAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyAnalyticsToJson(this);
}

@JsonSerializable()
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime unlockedAt;
  final AchievementCategory category;
  final int progress;
  final int target;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.unlockedAt,
    required this.category,
    required this.progress,
    required this.target,
    required this.isUnlocked,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  double get progressPercentage => target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;
}

enum AchievementCategory {
  consistency,
  volume,
  variety,
  streak,
  milestone,
}

@JsonSerializable()
class PersonalGoal {
  final String id;
  final String title;
  final String description;
  final GoalType type;
  final int target;
  final int currentProgress;
  final DateTime startDate;
  final DateTime? endDate;
  final Duration? timeFrame;
  final bool isActive;
  final String? dhikrId;

  const PersonalGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.target,
    required this.currentProgress,
    required this.startDate,
    this.endDate,
    this.timeFrame,
    required this.isActive,
    this.dhikrId,
  });

  factory PersonalGoal.fromJson(Map<String, dynamic> json) => _$PersonalGoalFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalGoalToJson(this);

  double get progressPercentage => target > 0 ? (currentProgress / target).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => currentProgress >= target;
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);

  PersonalGoal updateProgress(int newProgress) {
    return PersonalGoal(
      id: id,
      title: title,
      description: description,
      type: type,
      target: target,
      currentProgress: newProgress,
      startDate: startDate,
      endDate: endDate,
      timeFrame: timeFrame,
      isActive: isActive && !isExpired,
      dhikrId: dhikrId,
    );
  }
}

enum GoalType {
  dailySessions,
  weeklyCount,
  monthlyTime,
  consecutiveDays,
  specificDhikr,
  totalCount,
}

@JsonSerializable()
class InsightData {
  final String title;
  final String description;
  final InsightType type;
  final Map<String, dynamic> data;
  final DateTime generatedAt;
  final InsightPriority priority;

  const InsightData({
    required this.title,
    required this.description,
    required this.type,
    required this.data,
    required this.generatedAt,
    required this.priority,
  });

  factory InsightData.fromJson(Map<String, dynamic> json) => _$InsightDataFromJson(json);
  Map<String, dynamic> toJson() => _$InsightDataToJson(this);
}

enum InsightType {
  streak,
  pattern,
  improvement,
  milestone,
  recommendation,
}

enum InsightPriority {
  low,
  medium,
  high,
  critical,
}