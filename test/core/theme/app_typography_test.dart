import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

void main() {
  group('AppTypography DSN-003 family contract', () {
    test('locks brand family names', () {
      expect(AppTypography.displayFamily, 'Bricolage Grotesque');
      expect(AppTypography.bodyFamily, 'Figtree');
      expect(AppTypography.dataFamily, 'JetBrains Mono');
    });

    test('declares system fallbacks', () {
      expect(AppTypography.displayFallbacks, <String>['sans-serif']);
      expect(AppTypography.bodyFallbacks, <String>['sans-serif']);
      expect(AppTypography.dataFallbacks, <String>['monospace']);
    });
  });

  group('AppTypography TV 1080p ramp', () {
    late TextTheme theme;

    setUp(() {
      theme = AppTypography.tvTextTheme(ThemeData.dark().textTheme);
    });

    test('locks display / headline / title on Bricolage', () {
      expect(theme.displayLarge?.fontFamily, AppTypography.displayFamily);
      expect(theme.displayLarge?.fontSize, AppTypography.tvDisplaySize);
      expect(theme.displayLarge?.height, AppTypography.tvDisplayLine / AppTypography.tvDisplaySize);
      expect(theme.displayLarge?.fontWeight, FontWeight.w800);
      expect(theme.displayLarge?.color, AppColors.cloud);

      expect(theme.headlineMedium?.fontFamily, AppTypography.displayFamily);
      expect(theme.headlineMedium?.fontSize, AppTypography.tvHeadlineSize);
      expect(theme.headlineMedium?.fontWeight, FontWeight.w700);

      expect(theme.titleLarge?.fontFamily, AppTypography.displayFamily);
      expect(theme.titleLarge?.fontSize, AppTypography.tvTitleSize);
      expect(theme.titleLarge?.fontWeight, FontWeight.w700);
    });

    test('locks body / label on Figtree and data on JetBrains Mono', () {
      expect(theme.bodyLarge?.fontFamily, AppTypography.bodyFamily);
      expect(theme.bodyLarge?.fontSize, AppTypography.tvBodySize);
      expect(theme.bodyLarge?.fontWeight, FontWeight.w400);

      expect(theme.bodyMedium?.fontFamily, AppTypography.bodyFamily);
      expect(theme.bodyMedium?.fontSize, AppTypography.tvBodySize);
      expect(theme.bodyMedium?.fontWeight, FontWeight.w600);

      expect(theme.labelLarge?.fontFamily, AppTypography.bodyFamily);
      expect(theme.labelLarge?.fontSize, AppTypography.tvLabelSize);
      expect(theme.labelLarge?.fontWeight, FontWeight.w600);
      expect(theme.labelLarge?.color, AppColors.mist);

      expect(theme.labelSmall?.fontFamily, AppTypography.dataFamily);
      expect(theme.labelSmall?.fontSize, AppTypography.tvDataSize);
      expect(theme.labelSmall?.height, AppTypography.tvDataLine / AppTypography.tvDataSize);
      expect(theme.labelSmall?.fontWeight, FontWeight.w500);
      expect(theme.labelSmall?.color, AppColors.signal);
    });
  });

  group('AppTypography Companion ramp', () {
    late TextTheme theme;

    setUp(() {
      theme = AppTypography.companionTextTheme(ThemeData.light().textTheme);
    });

    test('uses smaller sizes than TV', () {
      expect(theme.displayLarge?.fontSize, AppTypography.companionDisplaySize);
      expect(theme.headlineMedium?.fontSize, AppTypography.companionHeadlineSize);
      expect(theme.titleLarge?.fontSize, AppTypography.companionTitleSize);
      expect(theme.bodyLarge?.fontSize, AppTypography.companionBodySize);
      expect(theme.labelLarge?.fontSize, AppTypography.companionLabelSize);
      expect(theme.labelSmall?.fontSize, AppTypography.companionDataSize);

      expect(
        theme.displayLarge!.fontSize! < AppTypography.tvDisplaySize,
        isTrue,
      );
      expect(
        theme.bodyLarge!.fontSize! < AppTypography.tvBodySize,
        isTrue,
      );
    });

    test('locks companion ink / muted / primary colors', () {
      expect(theme.displayLarge?.color, AppColors.ink);
      expect(theme.bodyLarge?.color, AppColors.ink);
      expect(theme.labelLarge?.color, AppColors.companionMuted);
      expect(theme.labelSmall?.color, AppColors.companionPrimary);
      expect(theme.labelSmall?.fontWeight, FontWeight.w500);
      expect(theme.titleLarge?.fontWeight, FontWeight.w700);
    });
  });

  group('AppTheme text theme wiring', () {
    test('tvDark uses TV ramp sizes', () {
      final text = AppTheme.tvDark().textTheme;
      expect(text.displayLarge?.fontSize, AppTypography.tvDisplaySize);
      expect(text.bodyLarge?.fontSize, AppTypography.tvBodySize);
      expect(text.labelSmall?.fontFamily, AppTypography.dataFamily);
    });

    test('companionLight uses Companion ramp sizes', () {
      final text = AppTheme.companionLight().textTheme;
      expect(text.displayLarge?.fontSize, AppTypography.companionDisplaySize);
      expect(text.bodyLarge?.fontSize, AppTypography.companionBodySize);
      expect(text.labelLarge?.fontSize, AppTypography.companionLabelSize);
      expect(text.displayLarge?.color, AppColors.ink);
    });
  });
}
