import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/brand_lockup.dart';
import 'package:mi_iptv/core/widgets/mi_text_field.dart';
import 'package:mi_iptv/features/auth/presentation/companion/companion_linked_tv.dart';
import 'package:mi_iptv/features/auth/presentation/companion/companion_login_pairing_copy.dart';
import 'package:mi_iptv/features/auth/presentation/companion/companion_login_pairing_page.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    CompanionLoginPairingPage? page,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? const CompanionLoginPairingPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-050 login asks for the account email and password', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(CompanionLoginPairingCopy.signInTitle), findsOneWidget);
    expect(find.text(CompanionLoginPairingCopy.emailLabel), findsOneWidget);
    expect(find.text(CompanionLoginPairingCopy.passwordLabel), findsOneWidget);
    expect(find.text(CompanionLoginPairingCopy.logInLabel), findsOneWidget);
    expect(find.text(BrandAssets.wordmarkText), findsOneWidget);
    expect(find.byType(BrandLockup), findsOneWidget);
  });

  testWidgets('empty login stays on the sign-in screen', (tester) async {
    await pump(tester);

    await tester.tap(find.text(CompanionLoginPairingCopy.logInLabel));
    await tester.pump();

    expect(
      find.text(CompanionLoginPairingCopy.missingCredentialsMessage),
      findsOneWidget,
    );
    expect(find.text(CompanionLoginPairingCopy.linkedTvsTitle), findsNothing);
  });

  testWidgets('login reveals linked TVs and connection states', (tester) async {
    String? signedIn;
    await pump(
      tester,
      page: CompanionLoginPairingPage(onSignedIn: (email) => signedIn = email),
    );

    await tester.enterText(
      find.widgetWithText(MiTextField, CompanionLoginPairingCopy.emailLabel),
      'ada@example.com',
    );
    await tester.enterText(
      find.widgetWithText(MiTextField, CompanionLoginPairingCopy.passwordLabel),
      'secret',
    );
    await tester.tap(find.text(CompanionLoginPairingCopy.logInLabel));
    await tester.pump();

    expect(signedIn, 'ada@example.com');
    expect(find.text('ada@example.com'), findsWidgets);
    expect(find.text('Living room'), findsOneWidget);
    expect(find.text('Bedroom'), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Devices'), findsOneWidget);
  });

  testWidgets('linked TV screen keeps an empty list explicit', (tester) async {
    await pump(
      tester,
      page: const CompanionLoginPairingPage(
        initialStep: CompanionLoginPairingStep.linkedTvs,
        linkedTvs: <CompanionLinkedTv>[],
        accountEmail: 'ada@example.com',
      ),
    );

    expect(find.text('ada@example.com'), findsOneWidget);
    expect(
      find.text(CompanionLoginPairingCopy.emptyTvsMessage),
      findsOneWidget,
    );
    expect(find.text('Connected'), findsNothing);
  });
}
