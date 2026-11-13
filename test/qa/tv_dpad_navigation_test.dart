import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/focus/tv_focus_maps.dart';
import 'package:mi_iptv/core/widgets/stream_failure_recovery_overlay.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';
import 'package:mi_iptv/features/live_tv/presentation/tv/tv_live_tv_page.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_vod_player_page.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_copy.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_page.dart';

import 'tv_dpad_harness.dart';

void main() {
  group('QA-025 / TV-121 D-pad navigation', () {
    testWidgets('Home first focus is Continue watching card 0', (tester) async {
      expect(TvFocusMaps.home.firstFocusId, 'cw-0');

      await TvDpadHarness.pumpTv(tester, home: const TvHomePage());

      final labels = TvDpadHarness.focusedLabels();
      expect(labels, contains('Evening news'));
      expect(find.text('Evening news'), findsOneWidget);
    });

    testWidgets('Home D-pad traversal is deterministic', (tester) async {
      await TvDpadHarness.pumpTv(tester, home: const TvHomePage());
      final first = TvDpadHarness.focusedLabels();
      expect(first, contains('Evening news'));

      await TvDpadHarness.press(tester, LogicalKeyboardKey.arrowRight);
      final moved = TvDpadHarness.focusedLabels();
      expect(moved, isNot(equals(first)));

      await TvDpadHarness.press(tester, LogicalKeyboardKey.arrowLeft);
      expect(TvDpadHarness.focusedLabels(), first);

      // Fresh mount lands on the same first-focus card.
      await TvDpadHarness.pumpTv(tester, home: const TvHomePage());
      expect(TvDpadHarness.focusedLabels(), first);
    });

    testWidgets('Settings first focus lands on Account category', (
      tester,
    ) async {
      expect(TvFocusMaps.settings.firstFocusId, 'cat-account');

      await TvDpadHarness.pumpTv(tester, home: const TvSettingsPage());

      final labels = TvDpadHarness.focusedLabels();
      expect(labels, contains(TvSettingsCopy.account));
    });

    testWidgets('Live failure traps focus on recovery actions', (tester) async {
      expect(TvFocusMaps.liveTvStreamFailure.firstFocusId, 'retry');

      await TvDpadHarness.pumpTv(
        tester,
        home: const TvLiveTvPage(streamFailed: true),
      );

      expect(
        TvDpadHarness.focusedLabels(),
        contains(StreamFailureRecoveryOverlay.retryLabel),
      );
      expect(find.textContaining('12  Signal News'), findsNothing);

      // Arrows must not zap the failed channel — trap stays on overlay CTAs.
      for (var i = 0; i < 6; i++) {
        await TvDpadHarness.press(tester, LogicalKeyboardKey.arrowDown);
      }
      final afterDown = TvDpadHarness.focusedLabels();
      expect(
        afterDown.any(
          (label) =>
              label == StreamFailureRecoveryOverlay.retryLabel ||
              label == StreamFailureRecoveryOverlay.switchSourceLabel ||
              label == StreamFailureRecoveryOverlay.backToChannelsLabel,
        ),
        isTrue,
        reason: 'focus escaped overlay: $afterDown',
      );
      expect(find.text('Signal News'), findsWidgets);
      expect(find.text('Ember Sports'), findsNothing);
    });

    testWidgets('Back exits VOD player and overlay Back to channels fires', (
      tester,
    ) async {
      expect(
        TvFocusMaps.vodPlayer.backBehavior.name,
        'exitScreen',
      );
      expect(
        TvFocusMaps.liveTvStreamFailure.backBehavior.name,
        'dismissOverlay',
      );

      var exited = 0;
      await TvDpadHarness.pumpTv(
        tester,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TvVodPlayerPage(
                        onExit: () => exited++,
                      ),
                    ),
                  );
                },
                child: const Text('open-vod'),
              ),
            );
          },
        ),
      );
      await tester.tap(find.text('open-vod'));
      await tester.pumpAndSettle();
      expect(find.text(TvVodPlayerPage.demoTitle), findsOneWidget);

      await TvDpadHarness.press(tester, LogicalKeyboardKey.escape);
      expect(find.text(TvVodPlayerPage.demoTitle), findsNothing);
      expect(exited, 1);

      var backed = 0;
      await TvDpadHarness.pumpTv(
        tester,
        home: TvLiveTvPage(
          streamFailed: true,
          onBackToChannels: () => backed++,
        ),
      );
      await tester.tap(
        find.text(StreamFailureRecoveryOverlay.backToChannelsLabel),
      );
      await tester.pumpAndSettle();
      expect(backed, 1);
    });

    testWidgets('Back stack pops Settings and restores Home first focus', (
      tester,
    ) async {
      expect(TvFocusMaps.home.backBehavior.name, 'exitScreen');
      expect(TvFocusMaps.settings.backBehavior.name, 'exitScreen');
      expect(TvFocusMaps.home.restoreFocusId, 'cw-0');

      await TvDpadHarness.pumpTv(
        tester,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Column(
                children: [
                  const Expanded(child: TvHomePage()),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TvSettingsPage(),
                        ),
                      );
                    },
                    child: const Text('open-settings'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      expect(TvDpadHarness.focusedLabels(), contains('Evening news'));

      await tester.tap(find.text('open-settings'));
      await tester.pumpAndSettle();
      expect(find.byType(TvSettingsPage), findsOneWidget);
      expect(
        TvDpadHarness.focusedLabels(),
        contains(TvSettingsCopy.account),
      );

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.byType(TvSettingsPage), findsNothing);
      expect(find.byType(TvHomePage), findsOneWidget);
      expect(TvDpadHarness.focusedLabels(), contains('Evening news'));
    });

    testWidgets('Home Continue watching keeps last-focus memory', (
      tester,
    ) async {
      await TvDpadHarness.pumpTv(tester, home: const TvHomePage());
      expect(TvDpadHarness.focusedLabels(), contains('Evening news'));

      final continueRow = TvDpadHarness.contentRowState(
        tester,
        of: find.byType(TvHomePage),
      );
      expect(continueRow.lastFocusedIndex, 0);

      await TvDpadHarness.press(tester, LogicalKeyboardKey.arrowRight);
      expect(TvDpadHarness.focusedLabels(), contains('Series night'));
      expect(continueRow.lastFocusedIndex, 1);

      await TvDpadHarness.press(tester, LogicalKeyboardKey.arrowDown);
      final afterDown = TvDpadHarness.focusedLabels();
      expect(afterDown, isNot(contains('Series night')));
      expect(
        continueRow.lastFocusedIndex,
        1,
        reason: 'row must remember card 1 after focus left',
      );

      continueRow.restoreLastFocus();
      await tester.pumpAndSettle();
      expect(TvDpadHarness.focusedLabels(), contains('Series night'));
      expect(continueRow.activeIndex, 1);
    });
  });
}
