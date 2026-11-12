import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/platform/companion_platform.dart';
import 'package:mi_iptv/core/widgets/control_chrome.dart';
import 'package:mi_iptv/core/widgets/mi_button.dart';
import 'package:mi_iptv/core/widgets/mi_text_field.dart';
import 'package:mi_iptv/features/auth/presentation/companion/companion_login_pairing_copy.dart';
import 'package:mi_iptv/features/auth/presentation/companion/companion_login_pairing_page.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_copy.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_item.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_copy.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_page.dart';

import 'companion_touch_harness.dart';

void main() {
  const hosts = <TargetPlatform>[
    TargetPlatform.android,
    TargetPlatform.iOS,
  ];

  for (final host in hosts) {
    final label = CompanionPlatformResolver.resolve(host).name;

    group('QA-026 Companion touch ($label)', () {
      testWidgets('pairing: login reveals linked TVs', (tester) async {
        await CompanionTouchHarness.withPlatform(host, () async {
          String? signedIn;
          await CompanionTouchHarness.pumpCompanion(
            tester,
            home: CompanionLoginPairingPage(
              onSignedIn: (email) => signedIn = email,
            ),
          );

          await tester.enterText(
            find.widgetWithText(
              MiTextField,
              CompanionLoginPairingCopy.emailLabel,
            ),
            'ada@example.com',
          );
          await tester.enterText(
            find.widgetWithText(
              MiTextField,
              CompanionLoginPairingCopy.passwordLabel,
            ),
            'secret',
          );
          await tester.tap(find.text(CompanionLoginPairingCopy.logInLabel));
          await tester.pump();

          expect(signedIn, 'ada@example.com');
          expect(
            find.text(CompanionLoginPairingCopy.linkedTvsTitle),
            findsOneWidget,
          );
          expect(find.text('Living room'), findsOneWidget);
          expect(
            find.text(CompanionLoginPairingCopy.connectedLabel),
            findsOneWidget,
          );
        });
      });

      testWidgets('remote: touch D-pad Up fires command', (tester) async {
        await CompanionTouchHarness.withPlatform(host, () async {
          CompanionRemoteCommand? command;
          await CompanionTouchHarness.pumpCompanion(
            tester,
            home: CompanionRemotePage(
              onFeedback: () async {},
              onCommand: (value) => command = value,
            ),
          );

          await tester.tap(find.byKey(const ValueKey('remote-key-Up')));
          await tester.pump();

          expect(command, CompanionRemoteCommand.up);
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('remote-feedback')),
              matching: find.text('Up'),
            ),
            findsOneWidget,
          );
        });
      });

      testWidgets('send-to-TV: tap title then Reproducir en TV', (tester) async {
        await CompanionTouchHarness.withPlatform(host, () async {
          CompanionExploreItem? sent;
          await CompanionTouchHarness.pumpCompanion(
            tester,
            home: CompanionExplorePage(onSendToTv: (item) => sent = item),
          );

          await tester.tap(find.byKey(const ValueKey('explore-featured-1')));
          await tester.pumpAndSettle();

          expect(find.text(CompanionExploreCopy.noPlayerNote), findsOneWidget);
          expect(find.byIcon(Icons.play_circle_outline), findsNothing);

          final button = tester.widget<MiButton>(
            find.widgetWithText(MiButton, CompanionExploreCopy.sendToTvLabel),
          );
          expect(button.emphasis, ControlEmphasis.sendToTv);

          await tester.tap(find.text(CompanionExploreCopy.sendToTvLabel));
          await tester.pump();

          expect(sent?.id, 'featured-1');
          expect(
            find.text('${CompanionExploreCopy.sentPrefix} Signal Night'),
            findsOneWidget,
          );
        });
      });
    });
  }
}
