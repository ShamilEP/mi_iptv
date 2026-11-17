import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_pairing_code_page.dart';
import 'package:mi_iptv/features/devices/presentation/pairing_code_models.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    CompanionPairingCodePage? page,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? const CompanionPairingCodePage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-071 Companion wrong code shows error and clears field', (
    tester,
  ) async {
    await pump(tester);

    await tester.enterText(
      find.byKey(const ValueKey<String>('pairing-companion-field')),
      '000000',
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('pairing-companion-submit')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('pairing-companion-wrong')),
      findsOneWidget,
    );
    expect(find.text(PairingCodeCopy.companionWrong), findsOneWidget);
    final field = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const ValueKey<String>('pairing-companion-field')),
        matching: find.byType(TextField),
      ),
    );
    expect(field.controller?.text, isEmpty);
  });

  testWidgets('DSN-071 Companion correct code reaches linked state', (
    tester,
  ) async {
    var linked = 0;
    await pump(
      tester,
      page: CompanionPairingCodePage(onLinked: () => linked++),
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('pairing-companion-field')),
      PairingCodeCopy.demoExpectedCode,
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('pairing-companion-submit')),
    );
    await tester.pumpAndSettle();

    expect(linked, 1);
    expect(find.text(PairingCodeCopy.companionLinkedTitle), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('pairing-companion-linked-icon')),
      findsOneWidget,
    );
  });
}
