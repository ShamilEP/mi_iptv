import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'color_contrast.dart';

/// Locked TV subtitle / caption presentation (DSN-021 / NFR-007).
enum SubtitleSizePreset {
  /// Default TV caption size for 2–3 m viewing.
  standard,

  /// Larger accessible caption size.
  large,
}

/// Subtitle size, scrim background, and contrast defaults for TV playback.
abstract final class AppSubtitleStyle {
  /// Standard caption size (sp) — above [AppTypography.tvTitleSize] for video.
  static const double standardFontSize = 32;

  /// Large accessible caption size (sp).
  static const double largeFontSize = 40;

  static const double standardLineHeight = 40;
  static const double largeLineHeight = 48;

  /// Caption text on the scrim (Cloud).
  static const Color foreground = AppColors.cloud;

  /// Scrim fill under captions (Ink at 72% opacity for contrast on any frame).
  static const double backgroundOpacity = 0.72;

  static Color get background =>
      AppColors.ink.withValues(alpha: backgroundOpacity);

  static EdgeInsets get padding => const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      );

  static BorderRadius get borderRadius => BorderRadius.circular(AppRadius.sm);

  static double fontSizeOf(SubtitleSizePreset preset) {
    switch (preset) {
      case SubtitleSizePreset.standard:
        return standardFontSize;
      case SubtitleSizePreset.large:
        return largeFontSize;
    }
  }

  static double lineHeightOf(SubtitleSizePreset preset) {
    switch (preset) {
      case SubtitleSizePreset.standard:
        return standardLineHeight;
      case SubtitleSizePreset.large:
        return largeLineHeight;
    }
  }

  /// Text style before OS [TextScaler] is applied by the framework.
  static TextStyle textStyle(SubtitleSizePreset preset) {
    final size = fontSizeOf(preset);
    final line = lineHeightOf(preset);
    return TextStyle(
      fontFamily: AppTypography.bodyFamily,
      fontFamilyFallback: AppTypography.bodyFallbacks,
      fontSize: size,
      height: line / size,
      fontWeight: FontWeight.w600,
      color: foreground,
    );
  }

  /// WCAG AA check for caption Cloud on the opaque Ink equivalent of the scrim.
  ///
  /// Evaluates against solid [AppColors.ink] (worst-case dark frame behind a
  /// translucent scrim) as large text.
  static bool contrastMeetsAa() {
    return ColorContrast.meetsWcagAa(
      foreground,
      AppColors.ink,
      largeText: true,
    );
  }
}
