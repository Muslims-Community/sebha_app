import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/goals_provider.dart';
import '../../shared/models/analytics.dart';
import '../../l10n/generated/app_localizations.dart';
import 'add_goal_screen.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final activeGoals = ref.watch(activeGoalsProvider);
    final completedGoals = ref.watch(completedGoalsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.goals),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddGoalScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add New Goal',
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(Icons.track_changes),
                    text: 'الأهداف النشطة',
                  ),
                  Tab(
                    icon: Icon(Icons.check_circle),
                    text: 'الأهداف المحققة',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildActiveGoalsTab(context, activeGoals, ref, l10n),
                  _buildCompletedGoalsTab(context, completedGoals, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGoalsTab(BuildContext context, List<PersonalGoal> activeGoals, WidgetRef ref, AppLocalizations l10n) {
    if (activeGoals.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.track_changes,
        title: 'لا توجد أهداف نشطة',
        subtitle: 'أضف هدفاً جديداً لبدء رحلة التطور الروحي',
        actionText: 'إضافة هدف',
        onAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGoalScreen(),
            ),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeGoals.length,
      itemBuilder: (context, index) {
        final goal = activeGoals[index];
        return _buildGoalCard(context, goal, ref, l10n, isActive: true);
      },
    );
  }

  Widget _buildCompletedGoalsTab(BuildContext context, List<PersonalGoal> completedGoals, AppLocalizations l10n) {
    if (completedGoals.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.emoji_events,
        title: 'لا توجد أهداف محققة بعد',
        subtitle: 'أكمل أهدافك النشطة لترى إنجازاتك هنا',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedGoals.length,
      itemBuilder: (context, index) {
        final goal = completedGoals[index];
        return _buildGoalCard(context, goal, null, l10n, isActive: false);
      },
    );
  }

  Widget _buildGoalCard(BuildContext context, PersonalGoal goal, WidgetRef? ref, AppLocalizations l10n, {required bool isActive}) {
    final progressPercentage = goal.progressPercentage;
    final isCompleted = goal.isCompleted;
    final isExpired = goal.isExpired;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGoalTypeColor(goal.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getGoalTypeText(goal.type),
                    style: TextStyle(
                      color: _getGoalTypeColor(goal.type),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (isExpired && !isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'منتهي الصلاحية',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.completed,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              goal.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              goal.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'التقدم: ${goal.currentProgress} / ${goal.target}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(progressPercentage * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressPercentage,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? Colors.green : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (goal.endDate != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'ينتهي في: ${_formatDate(goal.endDate!)}' ,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
            if (isActive && ref != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showDeleteGoalDialog(context, goal, ref),
                    icon: const Icon(Icons.delete, size: 16),
                    label: Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: isCompleted ? null : () => _updateGoalProgress(context, goal, ref),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('تحديث التقدم'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getGoalTypeColor(GoalType type) {
    switch (type) {
      case GoalType.dailySessions:
        return Colors.blue;
      case GoalType.weeklyCount:
        return Colors.green;
      case GoalType.monthlyTime:
        return Colors.orange;
      case GoalType.consecutiveDays:
        return Colors.purple;
      case GoalType.specificDhikr:
        return Colors.teal;
      case GoalType.totalCount:
        return Colors.indigo;
    }
  }

  String _getGoalTypeText(GoalType type) {
    switch (type) {
      case GoalType.dailySessions:
        return 'جلسات يومية';
      case GoalType.weeklyCount:
        return 'عدد أسبوعي';
      case GoalType.monthlyTime:
        return 'وقت شهري';
      case GoalType.consecutiveDays:
        return 'أيام متتالية';
      case GoalType.specificDhikr:
        return 'ذكر محدد';
      case GoalType.totalCount:
        return 'العدد الإجمالي';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'Expired';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return '${difference} أيام';
    }
  }

  void _updateGoalProgress(BuildContext context, PersonalGoal goal, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        int newProgress = goal.currentProgress;
        return AlertDialog(
          title: const Text('تحديث التقدم'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('التقدم الحالي: ${goal.currentProgress} / ${goal.target}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (newProgress > 0) newProgress--;
                      Navigator.pop(context);
                      ref.read(goalsProvider.notifier).updateGoalProgress(goal.id, newProgress);
                    },
                    child: const Text('-1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      newProgress++;
                      Navigator.pop(context);
                      ref.read(goalsProvider.notifier).updateGoalProgress(goal.id, newProgress);
                    },
                    child: const Text('+1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      newProgress += 10;
                      Navigator.pop(context);
                      ref.read(goalsProvider.notifier).updateGoalProgress(goal.id, newProgress);
                    },
                    child: const Text('+10'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteGoalDialog(BuildContext context, PersonalGoal goal, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف الهدف'),
          content: Text('هل أنت متأكد من رغبتك في حذف هدف "${goal.title}"؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(goalsProvider.notifier).deleteGoal(goal.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}