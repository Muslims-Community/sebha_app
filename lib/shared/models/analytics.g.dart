// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAnalytics _$DailyAnalyticsFromJson(Map<String, dynamic> json) =>
    DailyAnalytics(
      date: DateTime.parse(json['date'] as String),
      sessionsCount: (json['sessionsCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalTime: Duration(microseconds: (json['totalTime'] as num).toInt()),
      dhikrCounts: Map<String, int>.from(json['dhikrCounts'] as Map),
      completionRate: (json['completionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyAnalyticsToJson(DailyAnalytics instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'sessionsCount': instance.sessionsCount,
      'totalCount': instance.totalCount,
      'totalTime': instance.totalTime.inMicroseconds,
      'dhikrCounts': instance.dhikrCounts,
      'completionRate': instance.completionRate,
    };

WeeklyAnalytics _$WeeklyAnalyticsFromJson(Map<String, dynamic> json) =>
    WeeklyAnalytics(
      weekStart: DateTime.parse(json['weekStart'] as String),
      dailyData: (json['dailyData'] as List<dynamic>)
          .map((e) => DailyAnalytics.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSessions: (json['totalSessions'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalTime: Duration(microseconds: (json['totalTime'] as num).toInt()),
      averageCompletionRate: (json['averageCompletionRate'] as num).toDouble(),
      mostUsedDhikr: json['mostUsedDhikr'] as String,
      streak: (json['streak'] as num).toInt(),
    );

Map<String, dynamic> _$WeeklyAnalyticsToJson(WeeklyAnalytics instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart.toIso8601String(),
      'dailyData': instance.dailyData,
      'totalSessions': instance.totalSessions,
      'totalCount': instance.totalCount,
      'totalTime': instance.totalTime.inMicroseconds,
      'averageCompletionRate': instance.averageCompletionRate,
      'mostUsedDhikr': instance.mostUsedDhikr,
      'streak': instance.streak,
    };

MonthlyAnalytics _$MonthlyAnalyticsFromJson(Map<String, dynamic> json) =>
    MonthlyAnalytics(
      monthStart: DateTime.parse(json['monthStart'] as String),
      weeklyData: (json['weeklyData'] as List<dynamic>)
          .map((e) => WeeklyAnalytics.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSessions: (json['totalSessions'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalTime: Duration(microseconds: (json['totalTime'] as num).toInt()),
      averageCompletionRate: (json['averageCompletionRate'] as num).toDouble(),
      dhikrBreakdown: Map<String, int>.from(json['dhikrBreakdown'] as Map),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      longestStreak: (json['longestStreak'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlyAnalyticsToJson(MonthlyAnalytics instance) =>
    <String, dynamic>{
      'monthStart': instance.monthStart.toIso8601String(),
      'weeklyData': instance.weeklyData,
      'totalSessions': instance.totalSessions,
      'totalCount': instance.totalCount,
      'totalTime': instance.totalTime.inMicroseconds,
      'averageCompletionRate': instance.averageCompletionRate,
      'dhikrBreakdown': instance.dhikrBreakdown,
      'achievements': instance.achievements,
      'longestStreak': instance.longestStreak,
    };

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  iconName: json['iconName'] as String,
  unlockedAt: DateTime.parse(json['unlockedAt'] as String),
  category: $enumDecode(_$AchievementCategoryEnumMap, json['category']),
  progress: (json['progress'] as num).toInt(),
  target: (json['target'] as num).toInt(),
  isUnlocked: json['isUnlocked'] as bool,
);

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconName': instance.iconName,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
      'category': _$AchievementCategoryEnumMap[instance.category]!,
      'progress': instance.progress,
      'target': instance.target,
      'isUnlocked': instance.isUnlocked,
    };

const _$AchievementCategoryEnumMap = {
  AchievementCategory.consistency: 'consistency',
  AchievementCategory.volume: 'volume',
  AchievementCategory.variety: 'variety',
  AchievementCategory.streak: 'streak',
  AchievementCategory.milestone: 'milestone',
};

PersonalGoal _$PersonalGoalFromJson(Map<String, dynamic> json) => PersonalGoal(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$GoalTypeEnumMap, json['type']),
  target: (json['target'] as num).toInt(),
  currentProgress: (json['currentProgress'] as num).toInt(),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  timeFrame: json['timeFrame'] == null
      ? null
      : Duration(microseconds: (json['timeFrame'] as num).toInt()),
  isActive: json['isActive'] as bool,
  dhikrId: json['dhikrId'] as String?,
);

Map<String, dynamic> _$PersonalGoalToJson(PersonalGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$GoalTypeEnumMap[instance.type]!,
      'target': instance.target,
      'currentProgress': instance.currentProgress,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'timeFrame': instance.timeFrame?.inMicroseconds,
      'isActive': instance.isActive,
      'dhikrId': instance.dhikrId,
    };

const _$GoalTypeEnumMap = {
  GoalType.dailySessions: 'dailySessions',
  GoalType.weeklyCount: 'weeklyCount',
  GoalType.monthlyTime: 'monthlyTime',
  GoalType.consecutiveDays: 'consecutiveDays',
  GoalType.specificDhikr: 'specificDhikr',
  GoalType.totalCount: 'totalCount',
};

InsightData _$InsightDataFromJson(Map<String, dynamic> json) => InsightData(
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$InsightTypeEnumMap, json['type']),
  data: json['data'] as Map<String, dynamic>,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  priority: $enumDecode(_$InsightPriorityEnumMap, json['priority']),
);

Map<String, dynamic> _$InsightDataToJson(InsightData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'type': _$InsightTypeEnumMap[instance.type]!,
      'data': instance.data,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'priority': _$InsightPriorityEnumMap[instance.priority]!,
    };

const _$InsightTypeEnumMap = {
  InsightType.streak: 'streak',
  InsightType.pattern: 'pattern',
  InsightType.improvement: 'improvement',
  InsightType.milestone: 'milestone',
  InsightType.recommendation: 'recommendation',
};

const _$InsightPriorityEnumMap = {
  InsightPriority.low: 'low',
  InsightPriority.medium: 'medium',
  InsightPriority.high: 'high',
  InsightPriority.critical: 'critical',
};
