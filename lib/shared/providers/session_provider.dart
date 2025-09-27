import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr.dart';

class SessionNotifier extends StateNotifier<DhikrSession?> {
  SessionNotifier() : super(null);

  static const String _currentSessionKey = 'current_session';
  static const String _sessionsHistoryKey = 'sessions_history';

  Future<void> startSession(Dhikr dhikr) async {
    final session = DhikrSession.create(
      dhikrId: dhikr.id,
      targetCount: dhikr.targetCount,
    );

    state = session;
    await _saveCurrentSession();
  }

  Future<void> incrementCount() async {
    if (state == null) return;

    state = state!.increment();
    await _saveCurrentSession();

    // If session is completed, save to history
    if (state!.isCompleted) {
      await _saveToHistory(state!);
    }
  }

  Future<void> resetSession() async {
    if (state == null) return;

    final newSession = DhikrSession.create(
      dhikrId: state!.dhikrId,
      targetCount: state!.targetCount,
    );

    state = newSession;
    await _saveCurrentSession();
  }

  Future<void> endSession() async {
    if (state == null) return;

    // Save incomplete session to history if it has progress
    if (state!.currentCount > 0) {
      await _saveToHistory(state!);
    }

    state = null;
    await _clearCurrentSession();
  }

  Future<void> loadCurrentSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_currentSessionKey);

      if (sessionJson != null) {
        final sessionMap = json.decode(sessionJson) as Map<String, dynamic>;
        state = DhikrSession.fromJson(sessionMap);
      }
    } catch (e) {
      state = null;
    }
  }

  Future<void> _saveCurrentSession() async {
    if (state == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = json.encode(state!.toJson());
      await prefs.setString(_currentSessionKey, sessionJson);
    } catch (e) {
      // Handle save error gracefully
    }
  }

  Future<void> _clearCurrentSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentSessionKey);
    } catch (e) {
      // Handle error gracefully
    }
  }

  Future<void> _saveToHistory(DhikrSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_sessionsHistoryKey) ?? '[]';
      final history = json.decode(historyJson) as List<dynamic>;

      // Add current session to history
      history.add(session.toJson());

      // Keep only last 100 sessions
      if (history.length > 100) {
        history.removeRange(0, history.length - 100);
      }

      final updatedHistoryJson = json.encode(history);
      await prefs.setString(_sessionsHistoryKey, updatedHistoryJson);
    } catch (e) {
      // Handle error gracefully
    }
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, DhikrSession?>((ref) {
  final notifier = SessionNotifier();
  notifier.loadCurrentSession();
  return notifier;
});

// Provider for session history
final sessionHistoryProvider = FutureProvider<List<DhikrSession>>((ref) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('sessions_history') ?? '[]';
    final history = json.decode(historyJson) as List<dynamic>;

    return history
        .map((json) => DhikrSession.fromJson(json as Map<String, dynamic>))
        .toList()
        .reversed
        .toList(); // Most recent first
  } catch (e) {
    return [];
  }
});