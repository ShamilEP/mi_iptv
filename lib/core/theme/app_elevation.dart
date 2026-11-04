import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Soft ambient shadow recipes for dark-first TV (DSN-004).
///
/// Prefer these over Material elevation integers on Ink surfaces. Focus chrome
/// stays in [FocusStyles.focusGlow].
abstract final class AppElevation {
  static const List<BoxShadow> flat = <BoxShadow>[];

  static List<BoxShadow> raised({Color color = AppColors.ink}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.35),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static List<BoxShadow> overlay({Color color = AppColors.ink}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.5),
        blurRadius: 28,
        offset: const Offset(0, 12),
      ),
    ];
  }
}
