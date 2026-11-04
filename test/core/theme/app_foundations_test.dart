import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

void main() {
  group('AppSpacing DSN-004 scale contract', () {
    test('locks 4dp base ramp', () {
      expect(AppSpacing.xxs, 4);
      expect(AppSpacing.xs, 8);
      expect(AppSpacing.sm, 12);
      expect(AppSpacing.md, 16);
      expect(AppSpacing.lg, 24);
      expect(AppSpacing.xl, 32);
      expect(AppSpacing.xxl, 48);
      expect(AppSpacing.xxxl, 64);
    });

    test('locks semantic aliases', () {
      expect(AppSpacing.stackTight, AppSpacing.xs);
      expect(AppSpacing.stack, AppSpacing.lg);
      expect(AppSpacing.insetCard, AppSpacing.md);
      expect(AppSpacing.insetPageTv, AppSpacing.xxl);
      expect(AppSpacing.insetPageCompanion, AppSpacing.md);
    });
  });

  group('AppGrid DSN-004 contract', () {
    test('locks rail rhythm', () {
      expect(AppGrid.gutter, AppSpacing.md);
      expect(AppGrid.rowGap, AppSpacing.lg);
      expect(AppGrid.railGap, AppSpacing.xl);
    });
  });

  group('AppOverscan DSN-004 contract', () {
    test('locks TV 48px safe inset', () {
      expect(AppOverscan.inset, 48);
      expect(AppOverscan.inset, AppSpacing.xxl);
      expect(AppOverscan.padding, const EdgeInsets.all(48));
    });
  });

  group('AppRadius DSN-004 contract', () {
    test('locks corner scale', () {
      expect(AppRadius.xs, 8);
      expect(AppRadius.sm, 12);
      expect(AppRadius.md, 16);
      expect(AppRadius.lg, 24);
      expect(AppRadius.full, 999);
    });
  });

  group('AppElevation DSN-004 contract', () {
    test('flat is empty; raised and overlay emit shadows', () {
      expect(AppElevation.flat, isEmpty);
      expect(AppElevation.raised(), hasLength(1));
      expect(AppElevation.overlay(), hasLength(1));
      expect(AppElevation.raised().first.blurRadius, 16);
      expect(AppElevation.overlay().first.blurRadius, 28);
    });
  });

  group('AppMotion DSN-004 contract', () {
    test('locks durations and curves', () {
      expect(AppMotion.fast, const Duration(milliseconds: 120));
      expect(AppMotion.normal, const Duration(milliseconds: 200));
      expect(AppMotion.slow, const Duration(milliseconds: 320));
      expect(AppMotion.emphasized, Curves.easeOutCubic);
      expect(AppMotion.standard, Curves.easeInOut);
    });
  });
}
