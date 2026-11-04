import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

void main() {
  group('AppColors DSN-001 hex contract', () {
    test('locks dark-first brand tokens', () {
      expect(AppColors.ink, const Color(0xFF0A0D14));
      expect(AppColors.surface, const Color(0xFF1A2130));
      expect(AppColors.cloud, const Color(0xFFF0EEE9));
      expect(AppColors.signal, const Color(0xFF2BD9C8));
      expect(AppColors.ember, const Color(0xFFFF7A4D));
      expect(AppColors.mist, const Color(0xFFA3AFC4));
      expect(AppColors.success, const Color(0xFF6FDC8C));
      expect(AppColors.warning, const Color(0xFFFFC857));
      expect(AppColors.error, const Color(0xFFFF6B7A));
    });

    test('locks companion light accents', () {
      expect(AppColors.companionPrimary, const Color(0xFF0A6F68));
      expect(AppColors.companionLive, const Color(0xFFB8431B));
    });
  });

  group('MiBrandColors flavor mapping', () {
    test('tv maps Signal primary and Ember live', () {
      final brand = MiBrandColors.tv();
      expect(brand.primary, AppColors.signal);
      expect(brand.live, AppColors.ember);
      expect(brand.success, AppColors.success);
      expect(brand.warning, AppColors.warning);
      expect(brand.muted, AppColors.mist);
    });

    test('companion maps companionPrimary and companionLive', () {
      final brand = MiBrandColors.companion();
      expect(brand.primary, AppColors.companionPrimary);
      expect(brand.live, AppColors.companionLive);
      expect(brand.muted, AppColors.companionMuted);
    });

    test('AppTheme registers MiBrandColors extension', () {
      expect(
        AppTheme.tvDark().extension<MiBrandColors>()!.primary,
        AppColors.signal,
      );
      expect(
        AppTheme.companionLight().extension<MiBrandColors>()!.primary,
        AppColors.companionPrimary,
      );
    });
  });
}
