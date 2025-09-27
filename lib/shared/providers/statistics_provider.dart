import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dhikr.dart';
import 'session_provider.dart';

class SessionStatistics {
  final int totalSessions;
  final int completedSessions;
  final int totalCount;
  final Duration totalTime;
  final Map<String, int> dhikrCounts;
  final List<DhikrSession> recentSessions;
  final double completionRate;
  final int todaysSessions;
  final int thisWeekSessions;
  final int thisMonthSessions;

  const SessionStatistics({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalCount,
    required this.totalTime,
    required this.dhikrCounts,
    required this.recentSessions,
    required this.completionRate,
    required this.todaysSessions,
    required this.thisWeekSessions,
    required this.thisMonthSessions,
  });

  static SessionStatistics empty() {
    return const SessionStatistics(
      totalSessions: 0,
      completedSessions: 0,
      totalCount: 0,
      totalTime: Duration.zero,
      dhikrCounts: {},
      recentSessions: [],
      completionRate: 0.0,
      todaysSessions: 0,
      thisWeekSessions: 0,
      thisMonthSessions: 0,
    );
  }
}

final statisticsProvider = Provider<AsyncValue<SessionStatistics>>((ref) {
  final historyAsync = ref.watch(sessionHistoryProvider);

  return historyAsync.when(
    data: (sessions) => AsyncValue.data(_calculateStatistics(sessions)),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

SessionStatistics _calculateStatistics(List<DhikrSession> sessions) {
  if (sessions.isEmpty) {
    return SessionStatistics.empty();
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final weekStart = today.subtract(Duration(days: now.weekday - 1));
  final monthStart = DateTime(now.year, now.month, 1);

  int totalSessions = sessions.length;
  int completedSessions = 0;
  int totalCount = 0;
  Duration totalTime = Duration.zero;
  Map<String, int> dhikrCounts = {};
  int todaysSessions = 0;
  int thisWeekSessions = 0;
  int thisMonthSessions = 0;

  for (final session in sessions) {
    // Count sessions
    if (session.isCompleted) completedSessions++;
    totalCount += session.currentCount;

    // Add duration if available
    if (session.duration != null) {
      totalTime += session.duration!;
    }

    // Count by dhikr type
    dhikrCounts[session.dhikrId] = (dhikrCounts[session.dhikrId] ?? 0) + 1;

    // Time-based counts
    final sessionDate = DateTime(
      session.startedAt.year,
      session.startedAt.month,
      session.startedAt.day,
    );

    if (sessionDate.isAtSameMomentAs(today)) {
      todaysSessions++;
    }

    if (sessionDate.isAfter(weekStart.subtract(const Duration(days: 1)))) {
      thisWeekSessions++;
    }

    if (sessionDate.isAfter(monthStart.subtract(const Duration(days: 1)))) {
      thisMonthSessions++;
    }
  }

  final completionRate = totalSessions > 0 ? completedSessions / totalSessions : 0.0;
  final recentSessions = sessions.take(10).toList();

  return SessionStatistics(
    totalSessions: totalSessions,
    completedSessions: completedSessions,
    totalCount: totalCount,
    totalTime: totalTime,
    dhikrCounts: dhikrCounts,
    recentSessions: recentSessions,
    completionRate: completionRate,
    todaysSessions: todaysSessions,
    thisWeekSessions: thisWeekSessions,
    thisMonthSessions: thisMonthSessions,
  );
}

// Provider for today's statistics
final todayStatisticsProvider = Provider<AsyncValue<SessionStatistics>>((ref) {
  final historyAsync = ref.watch(sessionHistoryProvider);

  return historyAsync.when(
    data: (sessions) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final todaySessions = sessions.where((session) {
        final sessionDate = DateTime(
          session.startedAt.year,
          session.startedAt.month,
          session.startedAt.day,
        );
        return sessionDate.isAtSameMomentAs(today);
      }).toList();

      return AsyncValue.data(_calculateStatistics(todaySessions));
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});