import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Visual role for shared control chrome (DSN-013).
enum ControlRole { button, chip, toggle, listRow, textField }

/// Fill emphasis for buttons / chips.
enum ControlEmphasis {
  /// Brand primary fill (Signal / companionPrimary).
  primary,

  /// Neutral panel / surface.
  secondary,

  /// Send-to-TV / LIVE alert fill (Ember / companionLive) (DSN-052).
  sendToTv,
}

/// Resolved paint + non-color cues for a control [UiState] (DSN-013 / DSN-010).
@immutable
class ControlChrome {
  const ControlChrome({
    required this.state,
    required this.label,
    required this.fill,
    required this.foreground,
    required this.border,
    required this.opacity,
    required this.scale,
    required this.interactive,
    required this.showFocusGlow,
    required this.showProgress,
    required this.leadingIcon,
    required this.statusLabel,
  });

  final UiState state;
  final String label;
  final Color fill;
  final Color foreground;
  final Color border;
  final double opacity;
  final double scale;
  final bool interactive;
  final bool showFocusGlow;
  final bool showProgress;
  final IconData? leadingIcon;

  /// Catalog product label when a status cue is required; null for resting chrome.
  final String? statusLabel;

  static ControlChrome resolve(
    BuildContext context, {
    required UiState state,
    required ControlRole role,
    ControlEmphasis emphasis = ControlEmphasis.secondary,
  }) {
    final brand = context.brandColors;
    final def = UiStateCatalog.of(state);
    final companion = Theme.of(context).brightness == Brightness.light;

    final Color baseFill;
    final Color baseFg;
    switch (emphasis) {
      case ControlEmphasis.primary:
        baseFill = brand.primary;
        baseFg = companion ? brand.cloud : brand.ink;
      case ControlEmphasis.sendToTv:
        baseFill = brand.live;
        baseFg = brand.cloud;
      case ControlEmphasis.secondary:
        baseFill = role == ControlRole.listRow || role == ControlRole.textField
            ? (companion ? brand.cloud : brand.surface)
            : brand.panel;
        baseFg = companion ? brand.ink : brand.cloud;
    }

    var fill = baseFill;
    var foreground = baseFg;
    var border = brand.border;
    var opacity = 1.0;
    var scale = 1.0;
    var interactive = true;
    var showFocusGlow = false;
    var showProgress = false;
    IconData? icon;
    String? statusLabel;

    switch (state) {
      case UiState.defaults:
        break;
      case UiState.focused:
        showFocusGlow = true;
        scale = FocusStyles.scale;
        border = FocusStyles.ringColor;
      case UiState.pressed:
        scale = 0.97;
        opacity = 0.88;
      case UiState.disabled:
        opacity = 0.45;
        interactive = false;
        foreground = brand.muted;
        icon = Icons.block;
        statusLabel = def.label;
      case UiState.loading:
        interactive = false;
        showProgress = true;
        icon = null;
        statusLabel = def.label;
        border = brand.primary;
      case UiState.empty:
        interactive = false;
        foreground = brand.muted;
        icon = Icons.inbox_outlined;
        statusLabel = def.label;
      case UiState.error:
        border = brand.error;
        foreground = companion ? brand.ink : brand.cloud;
        icon = Icons.error_outline;
        statusLabel = def.label;
      case UiState.offline:
        border = brand.warning;
        icon = Icons.wifi_off_outlined;
        statusLabel = def.label;
      case UiState.playing:
        border = brand.primary;
        icon = Icons.play_arrow;
        statusLabel = def.label;
      case UiState.selected:
        fill = switch (emphasis) {
          ControlEmphasis.primary => brand.primary,
          ControlEmphasis.sendToTv => brand.live,
          ControlEmphasis.secondary => companion ? brand.cloud : brand.surface,
        };
        border = brand.primary;
        icon = Icons.check;
        statusLabel = def.label;
      case UiState.syncing:
        interactive = false;
        showProgress = true;
        border = brand.success;
        statusLabel = def.label;
      case UiState.syncConflict:
        border = brand.warning;
        icon = Icons.warning_amber_outlined;
        statusLabel = def.label;
    }

    return ControlChrome(
      state: state,
      label: def.label,
      fill: fill,
      foreground: foreground,
      border: border,
      opacity: opacity,
      scale: scale,
      interactive: interactive,
      showFocusGlow: showFocusGlow,
      showProgress: showProgress,
      leadingIcon: icon,
      statusLabel: statusLabel,
    );
  }
}
