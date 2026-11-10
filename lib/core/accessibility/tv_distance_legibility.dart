import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/color_contrast.dart';
import '../theme/focus_styles.dart';

/// TV 2–3 m viewing legibility and accessibility floors (QA-037 / NFR-007).
///
/// Locks minimum type sizes for 10-foot UI, WCAG AA contrast pairs for body
/// chrome, and focus visibility (Cloud ring + Signal glow + scale) on dark
/// canvases. Token authority remains DSN-002 / DSN-003 / DSN-006.
abstract final class TvDistanceLegibility {
  /// Near end of the living-room viewing band (meters).
  static const double minViewingDistanceMeters = 2.0;

  /// Far end of the living-room viewing band (meters).
  static const double maxViewingDistanceMeters = 3.0;

  /// Smallest body text allowed on TV at [minViewingDistanceMeters].
  static const double minBodySp = AppTypography.tvBodySize;

  /// Smallest title text allowed on TV at distance.
  static const double minTitleSp = AppTypography.tvTitleSize;

  /// Smallest label / chrome text allowed on TV at distance.
  static const double minLabelSp = AppTypography.tvLabelSize;

  /// Focus ring must stay at least this wide (logical px) for 2–3 m visibility.
  static const double minFocusRingWidth = FocusStyles.ringWidth;

  /// Focus scale must stay at least this factor (non-color cue).
  static const double minFocusScale = FocusStyles.scale;

  /// Primary TV text / canvas pairs exercised for distance contrast.
  static const List<({Color foreground, Color background, String role})>
      contrastChecks = <({Color foreground, Color background, String role})>[
    (foreground: AppColors.cloud, background: AppColors.ink, role: 'body on ink'),
    (
      foreground: AppColors.cloud,
      background: AppColors.surface,
      role: 'body on surface',
    ),
    (foreground: AppColors.mist, background: AppColors.ink, role: 'muted on ink'),
    (
      foreground: AppColors.mist,
      background: AppColors.surface,
      role: 'muted on surface',
    ),
    (
      foreground: AppColors.signal,
      background: AppColors.ink,
      role: 'primary accent on ink',
    ),
    (
      foreground: AppColors.ember,
      background: AppColors.ink,
      role: 'live accent on ink',
    ),
    (
      foreground: AppColors.ink,
      background: AppColors.signal,
      role: 'CTA label on Signal',
    ),
    (
      foreground: FocusStyles.ringColor,
      background: AppColors.ink,
      role: 'focus ring on ink',
    ),
  ];

  /// True when every [contrastChecks] pair meets WCAG AA.
  static bool contrastPassesAa() {
    for (final check in contrastChecks) {
      if (!ColorContrast.meetsWcagAa(check.foreground, check.background)) {
        return false;
      }
    }
    return true;
  }

  /// True when TV type ramps stay at or above distance floors.
  static bool typographyMeetsDistanceFloors() {
    return AppTypography.tvBodySize >= minBodySp &&
        AppTypography.tvTitleSize >= minTitleSp &&
        AppTypography.tvLabelSize >= minLabelSp &&
        AppTypography.tvHeadlineSize >= minTitleSp &&
        AppTypography.tvDisplaySize >= minTitleSp;
  }

  /// True when focus chrome stays visible at 2–3 m (width, scale, dual cues).
  static bool focusVisibleAtDistance() {
    if (FocusStyles.ringWidth < minFocusRingWidth) return false;
    if (FocusStyles.scale < minFocusScale) return false;
    final glow = FocusStyles.focusGlow();
    if (glow.length < 2) return false;
    if (glow[0].color != FocusStyles.ringColor) return false;
    if (glow[1].color !=
        FocusStyles.glowColor.withValues(alpha: FocusStyles.glowAlpha)) {
      return false;
    }
    for (final bg in FocusStyles.lowLuminosityBackgrounds) {
      if (!ColorContrast.meetsWcagAa(
        FocusStyles.ringColor,
        bg,
        largeText: true,
      )) {
        return false;
      }
    }
    return true;
  }

  /// Aggregate gate used by QA-037 automated distance checks.
  static bool passesDistanceAccessibility() {
    return typographyMeetsDistanceFloors() &&
        contrastPassesAa() &&
        focusVisibleAtDistance();
  }
}
