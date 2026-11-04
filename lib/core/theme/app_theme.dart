import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData tvDark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.ink,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.signal,
        secondary: AppColors.ember,
        error: AppColors.error,
        onPrimary: AppColors.ink,
        onSecondary: AppColors.ink,
        onSurface: AppColors.cloud,
        onError: AppColors.ink,
      ),
    );

    return base.copyWith(
      textTheme: AppTypography.tvTextTheme(base.textTheme),
      dividerColor: AppColors.border,
      cardColor: AppColors.surface,
    );
  }

  static ThemeData companionLight() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cloud,
      colorScheme: const ColorScheme.light(
        surface: AppColors.cloud,
        primary: AppColors.companionPrimary,
        secondary: AppColors.companionLive,
        error: AppColors.error,
        onPrimary: AppColors.cloud,
        onSecondary: AppColors.cloud,
        onSurface: AppColors.ink,
        onError: AppColors.ink,
      ),
    );

    return base.copyWith(
      textTheme: AppTypography.tvTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
    );
  }
}
