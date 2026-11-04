import 'package:flutter/material.dart';

import 'app_colors.dart';

/// TV D-pad focus treatment from Brand Theme 2026–27.
abstract final class FocusStyles {
  static const double scale = 1.05;
  static const double ringWidth = 4;

  static List<BoxShadow> focusGlow({Color ring = AppColors.cloud}) {
    return [
      BoxShadow(color: ring, spreadRadius: ringWidth, blurRadius: 0),
      BoxShadow(
        color: AppColors.signal.withValues(alpha: 0.45),
        spreadRadius: 10,
        blurRadius: 0,
      ),
    ];
  }
}
