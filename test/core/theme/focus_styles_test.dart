import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

void main() {
  group('DSN-006 FocusStyles tokens', () {
    test('scale and Cloud ring match Frontend §2.1', () {
      expect(FocusStyles.scale, closeTo(1.05, 0.001));
      expect(FocusStyles.ringWidth, 4);
      expect(FocusStyles.ringColor, AppColors.cloud);
      expect(FocusStyles.glowColor, AppColors.signal);
    });

    test('focusGlow is Cloud ring then Signal outer glow', () {
      final glow = FocusStyles.focusGlow();
      expect(glow, hasLength(2));
      expect(glow[0].color, AppColors.cloud);
      expect(glow[0].spreadRadius, FocusStyles.ringWidth);
      expect(glow[0].blurRadius, 0);
      expect(
        glow[1].color,
        AppColors.signal.withValues(alpha: FocusStyles.glowAlpha),
      );
      expect(glow[1].spreadRadius, FocusStyles.glowSpread);
    });

    test('every FocusControlKind has a distinct role spec', () {
      final specs = FocusControlKind.values
          .map(FocusStyles.specFor)
          .toList(growable: false);
      expect(specs, hasLength(FocusControlKind.values.length));
      expect(
        specs.map((s) => s.kind).toSet(),
        FocusControlKind.values.toSet(),
      );

      expect(FocusStyles.specFor(FocusControlKind.card).borderRadius, AppRadius.md);
      expect(
        FocusStyles.specFor(FocusControlKind.button).borderRadius,
        AppRadius.sm,
      );
      expect(
        FocusStyles.specFor(FocusControlKind.chip).borderRadius,
        AppRadius.full,
      );
      expect(
        FocusStyles.specFor(FocusControlKind.listRow).borderRadius,
        AppRadius.sm,
      );
      expect(
        FocusStyles.specFor(FocusControlKind.keyboardKey).borderRadius,
        AppRadius.xs,
      );
    });
  });

  group('DSN-006 Cloud ring on low-luminosity backgrounds', () {
    test('Ink / Panel / Surface are low luminance', () {
      for (final bg in FocusStyles.lowLuminosityBackgrounds) {
        expect(
          ColorContrast.relativeLuminance(bg),
          lessThan(0.2),
          reason: 'expected low-luminosity canvas for $bg',
        );
      }
    });

    test('Cloud ring meets large-text AA against each dark canvas', () {
      // Focus ring is a large non-text chrome cue; AA large (3:1) is the floor.
      for (final bg in FocusStyles.lowLuminosityBackgrounds) {
        expect(
          ColorContrast.meetsWcagAa(
            FocusStyles.ringColor,
            bg,
            largeText: true,
          ),
          isTrue,
          reason:
              'Cloud on $bg ratio '
              '${ColorContrast.contrastRatio(FocusStyles.ringColor, bg).toStringAsFixed(2)}',
        );
      }
    });

    test('Cloud ring also meets normal-text AA on Ink and Panel', () {
      expect(
        ColorContrast.meetsWcagAa(FocusStyles.ringColor, AppColors.ink),
        isTrue,
      );
      expect(
        ColorContrast.meetsWcagAa(FocusStyles.ringColor, AppColors.panel),
        isTrue,
      );
    });
  });
}
