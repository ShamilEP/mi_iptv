import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Brand type roles and TV / Companion ramps (DSN-003).
abstract final class AppTypography {
  static const String displayFamily = 'Bricolage Grotesque';
  static const String bodyFamily = 'Figtree';
  static const String dataFamily = 'JetBrains Mono';

  static const List<String> displayFallbacks = <String>['sans-serif'];
  static const List<String> bodyFallbacks = <String>['sans-serif'];
  static const List<String> dataFallbacks = <String>['monospace'];

  // TV 1080p scale (size / line-height).
  static const double tvDisplaySize = 56;
  static const double tvDisplayLine = 64;
  static const double tvHeadlineSize = 40;
  static const double tvHeadlineLine = 48;
  static const double tvTitleSize = 28;
  static const double tvTitleLine = 36;
  static const double tvBodySize = 20;
  static const double tvBodyLine = 28;
  static const double tvLabelSize = 16;
  static const double tvLabelLine = 24;
  static const double tvDataSize = 16;
  static const double tvDataLine = 24;

  // Companion scale (size / derived line-height).
  static const double companionDisplaySize = 36;
  static const double companionDisplayLine = 44;
  static const double companionHeadlineSize = 28;
  static const double companionHeadlineLine = 36;
  static const double companionTitleSize = 20;
  static const double companionTitleLine = 28;
  static const double companionBodySize = 16;
  static const double companionBodyLine = 24;
  static const double companionLabelSize = 13;
  static const double companionLabelLine = 20;
  static const double companionDataSize = 13;
  static const double companionDataLine = 20;

  /// TV-oriented text theme (1080p sp targets from brand sheet).
  static TextTheme tvTextTheme(TextTheme base) {
    return _buildTheme(
      base: base,
      displaySize: tvDisplaySize,
      displayLine: tvDisplayLine,
      headlineSize: tvHeadlineSize,
      headlineLine: tvHeadlineLine,
      titleSize: tvTitleSize,
      titleLine: tvTitleLine,
      bodySize: tvBodySize,
      bodyLine: tvBodyLine,
      labelSize: tvLabelSize,
      labelLine: tvLabelLine,
      dataSize: tvDataSize,
      dataLine: tvDataLine,
      primary: AppColors.cloud,
      muted: AppColors.mist,
      data: AppColors.signal,
    );
  }

  /// Companion mobile/tablet text theme (smaller ramp).
  static TextTheme companionTextTheme(TextTheme base) {
    return _buildTheme(
      base: base,
      displaySize: companionDisplaySize,
      displayLine: companionDisplayLine,
      headlineSize: companionHeadlineSize,
      headlineLine: companionHeadlineLine,
      titleSize: companionTitleSize,
      titleLine: companionTitleLine,
      bodySize: companionBodySize,
      bodyLine: companionBodyLine,
      labelSize: companionLabelSize,
      labelLine: companionLabelLine,
      dataSize: companionDataSize,
      dataLine: companionDataLine,
      primary: AppColors.ink,
      muted: AppColors.companionMuted,
      data: AppColors.companionPrimary,
    );
  }

  static TextTheme _buildTheme({
    required TextTheme base,
    required double displaySize,
    required double displayLine,
    required double headlineSize,
    required double headlineLine,
    required double titleSize,
    required double titleLine,
    required double bodySize,
    required double bodyLine,
    required double labelSize,
    required double labelLine,
    required double dataSize,
    required double dataLine,
    required Color primary,
    required Color muted,
    required Color data,
  }) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: displayFamily,
        fontFamilyFallback: displayFallbacks,
        fontSize: displaySize,
        height: displayLine / displaySize,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.03 * displaySize,
        color: primary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: displayFamily,
        fontFamilyFallback: displayFallbacks,
        fontSize: headlineSize,
        height: headlineLine / headlineSize,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: displayFamily,
        fontFamilyFallback: displayFallbacks,
        fontSize: titleSize,
        height: titleLine / titleSize,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: bodyFamily,
        fontFamilyFallback: bodyFallbacks,
        fontSize: bodySize,
        height: bodyLine / bodySize,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: bodyFamily,
        fontFamilyFallback: bodyFallbacks,
        fontSize: bodySize,
        height: bodyLine / bodySize,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: bodyFamily,
        fontFamilyFallback: bodyFallbacks,
        fontSize: labelSize,
        height: labelLine / labelSize,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: dataFamily,
        fontFamilyFallback: dataFallbacks,
        fontSize: dataSize,
        height: dataLine / dataSize,
        fontWeight: FontWeight.w500,
        color: data,
      ),
    );
  }
}
