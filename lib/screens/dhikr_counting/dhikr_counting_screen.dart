import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:confetti/confetti.dart';
import '../../main.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/providers/session_provider.dart';
import '../../shared/providers/audio_provider.dart';
import '../../shared/providers/goals_provider.dart';
import '../../shared/models/dhikr.dart' as new_models;
import '../../shared/models/analytics.dart';
import '../category_selection/category_selection_screen.dart';

class DhikrCountingScreen extends ConsumerStatefulWidget {
  final DhikrCategory category;
  final int? startingDhikrIndex;

  const DhikrCountingScreen({
    super.key,
    required this.category,
    this.startingDhikrIndex,
  });

  @override
  ConsumerState<DhikrCountingScreen> createState() => _DhikrCountingScreenState();
}

class _DhikrCountingScreenState extends ConsumerState<DhikrCountingScreen>
    with TickerProviderStateMixin {
  int _count = 0;
  int _currentDhikrIndex = 0;
  bool _isLoading = true;
  late AnimationController _countAnimationController;
  late AnimationController _celebrationController;
  late ConfettiController _confettiController;
  late Animation<double> _countAnimation;
  late Animation<double> _celebrationAnimation;

  Dhikr get _currentDhikr => widget.category.dhikrs[_currentDhikrIndex];

  double get _categoryProgress {
    int completedDhikrs = _currentDhikrIndex;
    if (_count >= _currentDhikr.targetCount) {
      completedDhikrs++;
    }
    return completedDhikrs / widget.category.dhikrs.length;
  }

  bool get _isLastDhikrInCategory => _currentDhikrIndex >= widget.category.dhikrs.length - 1;

  @override
  void initState() {
    super.initState();
    _currentDhikrIndex = widget.startingDhikrIndex ?? 0;

    _countAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _countAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _countAnimationController,
      curve: Curves.elasticOut,
    ));

    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.bounceOut,
    ));

    _loadCount();
  }

  @override
  void dispose() {
    _countAnimationController.dispose();
    _celebrationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    final categoryKey = 'category_${widget.category.id}_dhikr_${_currentDhikrIndex}_count';

    setState(() {
      _count = prefs.getInt(categoryKey) ?? 0;
      _isLoading = false;
    });

    // Start session
    await ref.read(sessionProvider.notifier).startSession(_convertToNewDhikr(_currentDhikr));
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    final categoryKey = 'category_${widget.category.id}_dhikr_${_currentDhikrIndex}_count';
    await prefs.setInt(categoryKey, _count);
  }

  // Convert old dhikr model to new model
  new_models.Dhikr _convertToNewDhikr(Dhikr oldDhikr) {
    return new_models.Dhikr.create(
      titleKey: oldDhikr.title,
      arabicText: oldDhikr.arabicText,
      targetCount: oldDhikr.targetCount,
      categoryId: oldDhikr.category,
      transliteration: oldDhikr.transliteration,
      meaningKey: oldDhikr.meaning,
    );
  }

  void _incrementCounter() async {
    // Animate the count button
    _countAnimationController.forward().then((_) {
      _countAnimationController.reverse();
    });

    setState(() {
      _count++;
    });

    // Update session count
    await ref.read(sessionProvider.notifier).incrementCount();

    // Update achievements and goals
    _updateAchievements();
    _updateGoals();

    // Get audio and vibration settings
    final settings = ref.read(settingsProvider);
    final audioController = ref.read(audioControlProvider);

    // Play audio if enabled
    if (settings.soundEnabled) {
      await audioController.playDhikrAudio(_currentDhikr.id);
    }

    // Vibrate if enabled
    if (settings.vibrationEnabled) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50);
      }
    }

    await _saveCount();

    // Check if current dhikr is completed
    if (_count >= _currentDhikr.targetCount) {
      _handleDhikrCompletion();
    }
  }

  void _handleDhikrCompletion() {
    if (_isLastDhikrInCategory) {
      _handleCategoryCompletion();
    } else {
      _showDhikrCompletionCelebration();
      // Auto advance after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        _advanceToNextDhikr();
      });
    }
  }

  void _advanceToNextDhikr() {
    setState(() {
      _currentDhikrIndex++;
      _count = 0;
    });

    // Start new session with next dhikr
    ref.read(sessionProvider.notifier).startSession(_convertToNewDhikr(_currentDhikr));
    _saveCount();
  }

  void _showDhikrCompletionCelebration() {
    _celebrationController.forward().then((_) {
      _celebrationController.reverse();
    });
  }

  void _handleCategoryCompletion() {
    _confettiController.play();
    _showCategoryCompletionDialog();
  }

  void _showCategoryCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '🎉 تهانينا! 🎉',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'لقد أكملت جميع أذكار فئة "${widget.category.title}"',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.category.dhikrs.length} أذكار مكتملة',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('إنهاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const CategorySelectionScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('اختر فئة أخرى'),
            ),
          ],
        );
      },
    );
  }

  void _selectNewCategory() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CategorySelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _resetCounter() async {
    setState(() {
      _count = 0;
    });
    await ref.read(sessionProvider.notifier).resetSession();
    await _saveCount();
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('إعادة تعيين العداد'),
          content: const Text('هل تريد إعادة تعيين العداد إلى الصفر؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetCounter();
              },
              child: const Text('إعادة تعيين'),
            ),
          ],
        );
      },
    );
  }

  // Update achievements based on usage
  void _updateAchievements() {
    final achievementsNotifier = ref.read(achievementsProvider.notifier);

    // Update first session achievement
    if (_count == 1) {
      achievementsNotifier.updateProgress('first_session', 1);
    }

    // Update count-based achievements
    achievementsNotifier.updateProgress('hundred_count', _count);
  }

  // Update goals based on usage
  void _updateGoals() {
    final goals = ref.read(activeGoalsProvider);
    final goalsNotifier = ref.read(goalsProvider.notifier);
    final currentSession = ref.read(sessionProvider);

    for (final goal in goals) {
      switch (goal.type) {
        case GoalType.dailySessions:
          if (currentSession != null && currentSession.isCompleted) {
            int currentProgress = goal.currentProgress + 1;
            goalsNotifier.updateGoalProgress(goal.id, currentProgress);
          }
          break;
        case GoalType.weeklyCount:
          if (goal.dhikrId == null || goal.dhikrId == _currentDhikr.id) {
            int newProgress = goal.currentProgress + 1;
            goalsNotifier.updateGoalProgress(goal.id, newProgress);
          }
          break;
        case GoalType.specificDhikr:
          if (goal.dhikrId == _currentDhikr.id) {
            int newProgress = goal.currentProgress + 1;
            goalsNotifier.updateGoalProgress(goal.id, newProgress);
          }
          break;
        case GoalType.totalCount:
          int newProgress = goal.currentProgress + 1;
          goalsNotifier.updateGoalProgress(goal.id, newProgress);
          break;
        case GoalType.monthlyTime:
        case GoalType.consecutiveDays:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.category.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: _showResetDialog,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'إعادة تعيين',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.pushNamed(context, '/settings');
                  break;
                case 'statistics':
                  Navigator.pushNamed(context, '/statistics');
                  break;
                case 'goals':
                  Navigator.pushNamed(context, '/goals');
                  break;
                case 'custom':
                  Navigator.pushNamed(context, '/custom-dhikr');
                  break;
                case 'advanced':
                  Navigator.pushNamed(context, '/advanced');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('الإعدادات'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'statistics',
                  child: Row(
                    children: [
                      Icon(Icons.analytics),
                      SizedBox(width: 8),
                      Text('الإحصائيات'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'goals',
                  child: Row(
                    children: [
                      Icon(Icons.track_changes),
                      SizedBox(width: 8),
                      Text('الأهداف'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'custom',
                  child: Row(
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(width: 8),
                      Text('ذكر مخصص'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'advanced',
                  child: Row(
                    children: [
                      Icon(Icons.extension),
                      SizedBox(width: 8),
                      Text('الميزات المتقدمة'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.5708, // Downward
              emissionFrequency: 0.3,
              numberOfParticles: 20,
              maxBlastForce: 100,
              minBlastForce: 80,
              gravity: 0.3,
            ),
          ),

          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Category progress bar
                  _buildCategoryProgressCard(),

                  const SizedBox(height: 20),

                  // Current dhikr card
                  _buildCurrentDhikrCard(),

                  const SizedBox(height: 30),

                  // Navigation controls
                  _buildNavigationControls(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCategoryProgressCard() {
    final completedDhikrs = _currentDhikrIndex + (_count >= _currentDhikr.targetCount ? 1 : 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تقدم الفئة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$completedDhikrs / ${widget.category.dhikrs.length}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _categoryProgress,
            backgroundColor: Theme.of(context).cardColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              _categoryProgress >= 1.0 ? Colors.green : Theme.of(context).primaryColor,
            ),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${(_categoryProgress * 100).toInt()}% مكتمل',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentDhikrCard() {
    return AnimatedBuilder(
      animation: _celebrationAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_celebrationAnimation.value * 0.1),
          child: GestureDetector(
            onTap: _incrementCounter,
            child: AnimatedBuilder(
              animation: _countAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _countAnimation.value,
                  child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              border: _count >= _currentDhikr.targetCount
                  ? Border.all(color: Colors.green, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: _count >= _currentDhikr.targetCount
                      ? Colors.green.withValues(alpha: 0.3)
                      : Theme.of(context).shadowColor.withValues(alpha: 0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentDhikrIndex + 1} من ${widget.category.dhikrs.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (_count >= _currentDhikr.targetCount)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'مكتمل',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _currentDhikr.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _currentDhikr.arabicText,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                if (_currentDhikr.meaning != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _currentDhikr.meaning!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'التقدم: $_count / ${_currentDhikr.targetCount}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${((_count / _currentDhikr.targetCount) * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _count / _currentDhikr.targetCount,
                  backgroundColor: Theme.of(context).cardColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _count >= _currentDhikr.targetCount
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                  ),
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _count >= _currentDhikr.targetCount ? 'مكتمل ✓' : 'انقر على البطاقة للعد',
                    style: TextStyle(
                      fontSize: 12,
                      color: _count >= _currentDhikr.targetCount
                        ? Colors.green
                        : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  Widget _buildNavigationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_currentDhikrIndex > 0)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _currentDhikrIndex--;
                _count = 0;
              });
              ref.read(sessionProvider.notifier).startSession(_convertToNewDhikr(_currentDhikr));
              _saveCount();
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('السابق'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).disabledColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

        ElevatedButton.icon(
          onPressed: _selectNewCategory,
          icon: const Icon(Icons.list),
          label: const Text('تغيير الفئة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            foregroundColor: Theme.of(context).primaryColor,
            side: BorderSide(color: Theme.of(context).primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        if (_currentDhikrIndex < widget.category.dhikrs.length - 1)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _currentDhikrIndex++;
                _count = 0;
              });
              ref.read(sessionProvider.notifier).startSession(_convertToNewDhikr(_currentDhikr));
              _saveCount();
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('التالي'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
      ],
    );
  }
}