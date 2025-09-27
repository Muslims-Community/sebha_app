import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quick_notification_provider.dart';
import '../../l10n/generated/app_localizations.dart';

class QuickSettingsPanel extends ConsumerWidget {
  const QuickSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final quickNotificationNotifier = ref.watch(quickNotificationProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            l10n.quickSettings,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 20),

          // Quick Counter Toggle
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.quickCounter,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: quickNotificationNotifier.isActive,
                        onChanged: (value) async {
                          if (value) {
                            await quickNotificationNotifier.showQuickCounterNotification();
                          } else {
                            await quickNotificationNotifier.hideQuickCounterNotification();
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.quickCounterDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions Row
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // Quick reset action
                    Navigator.pop(context, 'reset');
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.reset),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    // Quick dhikr selector
                    Navigator.pop(context, 'select_dhikr');
                  },
                  icon: const Icon(Icons.tune),
                  label: Text(l10n.selectDhikr),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}