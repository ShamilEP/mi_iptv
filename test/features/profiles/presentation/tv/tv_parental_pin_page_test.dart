import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/profiles/presentation/parental_pin_models.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_parental_pin_page.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_pin_pad.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvParentalPinPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvParentalPinPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-062 TV shows restricted messaging then PIN pad', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(ParentalPinCopy.restrictedTitle), findsOneWidget);
    expect(find.text(ParentalPinCopy.restrictedMessage), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('pin-enter')));
    await tester.pumpAndSettle();

    expect(find.text(ParentalPinCopy.entryTitle), findsOneWidget);
    expect(find.byType(TvPinPad), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('pin-key-1')), findsOneWidget);
  });

  testWidgets('wrong PIN shows error; correct PIN unlocks', (tester) async {
    var unlocked = 0;
    await pump(
      tester,
      page: TvParentalPinPage(
        initialScreen: ParentalPinScreen.entry,
        onUnlocked: () => unlocked++,
      ),
    );

    for (final d in <String>['0', '0', '0', '0']) {
      await tester.tap(find.byKey(ValueKey<String>('pin-key-$d')));
      await tester.pumpAndSettle();
    }
    expect(find.text(ParentalPinCopy.wrongPinMessage), findsOneWidget);
    expect(unlocked, 0);

    for (final d in ParentalPinCopy.demoExpectedPin.split('')) {
      await tester.tap(find.byKey(ValueKey<String>('pin-key-$d')));
      await tester.pumpAndSettle();
    }

    expect(find.text(ParentalPinCopy.unlockedTitle), findsOneWidget);
    expect(unlocked, 1);
  });
}
