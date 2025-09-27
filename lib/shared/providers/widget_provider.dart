import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'session_provider.dart';

class WidgetNotifier extends StateNotifier<bool> {
  WidgetNotifier() : super(false) {
    _initializeWidget();
  }

  Future<void> _initializeWidget() async {
    try {
      await HomeWidget.registerInteractivityCallback(backgroundCallback);
      state = true;
    } catch (e) {
      state = false;
    }
  }

  Future<void> updateWidget({
    required int currentCount,
    required String dhikrName,
    required int targetCount,
    bool targetReached = false,
  }) async {
    try {
      await HomeWidget.saveWidgetData<int>('current_count', currentCount);
      await HomeWidget.saveWidgetData<String>('dhikr_name', dhikrName);
      await HomeWidget.saveWidgetData<int>('target_count', targetCount);
      await HomeWidget.saveWidgetData<bool>('target_reached', targetReached);
      await HomeWidget.updateWidget(
        androidName: 'TasbihWidgetProvider',
        iOSName: 'TasbihWidget',
      );
    } catch (e) {
      // Handle widget update error
    }
  }

  Future<void> incrementCountFromWidget() async {
    try {
      // This will be called from the widget background callback
      final currentCount = await HomeWidget.getWidgetData<int>('current_count') ?? 0;
      final targetCount = await HomeWidget.getWidgetData<int>('target_count') ?? 33;
      final newCount = currentCount + 1;
      final targetReached = newCount >= targetCount;

      await updateWidget(
        currentCount: newCount,
        dhikrName: await HomeWidget.getWidgetData<String>('dhikr_name') ?? 'سبحان الله',
        targetCount: targetCount,
        targetReached: targetReached,
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> resetCountFromWidget() async {
    try {
      // Reset the counter from widget
      final targetCount = await HomeWidget.getWidgetData<int>('target_count') ?? 33;

      await updateWidget(
        currentCount: 0,
        dhikrName: await HomeWidget.getWidgetData<String>('dhikr_name') ?? 'سبحان الله',
        targetCount: targetCount,
        targetReached: false,
      );
    } catch (e) {
      // Handle error
    }
  }
}

// Background callback for widget interactions
@pragma("vm:entry-point")
void backgroundCallback(Uri? uri) {
  final container = ProviderContainer();
  final notifier = container.read(widgetProvider.notifier);

  if (uri?.host == 'increment') {
    notifier.incrementCountFromWidget();
  } else if (uri?.host == 'reset') {
    notifier.resetCountFromWidget();
  }

  container.dispose();
}

final widgetProvider = StateNotifierProvider<WidgetNotifier, bool>((ref) {
  return WidgetNotifier();
});

// Provider to sync widget with session data
final widgetSyncProvider = Provider<void>((ref) {
  final session = ref.watch(sessionProvider);
  final widgetNotifier = ref.watch(widgetProvider.notifier);

  if (session != null) {
    widgetNotifier.updateWidget(
      currentCount: session.currentCount,
      dhikrName: session.dhikrId, // We'll need to resolve the actual name later
      targetCount: session.targetCount,
      targetReached: session.isCompleted,
    );
  }
});