import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr.dart';
import '../models/analytics.dart';

class BackupData {
  final Map<String, dynamic> settings;
  final List<Map<String, dynamic>> customDhikrs;
  final List<Map<String, dynamic>> sessions;
  final List<Map<String, dynamic>> goals;
  final List<Map<String, dynamic>> achievements;
  final Map<String, dynamic> personalization;
  final DateTime createdAt;
  final String version;

  const BackupData({
    required this.settings,
    required this.customDhikrs,
    required this.sessions,
    required this.goals,
    required this.achievements,
    required this.personalization,
    required this.createdAt,
    required this.version,
  });

  Map<String, dynamic> toJson() {
    return {
      'settings': settings,
      'customDhikrs': customDhikrs,
      'sessions': sessions,
      'goals': goals,
      'achievements': achievements,
      'personalization': personalization,
      'createdAt': createdAt.toIso8601String(),
      'version': version,
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      settings: json['settings'] ?? {},
      customDhikrs: List<Map<String, dynamic>>.from(json['customDhikrs'] ?? []),
      sessions: List<Map<String, dynamic>>.from(json['sessions'] ?? []),
      goals: List<Map<String, dynamic>>.from(json['goals'] ?? []),
      achievements: List<Map<String, dynamic>>.from(json['achievements'] ?? []),
      personalization: json['personalization'] ?? {},
      createdAt: DateTime.parse(json['createdAt']),
      version: json['version'] ?? '1.0.0',
    );
  }
}

class BackupService {
  static const String _currentVersion = '1.0.0';

  static Future<BackupData> createBackup() async {
    final prefs = await SharedPreferences.getInstance();

    // Collect all app data
    final settings = <String, dynamic>{};
    final keys = prefs.getKeys();

    for (final key in keys) {
      final value = prefs.get(key);
      if (value != null) {
        settings[key] = value;
      }
    }

    return BackupData(
      settings: settings,
      customDhikrs: _extractDataList(settings, 'custom_dhikrs'),
      sessions: _extractDataList(settings, 'sessions_history'),
      goals: _extractDataList(settings, 'personal_goals'),
      achievements: _extractDataList(settings, 'achievements'),
      personalization: _extractData(settings, 'personalization_settings'),
      createdAt: DateTime.now(),
      version: _currentVersion,
    );
  }

  static List<Map<String, dynamic>> _extractDataList(Map<String, dynamic> settings, String key) {
    try {
      final jsonString = settings[key] as String?;
      if (jsonString != null) {
        final decoded = json.decode(jsonString);
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return [];
  }

  static Map<String, dynamic> _extractData(Map<String, dynamic> settings, String key) {
    try {
      final jsonString = settings[key] as String?;
      if (jsonString != null) {
        final decoded = json.decode(jsonString);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return {};
  }

  static Future<String> exportBackup(BackupData backup) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'sebha_backup_$timestamp.json';
    final file = File('${directory.path}/$fileName');

    final backupJson = json.encode(backup.toJson());
    await file.writeAsString(backupJson);

    return file.path;
  }

  static Future<BackupData> importBackup(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('Backup file not found');
    }

    final backupJson = await file.readAsString();
    final backupMap = json.decode(backupJson) as Map<String, dynamic>;

    return BackupData.fromJson(backupMap);
  }

  static Future<void> restoreBackup(BackupData backup) async {
    final prefs = await SharedPreferences.getInstance();

    // Clear existing data (optional - can be made configurable)
    await prefs.clear();

    // Restore all settings
    for (final entry in backup.settings.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      }
    }
  }

  static Future<List<BackupInfo>> getAvailableBackups() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((entity) => entity is File && entity.path.contains('sebha_backup_'))
          .cast<File>()
          .toList();

      final backups = <BackupInfo>[];

      for (final file in files) {
        try {
          final stats = await file.stat();
          final fileName = file.path.split('/').last;

          // Try to extract timestamp from filename
          final timestampMatch = RegExp(r'sebha_backup_(\d+)\.json').firstMatch(fileName);
          DateTime? createdAt;

          if (timestampMatch != null) {
            final timestamp = int.parse(timestampMatch.group(1)!);
            createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
          }

          backups.add(BackupInfo(
            fileName: fileName,
            filePath: file.path,
            size: stats.size,
            createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(stats.modified.millisecondsSinceEpoch),
          ));
        } catch (e) {
          // Skip invalid backup files
        }
      }

      // Sort by creation date (newest first)
      backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return backups;
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteBackup(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

class BackupInfo {
  final String fileName;
  final String filePath;
  final int size;
  final DateTime createdAt;

  const BackupInfo({
    required this.fileName,
    required this.filePath,
    required this.size,
    required this.createdAt,
  });

  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

class BackupNotifier extends StateNotifier<AsyncValue<List<BackupInfo>>> {
  BackupNotifier() : super(const AsyncValue.loading()) {
    loadAvailableBackups();
  }

  Future<void> loadAvailableBackups() async {
    try {
      state = const AsyncValue.loading();
      final backups = await BackupService.getAvailableBackups();
      state = AsyncValue.data(backups);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<String> createBackup() async {
    try {
      final backup = await BackupService.createBackup();
      final filePath = await BackupService.exportBackup(backup);

      // Refresh the list
      await loadAvailableBackups();

      return filePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> restoreBackup(String filePath) async {
    try {
      final backup = await BackupService.importBackup(filePath);
      await BackupService.restoreBackup(backup);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBackup(String filePath) async {
    try {
      await BackupService.deleteBackup(filePath);
      await loadAvailableBackups();
    } catch (e) {
      rethrow;
    }
  }
}

final backupProvider = StateNotifierProvider<BackupNotifier, AsyncValue<List<BackupInfo>>>((ref) {
  return BackupNotifier();
});

// Cloud sync placeholder (for future implementation)
class CloudSyncService {
  static bool get isAvailable => false; // Would check for network/auth

  static Future<void> uploadBackup(BackupData backup) async {
    // Implementation would depend on chosen cloud provider
    // (Firebase, Google Drive, iCloud, etc.)
    throw UnimplementedError('Cloud sync not yet implemented');
  }

  static Future<List<BackupData>> getCloudBackups() async {
    throw UnimplementedError('Cloud sync not yet implemented');
  }

  static Future<void> downloadBackup(String cloudBackupId) async {
    throw UnimplementedError('Cloud sync not yet implemented');
  }
}

final cloudSyncProvider = Provider<CloudSyncService>((ref) {
  return CloudSyncService();
});