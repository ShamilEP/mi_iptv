import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/accessibility/companion_accessibility.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_text_field.dart';
import 'package:mi_iptv/features/auth/presentation/companion/companion_login_pairing_copy.dart';
import 'package:mi_iptv/features/auth/presentation/companion/companion_login_pairing_page.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_copy.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_page.dart';

void main() {
  group('CompanionAccessibility', () {
    test('clamps Dynamic Type into 1.0–2.0', () {
      final low = CompanionAccessibility.clampTextScaler(
        const TextScaler.linear(0.5),
      );
      final high = CompanionAccessibility.clampTextScaler(
        const TextScaler.linear(3.0),
      );
      final mid = CompanionAccessibility.clampTextScaler(
        const TextScaler.linear(1.5),
      );

      expect(low.scale(10), 10);
      expect(high.scale(10), 20);
      expect(mid.scale(10), 15);
    });

    test('companion contrast pairs meet WCAG AA', () {
      expect(CompanionAccessibility.companionContrastPassesAa(), isTrue);
      for (final check in CompanionAccessibility.contrastChecks) {
        expect(
          ColorContrast.meetsWcagAa(check.foreground, check.background),
          isTrue,
          reason: check.role,
        );
      }
    });
  });

  testWidgets('MiTextField exposes TalkBack label for email and password', (
    tester,
  ) async {
    final email = TextEditingController();
    final password = TextEditingController();
    addTearDown(email.dispose);
    addTearDown(password.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: Scaffold(
          body: CompanionAccessibleScope(
            child: Column(
              children: [
                MiTextField(
                  controller: email,
                  label: CompanionLoginPairingCopy.emailLabel,
                ),
                MiTextField(
                  controller: password,
                  label: CompanionLoginPairingCopy.passwordLabel,
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(
      find.bySemanticsLabel(CompanionLoginPairingCopy.emailLabel),
      findsWidgets,
    );
    expect(
      find.bySemanticsLabel(CompanionLoginPairingCopy.passwordLabel),
      findsWidgets,
    );
  });

  testWidgets('linked TVs expose Connected / Offline labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: const CompanionLoginPairingPage(
          initialStep: CompanionLoginPairingStep.linkedTvs,
        ),
      ),
    );
    await tester.pump();

    expect(find.text(CompanionLoginPairingCopy.connectedLabel), findsOneWidget);
    expect(find.text(CompanionLoginPairingCopy.offlineLabel), findsOneWidget);
  });

  testWidgets('remote keys keep button semantics at large text scale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: MaterialApp(
          theme: AppTheme.companionLight(),
          home: CompanionRemotePage(onFeedback: () async {}),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(CompanionRemoteCopy.title), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
    expect(find.text(CompanionRemoteCopy.sendLabel), findsOneWidget);
    expect(
      tester.getSemantics(find.text('OK')).hasFlag(SemanticsFlag.isButton),
      isTrue,
    );

    final scope = tester.widget<MediaQuery>(
      find
          .descendant(
            of: find.byType(CompanionAccessibleScope),
            matching: find.byType(MediaQuery),
          )
          .first,
    );
    expect(scope.data.textScaler.scale(10), 18);
  });

  testWidgets('Explore honors clamped text scale without crashing', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.5)),
        child: MaterialApp(
          theme: AppTheme.companionLight(),
          home: const CompanionExplorePage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Signal Night'), findsOneWidget);

    final scope = tester.widget<MediaQuery>(
      find
          .descendant(
            of: find.byType(CompanionAccessibleScope),
            matching: find.byType(MediaQuery),
          )
          .first,
    );
    // 2.5× OS scale clamps to 2.0×.
    expect(scope.data.textScaler.scale(10), 20);
  });
}
