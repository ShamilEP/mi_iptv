import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_subtitle_style.dart';
import '../theme/app_typography.dart';
import '../theme/focus_styles.dart';
import 'tv_distance_legibility.dart';

/// TV accessibility policy (TV-123 / NFR-007).
///
/// Covers OS text-size clamping for 10-foot layouts, 2–3 m type floors, WCAG AA
/// contrast, focus visibility, and subtitle caption floors. Distance floors
/// delegate to [TvDistanceLegibility] (QA-037). Token authority remains DSN-002.
abstract final class TvAccessibility {
  /// Lowest OS text scale the TV shell honors.
  static const double minTextScale = 1.0;

  /// Highest OS text scale before layout clamping (tighter than Companion).
  static const double maxTextScale = 1.5;

  /// Living-room viewing band (meters) for this pass.
  static const double minViewingDistanceMeters =
      TvDistanceLegibility.minViewingDistanceMeters;

  static const double maxViewingDistanceMeters =
      TvDistanceLegibility.maxViewingDistanceMeters;

  /// Clamp OS text scaling into the TV-supported range.
  static TextScaler clampTextScaler(TextScaler scaler) {
    return scaler.clamp(
      minScaleFactor: minTextScale,
      maxScaleFactor: maxTextScale,
    );
  }

  /// TV dark contrast pairs exercised by this accessibility pass.
  static List<({Color foreground, Color background, String role})>
  get contrastChecks => TvDistanceLegibility.contrastChecks;

  /// True when every [contrastChecks] pair meets WCAG AA.
  static bool contrastPassesAa() => TvDistanceLegibility.contrastPassesAa();

  /// True when TV type ramps meet 2–3 m floors.
  static bool textSizesMeetDistanceFloors() =>
      TvDistanceLegibility.typographyMeetsDistanceFloors();

  /// True when focus chrome stays visible at 2–3 m.
  static bool focusVisibleAtDistance() =>
      TvDistanceLegibility.focusVisibleAtDistance();

  /// True when standard and large subtitle presets stay above body floor and
  /// Cloud-on-Ink captions meet large-text AA (DSN-021).
  static bool subtitlesMeetAccessibility() {
    if (AppSubtitleStyle.standardFontSize < AppTypography.tvBodySize) {
      return false;
    }
    if (AppSubtitleStyle.largeFontSize < AppSubtitleStyle.standardFontSize) {
      return false;
    }
    if (AppSubtitleStyle.foreground != AppColors.cloud) return false;
    return AppSubtitleStyle.contrastMeetsAa();
  }

  /// Aggregate TV-123 gate: text scale policy, type floors, contrast, focus,
  /// and subtitles.
  static bool passesAccessibilityPass() {
    if (minTextScale != 1.0) return false;
    if (maxTextScale < minTextScale || maxTextScale > 1.5) return false;
    if (FocusStyles.ringWidth < 4) return false;
    return textSizesMeetDistanceFloors() &&
        contrastPassesAa() &&
        focusVisibleAtDistance() &&
        subtitlesMeetAccessibility() &&
        TvDistanceLegibility.passesDistanceAccessibility();
  }
}

/// Applies [TvAccessibility.clampTextScaler] under [MediaQuery].
///
/// Wrap TV scaffolds so system font scale grows chrome without breaking
/// 10-foot layouts past [TvAccessibility.maxTextScale].
class TvAccessibleScope extends StatelessWidget {
  const TvAccessibleScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: TvAccessibility.clampTextScaler(media.textScaler),
      ),
      child: child,
    );
  }
}
