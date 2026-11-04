import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

void main() {
  group('ColorContrast helper', () {
    test('identical colors yield ratio 1', () {
      expect(
        ColorContrast.contrastRatio(AppColors.ink, AppColors.ink),
        1,
      );
    });

    test('ratio is commutative', () {
      expect(
        ColorContrast.contrastRatio(AppColors.cloud, AppColors.ink),
        ColorContrast.contrastRatio(AppColors.ink, AppColors.cloud),
      );
    });
  });

  group('DSN-002 approved pairs meet WCAG AA', () {
    void expectAa(Color fg, Color bg, {String? reason}) {
      expect(
        ColorContrast.meetsWcagAa(fg, bg),
        isTrue,
        reason: reason ??
            'ratio ${ColorContrast.contrastRatio(fg, bg).toStringAsFixed(2)}',
      );
    }

    test('TV / dark text on ink and surface', () {
      expectAa(AppColors.cloud, AppColors.ink);
      expectAa(AppColors.cloud, AppColors.surface);
      expectAa(AppColors.mist, AppColors.ink);
      expectAa(AppColors.mist, AppColors.surface);
      expectAa(AppColors.mist, AppColors.panel);
      expectAa(AppColors.ember, AppColors.ink);
      expectAa(AppColors.ember, AppColors.surface);
      expectAa(AppColors.signal, AppColors.ink);
      expectAa(AppColors.signal, AppColors.surface);
      expectAa(AppColors.success, AppColors.ink);
      expectAa(AppColors.warning, AppColors.ink);
      expectAa(AppColors.error, AppColors.ink);
    });

    test('TV ColorScheme on* fills', () {
      expectAa(AppColors.ink, AppColors.signal);
      expectAa(AppColors.ink, AppColors.ember);
      expectAa(AppColors.ink, AppColors.success);
      expectAa(AppColors.ink, AppColors.warning);
      expectAa(AppColors.ink, AppColors.error);
    });

    test('Companion / light text and CTAs', () {
      expectAa(AppColors.ink, AppColors.cloud);
      expectAa(AppColors.companionPrimary, AppColors.cloud);
      expectAa(AppColors.companionLive, AppColors.cloud);
      expectAa(AppColors.companionMuted, AppColors.cloud);
      expectAa(AppColors.cloud, AppColors.companionPrimary);
      expectAa(AppColors.cloud, AppColors.companionLive);
      expectAa(AppColors.ink, AppColors.success);
      expectAa(AppColors.ink, AppColors.error);
    });
  });

  group('DSN-002 unsafe pairs fail WCAG AA', () {
    void expectFailsAa(Color fg, Color bg) {
      expect(
        ColorContrast.meetsWcagAa(fg, bg),
        isFalse,
        reason:
            'ratio ${ColorContrast.contrastRatio(fg, bg).toStringAsFixed(2)}',
      );
    }

    test('status accents must not be body text on Cloud', () {
      expectFailsAa(AppColors.success, AppColors.cloud);
      expectFailsAa(AppColors.warning, AppColors.cloud);
      expectFailsAa(AppColors.error, AppColors.cloud);
      expectFailsAa(AppColors.ember, AppColors.cloud);
      expectFailsAa(AppColors.signal, AppColors.cloud);
    });
  });
}
