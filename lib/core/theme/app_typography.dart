import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Brand type roles. Family names are declared; font packaging needs approval.
abstract final class AppTypography {
  static const String displayFamily = 'Bricolage Grotesque';
  static const String bodyFamily = 'Figtree';
  static const String dataFamily = 'JetBrains Mono';

  /// TV-oriented text theme (1080p sp targets from brand sheet).
  static TextTheme tvTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: displayFamily,
        fontSize: 56,
        height: 64 / 56,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.03 * 56,
        color: AppColors.cloud,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: displayFamily,
        fontSize: 40,
        height: 48 / 40,
        fontWeight: FontWeight.w700,
        color: AppColors.cloud,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: displayFamily,
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w700,
        color: AppColors.cloud,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: bodyFamily,
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w400,
        color: AppColors.cloud,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: bodyFamily,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.mist,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: dataFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.signal,
      ),
    );
  }
}
