import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/providers/statistics_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../main.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeFilter = 'daily';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statisticsAsync = ref.watch(statisticsProvider);
    final todayStatsAsync = ref.watch(todayStatisticsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          l10n.statistics,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportStatistics(context, ref, l10n);
                  break;
                case 'share':
                  _shareStatistics(context, ref, l10n);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.download),
                    const SizedBox(width: 8),
                    Text(l10n.export),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 8),
                    Text(l10n.share),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(l10n),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, statisticsAsync, todayStatsAsync, l10n),
                _buildAnalyticsTab(context, statisticsAsync, l10n),
                _buildInsightsTab(context, statisticsAsync, l10n),
                _buildAchievementsTab(context, statisticsAsync, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        isScrollable: true,
        tabs: [
          Tab(
            icon: const Icon(Icons.today),
            text: l10n.todaysProgress,
          ),
          Tab(
            icon: const Icon(Icons.analytics),
            text: l10n.overallStatistics,
          ),
          Tab(
            icon: const Icon(Icons.insights),
            text: l10n.insights,
          ),
          Tab(
            icon: const Icon(Icons.emoji_events),
            text: l10n.achievements,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    AsyncValue<SessionStatistics> statisticsAsync,
    AsyncValue<SessionStatistics> todayStatsAsync,
    AppLocalizations l10n,
  ) {
    return statisticsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(l10n),
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeFilterChips(l10n),
            const SizedBox(height: 16),
            _buildTodayOverview(context, todayStatsAsync, l10n),
            const SizedBox(height: 16),
            _buildQuickStats(context, stats, l10n),
            const SizedBox(height: 16),
            _buildCompletionProgress(context, stats, l10n),
            const SizedBox(height: 16),
            _buildDhikrBreakdown(context, stats, l10n),
            const SizedBox(height: 16),
            _buildRecentActivity(context, stats, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab(
    BuildContext context,
    AsyncValue<SessionStatistics> statisticsAsync,
    AppLocalizations l10n,
  ) {
    return statisticsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(l10n),
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailedMetrics(context, stats, l10n),
            const SizedBox(height: 16),
            _buildTrendAnalysis(context, stats, l10n),
            const SizedBox(height: 16),
            _buildTimeDistribution(context, stats, l10n),
            const SizedBox(height: 16),
            _buildCategoryPerformance(context, stats, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTab(
    BuildContext context,
    AsyncValue<SessionStatistics> statisticsAsync,
    AppLocalizations l10n,
  ) {
    return statisticsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(l10n),
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInsights(context, stats, l10n),
            const SizedBox(height: 16),
            _buildConsistencyAnalysis(context, stats, l10n),
            const SizedBox(height: 16),
            _buildRecommendations(context, stats, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsTab(
    BuildContext context,
    AsyncValue<SessionStatistics> statisticsAsync,
    AppLocalizations l10n,
  ) {
    return statisticsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(l10n),
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMilestones(context, stats, l10n),
            const SizedBox(height: 16),
            _buildStreaks(context, stats, l10n),
            const SizedBox(height: 16),
            _buildBadges(context, stats, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilterChips(AppLocalizations l10n) {
    final filters = [
      {'id': 'daily', 'label': l10n.daily},
      {'id': 'weekly', 'label': l10n.weekly},
      {'id': 'monthly', 'label': l10n.monthly},
      {'id': 'yearly', 'label': l10n.yearly},
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedTimeFilter == filter['id'];

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(filter['label']!),
              onSelected: (selected) {
                setState(() {
                  _selectedTimeFilter = filter['id']!;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodayOverview(
    BuildContext context,
    AsyncValue<SessionStatistics> todayStatsAsync,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.today,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.todaysProgress,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            todayStatsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text(l10n.noDataAvailable),
              data: (todayStats) => Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      l10n.sessions,
                      '${todayStats.totalSessions}',
                      Icons.play_circle_fill,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      l10n.completed,
                      '${todayStats.completedSessions}',
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      l10n.totalCount,
                      '${todayStats.totalCount}',
                      Icons.numbers,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.overallStatistics,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildQuickStatItem(
                  context,
                  l10n.totalSessions,
                  '${stats.totalSessions}',
                  Icons.history,
                  Colors.blue,
                ),
                _buildQuickStatItem(
                  context,
                  l10n.totalTime,
                  _formatDuration(stats.totalTime),
                  Icons.timer,
                  Colors.orange,
                ),
                _buildQuickStatItem(
                  context,
                  l10n.averageSession,
                  stats.totalSessions > 0
                      ? _formatDuration(Duration(
                          minutes: stats.totalTime.inMinutes ~/ stats.totalSessions))
                      : '0m',
                  Icons.speed,
                  Colors.green,
                ),
                _buildQuickStatItem(
                  context,
                  l10n.completionRate,
                  '${(stats.completionRate * 100).toStringAsFixed(1)}%',
                  Icons.pie_chart,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionProgress(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.completionRate,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: stats.completionRate,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(stats.completionRate * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  '${stats.completedSessions}/${stats.totalSessions} ${l10n.completed.toLowerCase()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDhikrBreakdown(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    if (stats.dhikrCounts.isEmpty) {
      return _buildEmptyDataCard(context, l10n);
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dhikrBreakdown,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stats.dhikrCounts.entries.take(5).map((entry) {
              final percentage = (entry.value / stats.totalSessions * 100);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _getDhikrDisplayName(entry.key),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / stats.totalSessions,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getDhikrColor(entry.key),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    if (stats.recentSessions.isEmpty) {
      return _buildEmptyDataCard(context, l10n);
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.recentSessions,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stats.recentSessions.take(5).map((session) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: session.isCompleted
                          ? Colors.green
                          : Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      child: Icon(
                        session.isCompleted ? Icons.check : Icons.more_horiz,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDhikrDisplayName(session.dhikrId),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${session.currentCount}/${session.targetCount} • ${_formatDate(session.startedAt, l10n)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (session.duration != null)
                      Text(
                        _formatDuration(session.duration!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedMetrics(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Metrics',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(l10n.longestStreak, '${_calculateStreak(stats)} ${l10n.days}', Icons.trending_up),
            _buildMetricRow(l10n.currentStreak, '${_calculateCurrentStreak(stats)} ${l10n.days}', Icons.local_fire_department),
            _buildMetricRow(l10n.averagePerDay, '${_calculateAveragePerDay(stats)}', Icons.today),
            _buildMetricRow(l10n.bestDay, _getBestDay(stats, l10n), Icons.star),
            _buildMetricRow(l10n.mostActiveHour, _getMostActiveHour(stats), Icons.schedule),
            _buildMetricRow(l10n.favoriteCategory, _getFavoriteCategory(stats), Icons.favorite),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendAnalysis(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.progressTrend,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getTrendIcon(stats),
                  color: _getTrendColor(stats),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _getTrendText(stats, l10n),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getTrendColor(stats),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getTrendDescription(stats, l10n),
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDistribution(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Distribution',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeDistributionChart(stats, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPerformance(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Performance',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Performance analysis by dhikr category will be displayed here.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInsights(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Insights',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              Icons.trending_up,
              'Progress Analysis',
              _getProgressInsight(stats, l10n),
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.schedule,
              'Time Patterns',
              _getTimePatternInsight(stats, l10n),
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.psychology,
              'Consistency Score',
              '${l10n.consistencyScore}: ${_calculateConsistencyScore(stats)}%',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsistencyAnalysis(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consistency Analysis',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your consistency analysis will be displayed here with patterns and recommendations.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smart Recommendations',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_getRecommendations(stats, l10n).map((recommendation) =>
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestones(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Milestones',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your milestones and achievements will be displayed here.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreaks(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Streaks',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStreakCard(
                    l10n.currentStreak,
                    '${_calculateCurrentStreak(stats)}',
                    l10n.days,
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStreakCard(
                    l10n.longestStreak,
                    '${_calculateStreak(stats)}',
                    l10n.days,
                    Icons.military_tech,
                    const Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges(
    BuildContext context,
    SessionStatistics stats,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Badges & Awards',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your badges and awards will be displayed here.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard(String title, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDistributionChart(SessionStatistics stats, AppLocalizations l10n) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          'Time distribution chart will be displayed here',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Error loading statistics',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDataCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.timeline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.noDataAvailable,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.startPracticingMessage,
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _exportStatistics(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export feature coming soon!'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _shareStatistics(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final statisticsAsync = ref.read(statisticsProvider);
    statisticsAsync.when(
      data: (stats) {
        final shareText = '''
${l10n.statistics}

${l10n.totalSessions}: ${stats.totalSessions}
${l10n.completed}: ${stats.completedSessions}
${l10n.totalCount}: ${stats.totalCount}
${l10n.completionRate}: ${(stats.completionRate * 100).toStringAsFixed(1)}%

Shared from Digital Tasbih App
''';
        Share.share(shareText);
      },
      loading: () {},
      error: (error, stack) {},
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return '${l10n.today} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (sessionDate == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getDhikrDisplayName(String dhikrId) {
    try {
      final dhikr = DhikrData.categories
          .expand((category) => category.dhikrs)
          .firstWhere((d) => d.id == dhikrId);
      return dhikr.title;
    } catch (e) {
      return dhikrId;
    }
  }

  Color _getDhikrColor(String dhikrId) {
    try {
      final dhikr = DhikrData.categories
          .expand((category) => category.dhikrs)
          .firstWhere((d) => d.id == dhikrId);
      return _getCategoryColor(dhikr.category);
    } catch (e) {
      return Colors.grey;
    }
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'tasbih_classical':
        return Colors.blue;
      case 'morning_adhkar':
        return Colors.orange;
      case 'evening_adhkar':
        return Colors.deepPurple;
      case 'sleeping_adhkar':
        return Colors.indigo;
      case 'istighfar':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  int _calculateStreak(SessionStatistics stats) {
    return 0;
  }

  int _calculateCurrentStreak(SessionStatistics stats) {
    return 0;
  }

  double _calculateAveragePerDay(SessionStatistics stats) {
    return 0.0;
  }

  String _getBestDay(SessionStatistics stats, AppLocalizations l10n) {
    return l10n.today;
  }

  String _getMostActiveHour(SessionStatistics stats) {
    return '9:00 AM';
  }

  String _getFavoriteCategory(SessionStatistics stats) {
    return 'Classical Tasbih';
  }

  IconData _getTrendIcon(SessionStatistics stats) {
    return Icons.trending_up;
  }

  Color _getTrendColor(SessionStatistics stats) {
    return Colors.green;
  }

  String _getTrendText(SessionStatistics stats, AppLocalizations l10n) {
    return l10n.improving;
  }

  String _getTrendDescription(SessionStatistics stats, AppLocalizations l10n) {
    return 'Your dhikr practice is showing positive trends this week.';
  }

  String _getProgressInsight(SessionStatistics stats, AppLocalizations l10n) {
    return 'You are making steady progress in your spiritual journey.';
  }

  String _getTimePatternInsight(SessionStatistics stats, AppLocalizations l10n) {
    return 'You tend to practice dhikr most actively in the morning hours.';
  }

  int _calculateConsistencyScore(SessionStatistics stats) {
    if (stats.totalSessions == 0) return 0;
    return (stats.completionRate * 100).round();
  }

  List<String> _getRecommendations(SessionStatistics stats, AppLocalizations l10n) {
    return [
      'Try setting a daily dhikr goal to maintain consistency',
      'Consider practicing morning adhkar to start your day positively',
      'Your completion rate is good - keep up the great work!',
    ];
  }
}