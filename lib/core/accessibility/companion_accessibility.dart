import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/color_contrast.dart';

/// Companion accessibility policy (CMP-063 / NFR-007).
///
/// Covers Dynamic Type clamping, TalkBack / VoiceOver expectations, and the
/// contrast pairs used on companion light surfaces.
abstract final class CompanionAccessibility {
  /// Lowest Dynamic Type factor the companion shell honors.
  static const double minTextScale = 1.0;

  /// Highest Dynamic Type factor before layout clamping (still readable).
  static const double maxTextScale = 2.0;

  /// Clamp OS text scaling into the companion-supported range.
  static TextScaler clampTextScaler(TextScaler scaler) {
    return scaler.clamp(
      minScaleFactor: minTextScale,
      maxScaleFactor: maxTextScale,
    );
  }

  /// WCAG AA pairs exercised on companion screens (DSN-002 / CMP-063).
  static const List<({Color foreground, Color background, String role})>
      contrastChecks = <({Color foreground, Color background, String role})>[
    (foreground: AppColors.ink, background: AppColors.cloud, role: 'body'),
    (
      foreground: AppColors.companionMuted,
      background: AppColors.cloud,
      role: 'secondary',
    ),
    (
      foreground: AppColors.companionPrimary,
      background: AppColors.cloud,
      role: 'primary CTA text',
    ),
    (
      foreground: AppColors.cloud,
      background: AppColors.companionPrimary,
      role: 'primary CTA fill',
    ),
    (
      foreground: AppColors.cloud,
      background: AppColors.ink,
      role: 'remote key label',
    ),
    (
      foreground: AppColors.cloud,
      background: AppColors.companionLive,
      role: 'Send-to-TV fill',
    ),
  ];

  /// True when every [contrastChecks] pair meets WCAG AA.
  static bool companionContrastPassesAa() {
    for (final check in contrastChecks) {
      if (!ColorContrast.meetsWcagAa(check.foreground, check.background)) {
        return false;
      }
    }
    return true;
  }
}

/// Applies [CompanionAccessibility.clampTextScaler] under [MediaQuery].
///
/// Wrap companion scaffolds so Dynamic Type grows UI text without unbounded
/// overflow past [CompanionAccessibility.maxTextScale].
class CompanionAccessibleScope extends StatelessWidget {
  const CompanionAccessibleScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: CompanionAccessibility.clampTextScaler(media.textScaler),
      ),
      child: child,
    );
  }
}
