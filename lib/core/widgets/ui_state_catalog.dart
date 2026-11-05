import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/focus_styles.dart';
import 'ui_state.dart';

/// Non-color cue that must accompany a [UiState] (DSN-010 / DSN-002).
@immutable
class UiStateCue {
  const UiStateCue(this.description);

  final String description;
}

/// Canonical definition of one mandatory UI state.
@immutable
class UiStateDefinition {
  const UiStateDefinition({
    required this.state,
    required this.label,
    required this.nonColorCues,
    this.accent,
  });

  final UiState state;

  /// Product / SRS label (e.g. `Default`, `Sync Conflict`).
  final String label;

  /// Optional brand accent — never the sole signal.
  final Color? accent;

  /// Required non-color cues (icon, label, scale, pattern, etc.).
  final List<UiStateCue> nonColorCues;
}

/// Locked catalog of the 12 mandatory component states (DSN-010).
abstract final class UiStateCatalog {
  /// SRS / Frontend order — must stay length 12 and match [UiState.values].
  static const List<String> mandatoryLabels = <String>[
    'Default',
    'Focused',
    'Pressed',
    'Disabled',
    'Loading',
    'Empty',
    'Error',
    'Offline',
    'Playing',
    'Selected',
    'Syncing',
    'Sync Conflict',
  ];

  static UiStateDefinition of(UiState state) {
    switch (state) {
      case UiState.defaults:
        return const UiStateDefinition(
          state: UiState.defaults,
          label: 'Default',
          nonColorCues: <UiStateCue>[
            UiStateCue('Resting surface; no focus ring or scale'),
          ],
        );
      case UiState.focused:
        return const UiStateDefinition(
          state: UiState.focused,
          label: 'Focused',
          accent: AppColors.cloud,
          nonColorCues: <UiStateCue>[
            UiStateCue(
              'Cloud ${FocusStyles.ringWidth}px ring + Signal glow '
              '(FocusStyles.focusGlow)',
            ),
            UiStateCue('${FocusStyles.scale}× scale (FocusStyles.scale)'),
          ],
        );
      case UiState.pressed:
        return const UiStateDefinition(
          state: UiState.pressed,
          label: 'Pressed',
          nonColorCues: <UiStateCue>[
            UiStateCue('Brief scale-down or opacity dip on activate'),
          ],
        );
      case UiState.disabled:
        return const UiStateDefinition(
          state: UiState.disabled,
          label: 'Disabled',
          accent: AppColors.mist,
          nonColorCues: <UiStateCue>[
            UiStateCue('Reduced opacity and non-focusable'),
            UiStateCue('Explicit unavailable affordance (label or icon)'),
          ],
        );
      case UiState.loading:
        return const UiStateDefinition(
          state: UiState.loading,
          label: 'Loading',
          accent: AppColors.signal,
          nonColorCues: <UiStateCue>[
            UiStateCue('Indeterminate progress indicator'),
            UiStateCue('Loading / buffering text when space allows'),
          ],
        );
      case UiState.empty:
        return const UiStateDefinition(
          state: UiState.empty,
          label: 'Empty',
          accent: AppColors.mist,
          nonColorCues: <UiStateCue>[
            UiStateCue('Empty illustration or icon'),
            UiStateCue('Helper copy explaining next action'),
          ],
        );
      case UiState.error:
        return const UiStateDefinition(
          state: UiState.error,
          label: 'Error',
          accent: AppColors.error,
          nonColorCues: <UiStateCue>[
            UiStateCue('Error icon (not hue alone)'),
            UiStateCue('Human-readable failure message + retry when possible'),
          ],
        );
      case UiState.offline:
        return const UiStateDefinition(
          state: UiState.offline,
          label: 'Offline',
          accent: AppColors.warning,
          nonColorCues: <UiStateCue>[
            UiStateCue('Offline / disconnected icon'),
            UiStateCue('Connectivity message; cached content labeled if shown'),
          ],
        );
      case UiState.playing:
        return const UiStateDefinition(
          state: UiState.playing,
          label: 'Playing',
          accent: AppColors.signal,
          nonColorCues: <UiStateCue>[
            UiStateCue('Playing indicator or progress chrome'),
            UiStateCue('Timecode / LIVE label when applicable'),
          ],
        );
      case UiState.selected:
        return const UiStateDefinition(
          state: UiState.selected,
          label: 'Selected',
          accent: AppColors.signal,
          nonColorCues: <UiStateCue>[
            UiStateCue('Checkmark, fill, or selected glyph'),
            UiStateCue('Distinct from Focused (selection persists without focus)'),
          ],
        );
      case UiState.syncing:
        return const UiStateDefinition(
          state: UiState.syncing,
          label: 'Syncing',
          accent: AppColors.success,
          nonColorCues: <UiStateCue>[
            UiStateCue('Sync spinner or animated sync glyph'),
            UiStateCue('Syncing label'),
          ],
        );
      case UiState.syncConflict:
        return const UiStateDefinition(
          state: UiState.syncConflict,
          label: 'Sync Conflict',
          accent: AppColors.warning,
          nonColorCues: <UiStateCue>[
            UiStateCue('Warning icon'),
            UiStateCue('Conflict copy with resolve / choose-version action'),
          ],
        );
    }
  }

  static List<UiStateDefinition> get all =>
      UiState.values.map(of).toList(growable: false);
}
