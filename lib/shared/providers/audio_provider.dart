import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/dhikr.dart';
import 'settings_provider.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await _player.setReleaseMode(ReleaseMode.stop);
      _isInitialized = true;
    }
  }

  static Future<void> playDhikrAudio(String dhikrId) async {
    await initialize();

    try {
      // Try to play audio file for this dhikr
      final audioPath = 'audio/dhikr/$dhikrId.mp3';
      await _player.play(AssetSource(audioPath));
    } catch (e) {
      // If audio file doesn't exist, provide user feedback
      print('Audio file not found for dhikr: $dhikrId. Add audio files to assets/audio/dhikr/');
      // Could implement text-to-speech fallback here
    }
  }

  static Future<void> playNotificationSound() async {
    await initialize();

    try {
      await _player.play(AssetSource('audio/notification.mp3'));
    } catch (e) {
      // Fallback: no sound
    }
  }

  static Future<void> playCompletionSound() async {
    await initialize();

    try {
      await _player.play(AssetSource('audio/completion.mp3'));
    } catch (e) {
      // Fallback: no sound
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }

  static Future<void> dispose() async {
    await _player.dispose();
  }
}

class AudioNotifier extends StateNotifier<bool> {
  AudioNotifier() : super(false);

  Future<void> playDhikrAudio(String dhikrId, bool soundEnabled) async {
    if (!soundEnabled) return;

    state = true;
    try {
      await AudioService.playDhikrAudio(dhikrId);
    } finally {
      state = false;
    }
  }

  Future<void> playCompletionSound(bool soundEnabled) async {
    if (!soundEnabled) return;

    state = true;
    try {
      await AudioService.playCompletionSound();
    } finally {
      state = false;
    }
  }

  Future<void> playNotificationSound(bool soundEnabled) async {
    if (!soundEnabled) return;

    state = true;
    try {
      await AudioService.playNotificationSound();
    } finally {
      state = false;
    }
  }

  Future<void> stopAudio() async {
    await AudioService.stop();
    state = false;
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, bool>((ref) {
  return AudioNotifier();
});

// Convenience provider that combines audio state with settings
final audioControlProvider = Provider<AudioController>((ref) {
  final audioNotifier = ref.read(audioProvider.notifier);
  final settings = ref.watch(settingsProvider);
  final isPlaying = ref.watch(audioProvider);

  return AudioController(
    audioNotifier: audioNotifier,
    soundEnabled: settings.soundEnabled,
    isPlaying: isPlaying,
  );
});

class AudioController {
  final AudioNotifier audioNotifier;
  final bool soundEnabled;
  final bool isPlaying;

  const AudioController({
    required this.audioNotifier,
    required this.soundEnabled,
    required this.isPlaying,
  });

  Future<void> playDhikrAudio(String dhikrId) async {
    await audioNotifier.playDhikrAudio(dhikrId, soundEnabled);
  }

  Future<void> playCompletionSound() async {
    await audioNotifier.playCompletionSound(soundEnabled);
  }

  Future<void> playNotificationSound() async {
    await audioNotifier.playNotificationSound(soundEnabled);
  }

  Future<void> stopAudio() async {
    await audioNotifier.stopAudio();
  }
}