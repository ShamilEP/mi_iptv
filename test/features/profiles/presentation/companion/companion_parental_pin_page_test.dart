import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_text_field.dart';
import 'package:mi_iptv/features/profiles/presentation/companion/companion_parental_pin_page.dart';
import 'package:mi_iptv/features/profiles/presentation/parental_pin_models.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    CompanionParentalPinPage? page,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? const CompanionParentalPinPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-062 Companion shows restricted messaging and PIN field', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(ParentalPinCopy.restrictedTitle), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey<String>('companion-pin-enter')),
    );
    await tester.pumpAndSettle();

    expect(find.text(ParentalPinCopy.entryTitle), findsOneWidget);
    expect(find.byType(MiTextField), findsOneWidget);
  });

  testWidgets('Companion unlocks with demo PIN via system field', (
    tester,
  ) async {
    var unlocked = 0;
    await pump(
      tester,
      page: CompanionParentalPinPage(
        initialScreen: ParentalPinScreen.entry,
        onUnlocked: () => unlocked++,
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('companion-pin-field')),
      ParentalPinCopy.demoExpectedPin,
    );
    await tester.pumpAndSettle();

    expect(find.text(ParentalPinCopy.unlockedTitle), findsOneWidget);
    expect(unlocked, 1);
  });
}
