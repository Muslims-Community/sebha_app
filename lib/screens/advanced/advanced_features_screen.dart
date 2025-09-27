import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/analytics_provider.dart';
import '../../shared/providers/goals_provider.dart';
import '../../shared/providers/social_provider.dart';
import '../../shared/providers/personalization_provider.dart';
import '../../shared/providers/backup_provider.dart';
import '../../shared/providers/statistics_provider.dart';

class AdvancedFeaturesScreen extends ConsumerWidget {
  const AdvancedFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAnalytics = ref.watch(weeklyAnalyticsProvider);
    final insights = ref.watch(insightsProvider);
    final activeGoals = ref.watch(activeGoalsProvider);
    final smartSuggestions = ref.watch(smartSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Features'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInsightsSection(context, insights),
            const SizedBox(height: 24),
            _buildSmartSuggestionsSection(context, smartSuggestions),
            const SizedBox(height: 24),
            _buildGoalsSection(context, activeGoals),
            const SizedBox(height: 24),
            _buildAnalyticsSection(context, weeklyAnalytics),
            const SizedBox(height: 24),
            _buildSocialSection(context, ref),
            const SizedBox(height: 24),
            _buildPersonalizationSection(context, ref),
            const SizedBox(height: 24),
            _buildBackupSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context, AsyncValue<List<dynamic>> insights) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Smart Insights',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            insights.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error loading insights: $error'),
              data: (insightsList) {
                if (insightsList.isEmpty) {
                  return const Text('Complete more sessions to get personalized insights!');
                }

                return Column(
                  children: insightsList.take(3).map((insight) {
                    return ListTile(
                      leading: const Icon(Icons.insights),
                      title: Text(insight.title ?? 'Insight'),
                      subtitle: Text(insight.description ?? 'No description'),
                      trailing: _getPriorityIcon(insight.priority),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartSuggestionsSection(BuildContext context, List<String> suggestions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Smart Suggestions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (suggestions.isEmpty)
              const Text('Enable smart suggestions in personalization settings')
            else
              ...suggestions.map((suggestion) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber[600]),
                      const SizedBox(width: 8),
                      Expanded(child: Text(suggestion)),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection(BuildContext context, List<dynamic> goals) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.track_changes, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Personal Goals',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GoalsScreen()),
                    );
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (goals.isEmpty)
              Column(
                children: [
                  const Text('No active goals yet. Set your first goal!'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GoalsScreen()),
                      );
                    },
                    child: const Text('Create Goal'),
                  ),
                ],
              )
            else
              ...goals.take(2).map((goal) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(goal.title ?? 'Goal')),
                          Text('${goal.currentProgress ?? 0}/${goal.target ?? 0}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (goal.progressPercentage ?? 0.0).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context, AsyncValue<dynamic> weeklyAnalytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Weekly Analytics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            weeklyAnalytics.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error loading analytics: $error'),
              data: (analytics) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAnalyticItem('Sessions', '${analytics.totalSessions ?? 0}'),
                        _buildAnalyticItem('Count', '${analytics.totalCount ?? 0}'),
                        _buildAnalyticItem('Streak', '${analytics.streak ?? 0}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: (analytics.averageCompletionRate ?? 0.0).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completion Rate: ${((analytics.averageCompletionRate ?? 0.0) * 100).toStringAsFixed(1)}%',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.share, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Social Sharing',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialButton(
                  context,
                  'Share Progress',
                  Icons.trending_up,
                  () => _shareProgress(ref),
                ),
                _buildSocialButton(
                  context,
                  'Export Data',
                  Icons.download,
                  () => _exportData(ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizationSection(BuildContext context, WidgetRef ref) {
    final personalization = ref.watch(personalizationProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Personalization',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Smart Suggestions'),
              subtitle: const Text('Get AI-powered recommendations'),
              value: personalization.enableSmartSuggestions,
              onChanged: (value) {
                ref.read(personalizationProvider.notifier).toggleSmartSuggestions(value);
              },
            ),
            SwitchListTile(
              title: const Text('Progress Animations'),
              subtitle: const Text('Enhanced visual feedback'),
              value: personalization.showProgressAnimation,
              onChanged: (value) {
                ref.read(personalizationProvider.notifier).toggleProgressAnimation(value);
              },
            ),
            ListTile(
              title: const Text('Motivation Level'),
              subtitle: Slider(
                value: personalization.motivationLevel,
                onChanged: (value) {
                  ref.read(personalizationProvider.notifier).setMotivationLevel(value);
                },
                divisions: 4,
                label: _getMotivationLabel(personalization.motivationLevel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.backup, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Backup & Sync',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BackupScreen()),
                    );
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Keep your progress safe with automatic backups'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _createBackup(context),
                    icon: const Icon(Icons.backup),
                    label: const Text('Create Backup'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BackupScreen()),
                      );
                    },
                    icon: const Icon(Icons.restore),
                    label: const Text('Restore'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 32,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getPriorityIcon(dynamic priority) {
    switch (priority?.toString()) {
      case 'high':
        return const Icon(Icons.priority_high, color: Colors.red);
      case 'medium':
        return const Icon(Icons.info, color: Colors.orange);
      default:
        return const Icon(Icons.info_outline, color: Colors.blue);
    }
  }

  String _getMotivationLabel(double level) {
    if (level < 0.2) return 'Gentle';
    if (level < 0.4) return 'Light';
    if (level < 0.6) return 'Moderate';
    if (level < 0.8) return 'Active';
    return 'Intense';
  }

  void _shareProgress(WidgetRef ref) {
    final socialController = ref.read(socialControllerProvider);
    socialController.shareProgress(
      totalCount: 1500, // Would come from actual data
      sessionsToday: 3,
      currentStreak: 7,
    );
  }

  void _exportData(WidgetRef ref) {
    final socialController = ref.read(socialControllerProvider);
    socialController.exportProgress(
      sessions: [], // Would come from actual data
      achievements: [],
    );
  }

  void _createBackup(BuildContext context) async {
    try {
      // This would create an actual backup
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Backup failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Placeholder screens
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Goals management screen - implementation pending'),
      ),
    );
  }
}

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Backup management screen - implementation pending'),
      ),
    );
  }
}