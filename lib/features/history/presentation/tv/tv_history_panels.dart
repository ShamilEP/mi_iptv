import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_icon.dart';
import '../../../../core/widgets/mi_list_row.dart';
import '../../../../core/widgets/mi_toggle.dart';
import '../../../../core/widgets/status_pattern.dart';
import '../../../../core/widgets/status_pattern_copy.dart';
import 'tv_history_models.dart';

/// Privacy controls for History — save toggle + clear (DSN-063).
class TvHistoryPrivacyPanel extends StatelessWidget {
  const TvHistoryPrivacyPanel({
    super.key,
    required this.saveHistory,
    required this.onSaveHistoryChanged,
    required this.onClearHistory,
    this.canClear = true,
  });

  final bool saveHistory;
  final ValueChanged<bool> onSaveHistoryChanged;
  final VoidCallback onClearHistory;
  final bool canClear;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TvHistoryCopy.privacySection,
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.sm),
        MiToggle(
          key: const ValueKey<String>('history-save-toggle'),
          value: saveHistory,
          label: TvHistoryCopy.saveHistoryLabel,
          onChanged: onSaveHistoryChanged,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          TvHistoryCopy.saveHistoryHint,
          style: textTheme.bodyMedium?.copyWith(color: brand.mist),
        ),
        const SizedBox(height: AppSpacing.md),
        MiButton(
          key: const ValueKey<String>('history-clear'),
          label: TvHistoryCopy.clearLabel,
          emphasis: ControlEmphasis.secondary,
          onPressed: canClear ? onClearHistory : null,
        ),
      ],
    );
  }
}

/// Chronological History list with Open / Remove actions (DSN-063).
class TvHistoryCatalog extends StatelessWidget {
  const TvHistoryCatalog({
    super.key,
    required this.items,
    this.onOpen,
    this.onRemove,
    this.onBrowseCatalog,
  });

  final List<TvHistoryItem> items;
  final ValueChanged<TvHistoryItem>? onOpen;
  final ValueChanged<TvHistoryItem>? onRemove;
  final VoidCallback? onBrowseCatalog;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyPattern(
        copy: const StatusPatternCopy(
          title: TvHistoryCopy.emptyTitle,
          message: TvHistoryCopy.emptyMessage,
          actionLabel: TvHistoryCopy.emptyAction,
        ),
        onAction: onBrowseCatalog,
        icon: Icons.history,
      );
    }

    final brand = context.brandColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items) ...[
          MiListRow(
            key: ValueKey<String>('history-${item.id}'),
            title: item.title,
            subtitle: [
              if (item.subtitle.isNotEmpty) item.subtitle,
              item.watchedLabel,
            ].join(' · '),
            leading: MiIcon(
              role: IconRole.continueWatching,
              color: brand.cloud,
              size: AppSpacing.lg,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MiButton(
                  label: TvHistoryCopy.openLabel,
                  onPressed: onOpen == null ? null : () => onOpen!(item),
                ),
                const SizedBox(width: AppSpacing.xs),
                MiButton(
                  label: TvHistoryCopy.removeLabel,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: onRemove == null ? null : () => onRemove!(item),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}
