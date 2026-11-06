import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';

/// Home header destinations (DSN-032). Live TV stays in this rail — never
/// displaced by a hero.
enum TvHomeQuickDestination {
  liveTv,
  favorites,
  search,
  settings,
}

extension TvHomeQuickDestinationX on TvHomeQuickDestination {
  IconRole get iconRole {
    switch (this) {
      case TvHomeQuickDestination.liveTv:
        return IconRole.liveTv;
      case TvHomeQuickDestination.favorites:
        return IconRole.favorites;
      case TvHomeQuickDestination.search:
        return IconRole.search;
      case TvHomeQuickDestination.settings:
        return IconRole.settings;
    }
  }

  String get label => Iconography.of(iconRole).label;
}

/// Compact quick-access actions for Live TV, Favorites, Search, Settings.
class TvHomeQuickAccess extends StatelessWidget {
  const TvHomeQuickAccess({
    super.key,
    this.onSelected,
    this.liveTvFocusNode,
  });

  final ValueChanged<TvHomeQuickDestination>? onSelected;

  /// Optional node so tests / focus policy can land on Live TV without a hero.
  final FocusNode? liveTvFocusNode;

  static const List<TvHomeQuickDestination> destinations =
      TvHomeQuickDestination.values;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        for (final destination in destinations)
          MiButton(
            key: ValueKey<String>('home-quick-${destination.name}'),
            label: destination.label,
            emphasis: destination == TvHomeQuickDestination.liveTv
                ? ControlEmphasis.primary
                : ControlEmphasis.secondary,
            focusNode: destination == TvHomeQuickDestination.liveTv
                ? liveTvFocusNode
                : null,
            onPressed: () => onSelected?.call(destination),
          ),
      ],
    );
  }
}
