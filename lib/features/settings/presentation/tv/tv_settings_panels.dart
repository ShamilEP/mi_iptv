import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_list_row.dart';
import '../../../../core/widgets/ui_state.dart';
import 'tv_settings_copy.dart';
import 'tv_settings_models.dart';

/// Category rail for hierarchical Settings (DSN-038).
class TvSettingsCategoryList extends StatelessWidget {
  const TvSettingsCategoryList({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final TvSettingsCategory selected;
  final ValueChanged<TvSettingsCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return Column(
      children: [
        for (final category in TvSettingsCategory.values) ...[
          MiListRow(
            key: ValueKey<String>('settings-cat-${category.name}'),
            title: _label(category),
            leading: Icon(
              Iconography.of(_role(category)).icon,
              color: brand.cloud,
              size: AppSpacing.lg,
              semanticLabel: _label(category),
            ),
            state: category == selected ? UiState.selected : UiState.defaults,
            onPressed: () => onSelected(category),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }

  String _label(TvSettingsCategory category) {
    switch (category) {
      case TvSettingsCategory.playback:
        return TvSettingsCopy.playback;
      case TvSettingsCategory.account:
        return TvSettingsCopy.account;
      case TvSettingsCategory.sources:
        return TvSettingsCopy.sources;
      case TvSettingsCategory.diagnostics:
        return TvSettingsCopy.diagnostics;
    }
  }

  IconRole _role(TvSettingsCategory category) {
    switch (category) {
      case TvSettingsCategory.playback:
        return IconRole.play;
      case TvSettingsCategory.account:
        return IconRole.devices;
      case TvSettingsCategory.sources:
        return IconRole.sources;
      case TvSettingsCategory.diagnostics:
        return IconRole.settings;
    }
  }
}

/// Read-only current values for a settings category.
class TvSettingsValuesPanel extends StatelessWidget {
  const TvSettingsValuesPanel({super.key, required this.values});

  final List<TvSettingsValue> values;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TvSettingsCopy.currentValues,
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final item in values) ...[
          MiListRow(title: item.label, subtitle: item.value),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

/// Sources list with priority reordering.
class TvSettingsSourcesPanel extends StatelessWidget {
  const TvSettingsSourcesPanel({
    super.key,
    required this.sources,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  final List<TvSettingsSource> sources;
  final ValueChanged<int> onMoveUp;
  final ValueChanged<int> onMoveDown;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final ordered = [...sources]
      ..sort((a, b) => a.priority.compareTo(b.priority));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TvSettingsCopy.sources,
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          TvSettingsCopy.priorityHint,
          style: textTheme.bodyLarge?.copyWith(color: brand.mist),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < ordered.length; i++) ...[
          MiListRow(
            key: ValueKey<String>('settings-source-${ordered[i].id}'),
            title: ordered[i].name,
            subtitle: '${ordered[i].kind} · priority ${ordered[i].priority}',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MiButton(
                  label: TvSettingsCopy.moveUp,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: i == 0 ? null : () => onMoveUp(i),
                ),
                const SizedBox(width: AppSpacing.xs),
                MiButton(
                  label: TvSettingsCopy.moveDown,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: i == ordered.length - 1
                      ? null
                      : () => onMoveDown(i),
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

/// Diagnostics metrics panel.
class TvSettingsDiagnosticsPanel extends StatelessWidget {
  const TvSettingsDiagnosticsPanel({super.key, required this.diagnostics});

  final TvSettingsDiagnostics diagnostics;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TvSettingsCopy.diagnostics,
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.md),
        MiListRow(title: TvSettingsCopy.network, subtitle: diagnostics.network),
        const SizedBox(height: AppSpacing.xs),
        MiListRow(
          title: TvSettingsCopy.activeSource,
          subtitle: diagnostics.source,
        ),
        const SizedBox(height: AppSpacing.xs),
        MiListRow(title: TvSettingsCopy.latency, subtitle: diagnostics.latency),
        const SizedBox(height: AppSpacing.xs),
        MiListRow(title: TvSettingsCopy.buffer, subtitle: diagnostics.buffer),
        const SizedBox(height: AppSpacing.xs),
        MiListRow(title: TvSettingsCopy.version, subtitle: diagnostics.version),
      ],
    );
  }
}
