import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_toggle.dart';
import 'package:mi_iptv/features/history/presentation/tv/tv_history_models.dart';
import 'package:mi_iptv/features/history/presentation/tv/tv_history_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';
import 'package:mi_iptv/features/live_tv/presentation/tv/tv_epg_grid_page.dart';
import 'package:mi_iptv/features/live_tv/presentation/tv/tv_epg_models.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_track.dart';
import 'package:mi_iptv/features/player/domain/services/default_track_policy.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_track_models.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_track_selector_panel.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_vod_player_page.dart';
import 'package:mi_iptv/features/profiles/presentation/parental_pin_models.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_pin_pad.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_parental_pin_page.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_profile_models.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_profile_picker_page.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_profile_tile.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_page.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_tolerance.dart';

/// QA-053 / SRS §23 — Release 1 feature gate (provisional PRD-032 AC).
void main() {
  Future<void> pumpTv(WidgetTester tester, Widget home) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.tvDark(), home: home),
    );
    await tester.pumpAndSettle();
  }

  group('QA-053 Release 1 features', () {
    test('US-R1-07 tolerant search recovers typos locally', () {
      final catalog = TvSearchPage.demoCatalog;
      final prefixHit = TolerantSearch.query('sig', catalog);
      expect(prefixHit.matches.map((e) => e.id), contains('ch-12'));

      final typo = TolerantSearch.query('harbr', catalog);
      expect(
        typo.matches.any((e) => e.id == 'vod-1') ||
            typo.suggestions.contains('Harbor Lights') ||
            typo.didYouMean == 'Harbor Lights',
        isTrue,
      );
    });

    test('US-R1-08 MVP DefaultTrackPolicy still picks source defaults', () {
      final selection = DefaultTrackPolicy.resolve(
        audioTracks: const [
          PlaybackTrack(
            id: 'aud-en',
            kind: PlaybackTrackKind.audio,
            label: 'English',
            isDefault: true,
          ),
          PlaybackTrack(
            id: 'aud-es',
            kind: PlaybackTrackKind.audio,
            label: 'Español',
          ),
        ],
        subtitleTracks: const [
          PlaybackTrack(
            id: 'sub-off',
            kind: PlaybackTrackKind.subtitle,
            label: 'Off',
            isOff: true,
          ),
          PlaybackTrack(
            id: 'sub-en',
            kind: PlaybackTrackKind.subtitle,
            label: 'English',
          ),
        ],
      );
      expect(selection.audioTrackId, 'aud-en');
      expect(selection.subtitleTrackId, 'sub-off');
    });

    testWidgets('US-R1-01 EPG shell shows channel × time grid and Now', (
      tester,
    ) async {
      await pumpTv(tester, const TvEpgGridPage());
      expect(find.text(TvEpgCopy.title), findsOneWidget);
      expect(find.text(TvEpgCopy.nowLabel), findsWidgets);
      expect(find.byKey(const ValueKey<String>('epg-event-12-a')), findsOneWidget);
    });

    testWidgets('US-R1-04 multi-profile picker shell mounts', (tester) async {
      await pumpTv(tester, const TvProfilePickerPage());
      expect(find.text(TvProfileCopy.pickerTitle), findsOneWidget);
      expect(find.byType(TvProfileTile), findsWidgets);
      expect(find.byType(TvAddProfileTile), findsOneWidget);
    });

    testWidgets('US-R1-05 parental PIN wrong then correct path', (tester) async {
      var unlocked = 0;
      await pumpTv(
        tester,
        TvParentalPinPage(
          initialScreen: ParentalPinScreen.entry,
          onUnlocked: () => unlocked++,
        ),
      );
      expect(find.byType(TvPinPad), findsOneWidget);

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
      expect(unlocked, 1);
    });

    testWidgets('US-R1-06 History stays separate from Continue watching', (
      tester,
    ) async {
      await pumpTv(tester, const TvHistoryPage());
      expect(find.text(TvHistoryCopy.title), findsOneWidget);
      expect(find.textContaining('Continue watching'), findsOneWidget);
      expect(find.text(TvHomePage.continueWatchingTitle), findsNothing);
      expect(find.byType(MiToggle), findsOneWidget);
    });

    testWidgets('US-R1-08 track selector remembers session preference', (
      tester,
    ) async {
      TvTrackPreference? remembered;
      await pumpTv(
        tester,
        TvVodPlayerPage(
          autoHide: false,
          onPreferenceChanged: (pref) => remembered = pref,
        ),
      );
      // VOD player may need a frame before overlay keys appear.
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey<String>('vod-track-selector')));
      await tester.pumpAndSettle();
      expect(find.byType(TvTrackSelectorPanel), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey<String>('track-aud-es')));
      await tester.pumpAndSettle();
      expect(remembered?.audioTrackId, 'aud-es');
    });
  });
}
