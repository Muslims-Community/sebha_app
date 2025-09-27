import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics.dart';
import '../models/dhikr.dart';
import 'session_provider.dart';

class AnalyticsService {
  static DailyAnalytics calculateDailyAnalytics(DateTime date, List<DhikrSession> sessions) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final daySessions = sessions.where((session) =>
        session.startedAt.isAfter(dayStart) && session.startedAt.isBefore(dayEnd)).toList();

    if (daySessions.isEmpty) {
      return DailyAnalytics.empty(date);
    }

    final sessionsCount = daySessions.length;
    final totalCount = daySessions.fold<int>(0, (sum, session) => sum + session.currentCount);
    final totalTime = daySessions
        .where((session) => session.duration != null)
        .fold<Duration>(Duration.zero, (sum, session) => sum + session.duration!);

    final dhikrCounts = <String, int>{};
    for (final session in daySessions) {
      dhikrCounts[session.dhikrId] = (dhikrCounts[session.dhikrId] ?? 0) + 1;
    }

    final completedSessions = daySessions.where((session) => session.isCompleted).length;
    final completionRate = sessionsCount > 0 ? completedSessions / sessionsCount : 0.0;

    return DailyAnalytics(
      date: date,
      sessionsCount: sessionsCount,
      totalCount: totalCount,
      totalTime: totalTime,
      dhikrCounts: dhikrCounts,
      completionRate: completionRate,
    );
  }

  static WeeklyAnalytics calculateWeeklyAnalytics(DateTime weekStart, List<DhikrSession> sessions) {
    final dailyData = <DailyAnalytics>[];

    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      dailyData.add(calculateDailyAnalytics(date, sessions));
    }

    final totalSessions = dailyData.fold<int>(0, (sum, day) => sum + day.sessionsCount);
    final totalCount = dailyData.fold<int>(0, (sum, day) => sum + day.totalCount);
    final totalTime = dailyData.fold<Duration>(Duration.zero, (sum, day) => sum + day.totalTime);

    final averageCompletionRate = dailyData.isNotEmpty
        ? dailyData.fold<double>(0, (sum, day) => sum + day.completionRate) / dailyData.length
        : 0.0;

    // Find most used dhikr
    final allDhikrCounts = <String, int>{};
    for (final day in dailyData) {
      day.dhikrCounts.forEach((dhikr, count) {
        allDhikrCounts[dhikr] = (allDhikrCounts[dhikr] ?? 0) + count;
      });
    }

    final mostUsedDhikr = allDhikrCounts.isEmpty
        ? ''
        : allDhikrCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Calculate streak
    int streak = 0;
    for (int i = dailyData.length - 1; i >= 0; i--) {
      if (dailyData[i].sessionsCount > 0) {
        streak++;
      } else {
        break;
      }
    }

    return WeeklyAnalytics(
      weekStart: weekStart,
      dailyData: dailyData,
      totalSessions: totalSessions,
      totalCount: totalCount,
      totalTime: totalTime,
      averageCompletionRate: averageCompletionRate,
      mostUsedDhikr: mostUsedDhikr,
      streak: streak,
    );
  }

  static List<InsightData> generateInsights(List<DhikrSession> sessions) {
    final insights = <InsightData>[];
    final now = DateTime.now();

    // Streak insight
    final streak = _calculateCurrentStreak(sessions);
    if (streak >= 3) {
      insights.add(InsightData(
        title: 'Great Streak!',
        description: 'You\'re on a $streak-day streak! Keep it up!',
        type: InsightType.streak,
        data: {'streak': streak},
        generatedAt: now,
        priority: streak >= 7 ? InsightPriority.high : InsightPriority.medium,
      ));
    }

    // Pattern insight
    final preferredTime = _findPreferredTime(sessions);
    if (preferredTime != null) {
      insights.add(InsightData(
        title: 'Peak Performance Time',
        description: 'You complete most dhikr sessions around $preferredTime',
        type: InsightType.pattern,
        data: {'time': preferredTime},
        generatedAt: now,
        priority: InsightPriority.low,
      ));
    }

    // Milestone insight
    final totalCount = sessions.fold<int>(0, (sum, session) => sum + session.currentCount);
    if (totalCount >= 1000 && totalCount % 1000 == 0) {
      insights.add(InsightData(
        title: 'Milestone Reached!',
        description: 'You\'ve completed $totalCount dhikr recitations!',
        type: InsightType.milestone,
        data: {'count': totalCount},
        generatedAt: now,
        priority: InsightPriority.high,
      ));
    }

    return insights;
  }

  static int _calculateCurrentStreak(List<DhikrSession> sessions) {
    if (sessions.isEmpty) return 0;

    final now = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 30; i++) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dayStart = date;
      final dayEnd = date.add(const Duration(days: 1));

      final hasSessions = sessions.any((session) =>
          session.startedAt.isAfter(dayStart) && session.startedAt.isBefore(dayEnd));

      if (hasSessions) {
        streak++;
      } else if (i == 0) {
        // If today has no sessions, check yesterday
        continue;
      } else {
        break;
      }
    }

    return streak;
  }

  static String? _findPreferredTime(List<DhikrSession> sessions) {
    if (sessions.isEmpty) return null;

    final hourCounts = <int, int>{};
    for (final session in sessions) {
      final hour = session.startedAt.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    if (hourCounts.isEmpty) return null;

    final mostFrequentHour = hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    if (mostFrequentHour < 6) {
      return 'early morning';
    } else if (mostFrequentHour < 12) {
      return 'morning';
    } else if (mostFrequentHour < 17) {
      return 'afternoon';
    } else if (mostFrequentHour < 21) {
      return 'evening';
    } else {
      return 'night';
    }
  }
}

// Provider for current week analytics
final weeklyAnalyticsProvider = Provider<AsyncValue<WeeklyAnalytics>>((ref) {
  final historyAsync = ref.watch(sessionHistoryProvider);

  return historyAsync.when(
    data: (sessions) {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

      return AsyncValue.data(AnalyticsService.calculateWeeklyAnalytics(weekStartDate, sessions));
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Provider for insights
final insightsProvider = Provider<AsyncValue<List<InsightData>>>((ref) {
  final historyAsync = ref.watch(sessionHistoryProvider);

  return historyAsync.when(
    data: (sessions) => AsyncValue.data(AnalyticsService.generateInsights(sessions)),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Provider for daily analytics for a specific date
final dailyAnalyticsProvider = Provider.family<AsyncValue<DailyAnalytics>, DateTime>((ref, date) {
  final historyAsync = ref.watch(sessionHistoryProvider);

  return historyAsync.when(
    data: (sessions) => AsyncValue.data(AnalyticsService.calculateDailyAnalytics(date, sessions)),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});