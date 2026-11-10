import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/accessibility/tv_distance_legibility.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/focusable_surface.dart';

void main() {
  group('QA-037 TV distance legibility policy', () {
    test('locks the 2–3 m viewing band', () {
      expect(TvDistanceLegibility.minViewingDistanceMeters, 2.0);
      expect(TvDistanceLegibility.maxViewingDistanceMeters, 3.0);
      expect(
        TvDistanceLegibility.maxViewingDistanceMeters,
        greaterThan(TvDistanceLegibility.minViewingDistanceMeters),
      );
    });

    test('TV typography meets 2–3 m size floors', () {
      expect(TvDistanceLegibility.minBodySp, 20);
      expect(TvDistanceLegibility.minTitleSp, 28);
      expect(TvDistanceLegibility.minLabelSp, 16);
      expect(TvDistanceLegibility.typographyMeetsDistanceFloors(), isTrue);

      final theme = AppTypography.tvTextTheme(ThemeData.dark().textTheme);
      expect(theme.bodyLarge?.fontSize, greaterThanOrEqualTo(20));
      expect(theme.titleLarge?.fontSize, greaterThanOrEqualTo(28));
      expect(theme.labelLarge?.fontSize, greaterThanOrEqualTo(16));
      expect(theme.headlineMedium?.fontSize, greaterThanOrEqualTo(28));
    });

    test('distance contrast pairs meet WCAG AA', () {
      expect(TvDistanceLegibility.contrastChecks, isNotEmpty);
      for (final check in TvDistanceLegibility.contrastChecks) {
        expect(
          ColorContrast.meetsWcagAa(check.foreground, check.background),
          isTrue,
          reason:
              '${check.role}: ratio '
              '${ColorContrast.contrastRatio(check.foreground, check.background).toStringAsFixed(2)}',
        );
      }
      expect(TvDistanceLegibility.contrastPassesAa(), isTrue);
    });

    test('focus visibility keeps Cloud ring, Signal glow, and scale', () {
      expect(TvDistanceLegibility.minFocusRingWidth, 4);
      expect(TvDistanceLegibility.minFocusScale, closeTo(1.05, 0.001));
      expect(TvDistanceLegibility.focusVisibleAtDistance(), isTrue);
    });

    test('aggregate distance accessibility gate passes', () {
      expect(TvDistanceLegibility.passesDistanceAccessibility(), isTrue);
    });
  });

  group('QA-037 focus visibility on TV canvases', () {
    Future<void> pumpFocused(
      WidgetTester tester, {
      required Color canvas,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.tvDark(),
          home: Scaffold(
            backgroundColor: canvas,
            body: Center(
              child: FocusableSurface(
                kind: FocusControlKind.button,
                applySpecPadding: true,
                onPressed: () {},
                child: const Text('Focus me'),
              ),
            ),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
    }

    testWidgets('focused control shows scale and dual glow on Ink', (
      tester,
    ) async {
      await pumpFocused(tester, canvas: AppColors.ink);

      final scale = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(FocusableSurface),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(scale.scale, FocusStyles.scale);

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(FocusableSurface),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.boxShadow, FocusStyles.focusGlow());
    });

    testWidgets('focused glow remains on Surface and Panel canvases', (
      tester,
    ) async {
      for (final canvas in FocusStyles.lowLuminosityBackgrounds) {
        await pumpFocused(tester, canvas: canvas);
        final container = tester.widget<AnimatedContainer>(
          find.descendant(
            of: find.byType(FocusableSurface),
            matching: find.byType(AnimatedContainer),
          ),
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(
          decoration.boxShadow,
          FocusStyles.focusGlow(),
          reason: 'focus glow missing on $canvas',
        );
      }
    });
  });
}
