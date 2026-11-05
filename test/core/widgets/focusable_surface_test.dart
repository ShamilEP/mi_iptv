import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/focusable_surface.dart';

void main() {
  Future<void> pumpKind(
    WidgetTester tester, {
    required FocusControlKind kind,
    required Color canvas,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: canvas,
          body: Center(
            child: FocusableSurface(
              key: ValueKey(kind),
              kind: kind,
              applySpecPadding: true,
              onPressed: () {},
              child: Text(kind.name),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('defaults to card spec fill and radius', (tester) async {
    await pumpKind(
      tester,
      kind: FocusControlKind.card,
      canvas: AppColors.ink,
    );

    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(FocusableSurface),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.surface);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.md));
    expect(decoration.boxShadow, isNull);
  });

  testWidgets('focused state applies scale, Cloud ring, Signal glow', (
    tester,
  ) async {
    await pumpKind(
      tester,
      kind: FocusControlKind.button,
      canvas: AppColors.ink,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

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

  testWidgets('each control kind paints on every low-luminosity canvas', (
    tester,
  ) async {
    for (final canvas in FocusStyles.lowLuminosityBackgrounds) {
      for (final kind in FocusControlKind.values) {
        await pumpKind(tester, kind: kind, canvas: canvas);
        expect(find.text(kind.name), findsOneWidget);

        final spec = FocusStyles.specFor(kind);
        final container = tester.widget<AnimatedContainer>(
          find.descendant(
            of: find.byType(FocusableSurface),
            matching: find.byType(AnimatedContainer),
          ),
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, spec.fill);
        expect(
          decoration.borderRadius,
          BorderRadius.circular(spec.borderRadius),
        );
      }
    }
  });
}
