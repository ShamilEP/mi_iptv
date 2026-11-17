import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/devices/domain/entities/pairing_secure_data.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_pairing_code_page.dart';
import 'package:mi_iptv/features/devices/presentation/pairing_code_models.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_hero.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_personalized_models.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_personalized_home_page.dart';

/// QA-055 / SRS §23 — Release 2 feature gate (provisional PRD-033 AC).
void main() {
  Future<void> pumpTv(WidgetTester tester, Widget home) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.tvDark(), home: home),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpCompanion(WidgetTester tester, Widget home) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.companionLight(), home: home),
    );
    await tester.pumpAndSettle();
  }

  group('QA-055 Release 2 features', () {
    testWidgets('US-R2-01 personalization keeps Live TV above compact hero', (
      tester,
    ) async {
      await pumpTv(tester, const TvPersonalizedHomePage());

      expect(find.byType(TvHomeHero), findsOneWidget);
      expect(find.text(Iconography.liveTv.label), findsOneWidget);
      expect(find.text(TvHomePage.continueWatchingTitle), findsOneWidget);
      expect(
        find.text(TvHomePersonalizedCopy.recommendedForYou),
        findsOneWidget,
      );
      expect(
        find.textContaining(TvHomePersonalizedCopy.becauseYouWatchedPrefix),
        findsOneWidget,
      );

      final liveTvY = tester.getTopLeft(find.text(Iconography.liveTv.label)).dy;
      final heroY = tester.getTopLeft(find.byType(TvHomeHero)).dy;
      expect(liveTvY, lessThan(heroY));
    });

    testWidgets('US-R2-01 recommendation selection fires', (tester) async {
      String? picked;
      await pumpTv(
        tester,
        TvPersonalizedHomePage(
          onRecommendationSelected: (title) => picked = title,
        ),
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('home-rec-because-harbor-0')),
      );
      await tester.pumpAndSettle();
      expect(picked, isNotNull);
      expect(picked, isNotEmpty);
    });

    testWidgets('US-R2-02 wrong pairing code does not leak expected digits', (
      tester,
    ) async {
      await pumpCompanion(tester, const CompanionPairingCodePage());

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
      expect(find.textContaining(PairingCodeCopy.demoExpectedCode), findsNothing);
      expect(
        find.textContaining(PairingCodeCopy.formatDisplay(
          PairingCodeCopy.demoExpectedCode,
        )),
        findsNothing,
      );

      final field = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const ValueKey<String>('pairing-companion-field')),
          matching: find.byType(TextField),
        ),
      );
      expect(field.controller?.text ?? '', isEmpty);
    });

    testWidgets('US-R2-02 matching pairing code reaches linked state', (
      tester,
    ) async {
      var linked = 0;
      await pumpCompanion(
        tester,
        CompanionPairingCodePage(onLinked: () => linked++),
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

    test('US-R2-02 pairing shell sources never print the demo code', () {
      final roots = [
        File('lib/features/devices/presentation/pairing_code_models.dart'),
        File(
          'lib/features/devices/presentation/tv/tv_pairing_code_page.dart',
        ),
        File(
          'lib/features/devices/presentation/companion/companion_pairing_code_page.dart',
        ),
      ];
      for (final file in roots) {
        expect(file.existsSync(), isTrue, reason: file.path);
        final src = file.readAsStringSync();
        expect(src.contains('debugPrint'), isFalse, reason: file.path);
        expect(RegExp(r'\bprint\s*\(').hasMatch(src), isFalse, reason: file.path);
      }

      final design = File('docs/design/pairing_code.md').readAsStringSync();
      expect(design, contains('never logged'));
    });

    test('US-R2-02 PairingSecureData toString redacts session secret', () {
      const data = PairingSecureData(
        linkedTvDeviceId: 'tv-1',
        sessionSecret: 'super-secret-pairing-token',
      );
      final text = data.toString();
      expect(text, contains('tv-1'));
      expect(text, contains('***'));
      expect(text.contains('super-secret-pairing-token'), isFalse);
    });
  });
}
