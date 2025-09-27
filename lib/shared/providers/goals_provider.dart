import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/analytics.dart';
import 'session_provider.dart';

class GoalsNotifier extends StateNotifier<List<PersonalGoal>> {
  GoalsNotifier() : super([]) {
    _loadGoals();
  }

  static const String _goalsKey = 'personal_goals';

  Future<void> _loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalsJson = prefs.getString(_goalsKey) ?? '[]';
      final goalsList = json.decode(goalsJson) as List<dynamic>;

      state = goalsList
          .map((json) => PersonalGoal.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      state = [];
    }
  }

  Future<void> _saveGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalsJson = json.encode(state.map((goal) => goal.toJson()).toList());
      await prefs.setString(_goalsKey, goalsJson);
    } catch (e) {
      // Handle save error gracefully
    }
  }

  Future<void> addGoal(PersonalGoal goal) async {
    state = [...state, goal];
    await _saveGoals();
  }

  Future<void> updateGoal(String id, PersonalGoal updatedGoal) async {
    state = state.map((goal) => goal.id == id ? updatedGoal : goal).toList();
    await _saveGoals();
  }

  Future<void> deleteGoal(String id) async {
    state = state.where((goal) => goal.id != id).toList();
    await _saveGoals();
  }

  Future<void> updateGoalProgress(String goalId, int newProgress) async {
    state = state.map((goal) {
      if (goal.id == goalId) {
        return goal.updateProgress(newProgress);
      }
      return goal;
    }).toList();
    await _saveGoals();
  }

  List<PersonalGoal> getActiveGoals() {
    return state.where((goal) => goal.isActive && !goal.isExpired).toList();
  }

  List<PersonalGoal> getCompletedGoals() {
    return state.where((goal) => goal.isCompleted).toList();
  }

  static PersonalGoal createDailySessionGoal({
    required String title,
    required int targetSessions,
    Duration? timeFrame,
  }) {
    return PersonalGoal(
      id: const Uuid().v4(),
      title: title,
      description: 'Complete $targetSessions dhikr sessions',
      type: GoalType.dailySessions,
      target: targetSessions,
      currentProgress: 0,
      startDate: DateTime.now(),
      endDate: timeFrame != null ? DateTime.now().add(timeFrame) : null,
      timeFrame: timeFrame,
      isActive: true,
    );
  }

  static PersonalGoal createWeeklyCountGoal({
    required String title,
    required int targetCount,
    String? dhikrId,
  }) {
    return PersonalGoal(
      id: const Uuid().v4(),
      title: title,
      description: dhikrId != null
          ? 'Complete $targetCount recitations of specific dhikr this week'
          : 'Complete $targetCount recitations this week',
      type: GoalType.weeklyCount,
      target: targetCount,
      currentProgress: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      timeFrame: const Duration(days: 7),
      isActive: true,
      dhikrId: dhikrId,
    );
  }

  static PersonalGoal createStreakGoal({
    required String title,
    required int targetDays,
  }) {
    return PersonalGoal(
      id: const Uuid().v4(),
      title: title,
      description: 'Maintain dhikr practice for $targetDays consecutive days',
      type: GoalType.consecutiveDays,
      target: targetDays,
      currentProgress: 0,
      startDate: DateTime.now(),
      isActive: true,
    );
  }
}

final goalsProvider = StateNotifierProvider<GoalsNotifier, List<PersonalGoal>>((ref) {
  return GoalsNotifier();
});

// Provider for active goals
final activeGoalsProvider = Provider<List<PersonalGoal>>((ref) {
  final goals = ref.watch(goalsProvider);
  return goals.where((goal) => goal.isActive && !goal.isExpired).toList();
});

// Provider for completed goals
final completedGoalsProvider = Provider<List<PersonalGoal>>((ref) {
  final goals = ref.watch(goalsProvider);
  return goals.where((goal) => goal.isCompleted).toList();
});

// Provider for achievements
final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier();
});

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  AchievementsNotifier() : super([]) {
    _initializeAchievements();
  }

  void _initializeAchievements() {
    final baseAchievements = [
      Achievement(
        id: 'first_session',
        title: 'First Steps',
        description: 'Complete your first dhikr session',
        iconName: 'star',
        unlockedAt: DateTime.now(),
        category: AchievementCategory.milestone,
        progress: 0,
        target: 1,
        isUnlocked: false,
      ),
      Achievement(
        id: 'week_streak',
        title: 'Consistent Week',
        description: 'Practice dhikr for 7 consecutive days',
        iconName: 'calendar_week',
        unlockedAt: DateTime.now(),
        category: AchievementCategory.streak,
        progress: 0,
        target: 7,
        isUnlocked: false,
      ),
      Achievement(
        id: 'hundred_count',
        title: 'Century Mark',
        description: 'Complete 100 dhikr recitations',
        iconName: 'hundred',
        unlockedAt: DateTime.now(),
        category: AchievementCategory.volume,
        progress: 0,
        target: 100,
        isUnlocked: false,
      ),
      Achievement(
        id: 'all_categories',
        title: 'Explorer',
        description: 'Try dhikr from all categories',
        iconName: 'explore',
        unlockedAt: DateTime.now(),
        category: AchievementCategory.variety,
        progress: 0,
        target: 4,
        isUnlocked: false,
      ),
      Achievement(
        id: 'month_streak',
        title: 'Monthly Devotion',
        description: 'Practice dhikr for 30 consecutive days',
        iconName: 'calendar_month',
        unlockedAt: DateTime.now(),
        category: AchievementCategory.streak,
        progress: 0,
        target: 30,
        isUnlocked: false,
      ),
    ];

    state = baseAchievements;
  }

  void updateProgress(String achievementId, int newProgress) {
    state = state.map((achievement) {
      if (achievement.id == achievementId) {
        final isNewlyUnlocked = !achievement.isUnlocked && newProgress >= achievement.target;
        return Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          iconName: achievement.iconName,
          unlockedAt: isNewlyUnlocked ? DateTime.now() : achievement.unlockedAt,
          category: achievement.category,
          progress: newProgress,
          target: achievement.target,
          isUnlocked: newProgress >= achievement.target,
        );
      }
      return achievement;
    }).toList();
  }

  List<Achievement> getUnlockedAchievements() {
    return state.where((achievement) => achievement.isUnlocked).toList();
  }

  List<Achievement> getInProgressAchievements() {
    return state.where((achievement) => !achievement.isUnlocked && achievement.progress > 0).toList();
  }
}