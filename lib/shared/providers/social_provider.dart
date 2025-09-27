import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/analytics.dart';
import '../models/dhikr.dart';

class SocialService {
  static Future<void> shareProgress({
    required int totalCount,
    required int sessionsToday,
    required int currentStreak,
    String? customMessage,
  }) async {
    final message = customMessage ?? _generateProgressMessage(
      totalCount: totalCount,
      sessionsToday: sessionsToday,
      currentStreak: currentStreak,
    );

    await Share.share(
      message,
      subject: 'My Dhikr Progress',
    );
  }

  static Future<void> shareAchievement(Achievement achievement) async {
    final message = _generateAchievementMessage(achievement);

    await Share.share(
      message,
      subject: 'Achievement Unlocked!',
    );
  }

  static Future<void> shareWeeklyProgress(WeeklyAnalytics analytics) async {
    final message = _generateWeeklyMessage(analytics);

    await Share.share(
      message,
      subject: 'My Weekly Dhikr Progress',
    );
  }

  static Future<void> shareDhikr(Dhikr dhikr) async {
    final message = _generateDhikrMessage(dhikr);

    await Share.share(
      message,
      subject: 'Beautiful Dhikr',
    );
  }

  static Future<void> shareAsImage({
    required String title,
    required String content,
    required List<String> stats,
  }) async {
    try {
      // Generate a simple text-based image content
      final imageContent = _generateImageContent(title, content, stats);

      // For now, share as text - in production, you'd generate an actual image
      await Share.share(
        imageContent,
        subject: title,
      );
    } catch (e) {
      // Fallback to text sharing
      await Share.share('$title\n\n$content');
    }
  }

