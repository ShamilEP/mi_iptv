import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/mi_list_row.dart';
import '../../../../core/widgets/ui_state.dart';
import 'tv_settings_copy.dart';
import 'tv_settings_models.dart';

/// Category rail for hierarchical Settings (TV-080).
///
/// Each row shows the category label and a summary of the current value.
class TvSettingsCategoryList extends StatelessWidget {
  const TvSettingsCategoryList({
    super.key,
    required this.selected,
    required this.snapshot,
    required this.onSelected,
  });

  final TvSettingsCategory selected;
  final TvSettingsSnapshot snapshot;
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
            subtitle: snapshot.summaryFor(category),
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
      case TvSettingsCategory.account:
        return TvSettingsCopy.account;
      case TvSettingsCategory.sources:
        return TvSettingsCopy.sources;
      case TvSettingsCategory.network:
        return TvSettingsCopy.network;
      case TvSettingsCategory.language:
        return TvSettingsCopy.language;
      case TvSettingsCategory.playback:
        return TvSettingsCopy.playback;
    }
  }

  IconRole _role(TvSettingsCategory category) {
    switch (category) {
      case TvSettingsCategory.account:
        return IconRole.devices;
      case TvSettingsCategory.sources:
        return IconRole.sources;
      case TvSettingsCategory.network:
        return IconRole.connected;
      case TvSettingsCategory.language:
        return IconRole.info;
      case TvSettingsCategory.playback:
        return IconRole.play;
    }
  }
}

/// Read-only current values for a settings category.
class TvSettingsValuesPanel extends StatelessWidget {
  const TvSettingsValuesPanel({
    super.key,
    required this.categoryLabel,
    required this.values,
  });

  final String categoryLabel;
  final List<TvSettingsValue> values;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryLabel,
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          TvSettingsCopy.currentValues,
          style: textTheme.bodyLarge?.copyWith(color: brand.mist),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final item in values) ...[
          MiListRow(
            key: ValueKey<String>('settings-value-${item.label}'),
            title: item.label,
            subtitle: item.value,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}
