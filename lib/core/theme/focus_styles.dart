import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Focusable control roles that share the DSN-006 TV focus treatment.
enum FocusControlKind {
  /// Poster / tile cards (default catalog surfaces).
  card,

  /// Primary and secondary actions.
  button,

  /// Compact filter / genre / LIVE chips.
  chip,

  /// Vertical nav or channel rows.
  listRow,

  /// On-screen keyboard / PIN keys.
  keyboardKey,
}

/// Per-role geometry for [FocusableSurface] (DSN-006).
@immutable
class FocusControlSpec {
  const FocusControlSpec({
    required this.kind,
    required this.borderRadius,
    required this.fill,
    required this.contentPadding,
  });

  final FocusControlKind kind;
  final double borderRadius;
  final Color fill;
  final EdgeInsetsGeometry contentPadding;
}

/// TV D-pad focus treatment from Brand Theme 2026–27 / Frontend §2.1 (DSN-006).
///
/// Always combine:
/// - **Cloud** 4px ring (primary focus cue)
/// - **Signal** outer glow (secondary cue)
/// - **1.05×** scale (non-color cue — state ≠ hue alone)
abstract final class FocusStyles {
  static const double scale = 1.05;
  static const double ringWidth = 4;

  /// Focus ring color (Cloud).
  static const Color ringColor = AppColors.cloud;

  /// Outer glow accent (Signal).
  static const Color glowColor = AppColors.signal;

  static const double glowSpread = 10;
  static const double glowAlpha = 0.45;

  /// Low-luminosity TV canvases where the Cloud ring must remain visible.
  static const List<Color> lowLuminosityBackgrounds = <Color>[
    AppColors.ink,
    AppColors.panel,
    AppColors.surface,
  ];

  static FocusControlSpec specFor(FocusControlKind kind) {
    switch (kind) {
      case FocusControlKind.card:
        return const FocusControlSpec(
          kind: FocusControlKind.card,
          borderRadius: AppRadius.md,
          fill: AppColors.surface,
          contentPadding: EdgeInsets.all(AppSpacing.insetCard),
        );
      case FocusControlKind.button:
        return const FocusControlSpec(
          kind: FocusControlKind.button,
          borderRadius: AppRadius.sm,
          fill: AppColors.panel,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        );
      case FocusControlKind.chip:
        return const FocusControlSpec(
          kind: FocusControlKind.chip,
          borderRadius: AppRadius.full,
          fill: AppColors.panel,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
        );
      case FocusControlKind.listRow:
        return const FocusControlSpec(
          kind: FocusControlKind.listRow,
          borderRadius: AppRadius.sm,
          fill: AppColors.surface,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        );
      case FocusControlKind.keyboardKey:
        return const FocusControlSpec(
          kind: FocusControlKind.keyboardKey,
          borderRadius: AppRadius.xs,
          fill: AppColors.panel,
          contentPadding: EdgeInsets.all(AppSpacing.sm),
        );
    }
  }

  static List<BoxShadow> focusGlow({
    Color ring = ringColor,
    Color glow = glowColor,
  }) {
    return [
      BoxShadow(color: ring, spreadRadius: ringWidth, blurRadius: 0),
      BoxShadow(
        color: glow.withValues(alpha: glowAlpha),
        spreadRadius: glowSpread,
        blurRadius: 0,
      ),
    ];
  }
}