  static Future<void> exportProgress({
    required List<DhikrSession> sessions,
    required List<Achievement> achievements,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/dhikr_progress_${DateTime.now().millisecondsSinceEpoch}.json');

      final exportData = {
        'exportDate': DateTime.now().toIso8601String(),
        'sessions': sessions.map((s) => s.toJson()).toList(),
        'achievements': achievements.map((a) => a.toJson()).toList(),
        'summary': {
          'totalSessions': sessions.length,
          'totalCount': sessions.fold<int>(0, (sum, s) => sum + s.currentCount),
          'unlockedAchievements': achievements.where((a) => a.isUnlocked).length,
        },
      };

      await file.writeAsString(json.encode(exportData));

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Dhikr Progress Export',
        text: 'Here\'s my dhikr progress data export',
      );
    } catch (e) {
      // Handle error gracefully
      rethrow;
    }
  }

  static Future<void> openSocialMedia(String platform, String message) async {
    String url = '';

    switch (platform.toLowerCase()) {
      case 'twitter':
        url = 'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}';
        break;
      case 'facebook':
        url = 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(message)}';
        break;
      case 'whatsapp':
        url = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
        break;
      case 'telegram':
        url = 'https://t.me/share/url?url=${Uri.encodeComponent(message)}';
        break;
    }

    if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  static String _generateProgressMessage({
    required int totalCount,
    required int sessionsToday,
    required int currentStreak,
  }) {
    final streakText = currentStreak > 1 ? ' 🔥 $currentStreak-day streak!' : '';

    return '''🕌 My Dhikr Progress 🕌

✨ Total recitations: $totalCount
📅 Sessions today: $sessionsToday$streakText

Keep me in your du'as! 🤲

#Dhikr #IslamicApp #Remembrance #Tasbih''';
  }

  static String _generateAchievementMessage(Achievement achievement) {
    final categoryEmoji = _getCategoryEmoji(achievement.category);

    return '''🏆 Achievement Unlocked! 🏆

$categoryEmoji ${achievement.title}
${achievement.description}

Alhamdulillah for this blessing! 🤲

#Achievement #Dhikr #IslamicProgress #Tasbih''';
  }

  static String _generateWeeklyMessage(WeeklyAnalytics analytics) {
    final activeDays = analytics.dailyData.where((day) => day.sessionsCount > 0).length;

    return '''📊 My Weekly Dhikr Report 📊

🗓️ Active days: $activeDays/7
📿 Total sessions: ${analytics.totalSessions}
🔢 Total count: ${analytics.totalCount}
⏱️ Time spent: ${_formatDuration(analytics.totalTime)}

May Allah accept our efforts! 🤲

#WeeklyProgress #Dhikr #IslamicLife''';
  }

  static String _generateDhikrMessage(Dhikr dhikr) {
    return '''🕌 Beautiful Dhikr to Share 🕌

"${dhikr.arabicText}"

${dhikr.transliteration ?? ''}
${dhikr.meaningKey ?? ''}

May Allah grant us consistency in remembrance 🤲

#Dhikr #IslamicReminder #Tasbih''';
  }

  static String _generateImageContent(String title, String content, List<String> stats) {
    return '''
╔══════════════════════════════════╗
║            $title            ║
╠══════════════════════════════════╣
║                                  ║
║  $content                        ║
║                                  ║
${stats.map((stat) => '║  $stat').join('\n')}
║                                  ║
║  Generated by Digital Tasbih     ║
╚══════════════════════════════════╝
''';
  }

  static String _getCategoryEmoji(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.consistency:
        return '🔄';
      case AchievementCategory.volume:
        return '📊';
      case AchievementCategory.variety:
        return '🌈';
      case AchievementCategory.streak:
        return '🔥';
      case AchievementCategory.milestone:
        return '🎯';
    }
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class SocialNotifier extends StateNotifier<bool> {
  SocialNotifier() : super(false);

  Future<void> shareProgress({
    required int totalCount,
    required int sessionsToday,
    required int currentStreak,
    String? customMessage,
  }) async {
    state = true;
    try {
      await SocialService.shareProgress(
        totalCount: totalCount,
        sessionsToday: sessionsToday,
        currentStreak: currentStreak,
        customMessage: customMessage,
      );
    } finally {
      state = false;
    }
  }

  Future<void> shareAchievement(Achievement achievement) async {
    state = true;
    try {
      await SocialService.shareAchievement(achievement);
    } finally {
      state = false;
    }
  }

  Future<void> shareWeeklyProgress(WeeklyAnalytics analytics) async {
    state = true;
    try {
      await SocialService.shareWeeklyProgress(analytics);
    } finally {
      state = false;
    }
  }

  Future<void> shareDhikr(Dhikr dhikr) async {
    state = true;
    try {
      await SocialService.shareDhikr(dhikr);
    } finally {
      state = false;
    }
  }

  Future<void> exportProgress({
    required List<DhikrSession> sessions,
    required List<Achievement> achievements,
  }) async {
    state = true;
    try {
      await SocialService.exportProgress(
        sessions: sessions,
        achievements: achievements,
      );
    } finally {
      state = false;
    }
  }
}

final socialProvider = StateNotifierProvider<SocialNotifier, bool>((ref) {
  return SocialNotifier();
});

// Convenience provider for social sharing
final socialControllerProvider = Provider<SocialController>((ref) {
  final notifier = ref.read(socialProvider.notifier);
  final isSharing = ref.watch(socialProvider);

  return SocialController(
    notifier: notifier,
    isSharing: isSharing,
  );
});

class SocialController {
  final SocialNotifier notifier;
  final bool isSharing;

  const SocialController({
    required this.notifier,
    required this.isSharing,
  });

  Future<void> shareProgress({
    required int totalCount,
    required int sessionsToday,
    required int currentStreak,
    String? customMessage,
  }) async {
    await notifier.shareProgress(
      totalCount: totalCount,
      sessionsToday: sessionsToday,
      currentStreak: currentStreak,
      customMessage: customMessage,
    );
  }

  Future<void> shareAchievement(Achievement achievement) async {
    await notifier.shareAchievement(achievement);
  }

  Future<void> shareWeeklyProgress(WeeklyAnalytics analytics) async {
    await notifier.shareWeeklyProgress(analytics);
  }

  Future<void> shareDhikr(Dhikr dhikr) async {
    await notifier.shareDhikr(dhikr);
  }

  Future<void> exportProgress({
    required List<DhikrSession> sessions,
    required List<Achievement> achievements,
  }) async {
    await notifier.exportProgress(
      sessions: sessions,
      achievements: achievements,
    );
  }
}