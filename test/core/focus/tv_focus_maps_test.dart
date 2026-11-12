import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/focus/tv_focus_map.dart';
import 'package:mi_iptv/core/focus/tv_focus_maps.dart';

void main() {
  group('TvFocusMaps DSN-040', () {
    test('covers every TvFocusScreen exactly once', () {
      expect(
        TvFocusMaps.all.map((m) => m.screen).toSet(),
        TvFocusScreen.values.toSet(),
      );
      expect(TvFocusMaps.all.length, TvFocusScreen.values.length);
    });

    test('every map is internally consistent', () {
      for (final map in TvFocusMaps.all) {
        expect(map.isConsistent, isTrue, reason: map.title);
        expect(map.nodes, isNotEmpty, reason: map.title);
        expect(map.firstFocus.id, map.firstFocusId);
      }
    });

    test('Home first focus is Continue watching card 0', () {
      final home = TvFocusMaps.home;
      expect(home.firstFocusId, 'cw-0');
      expect(home.restoreFocusId, 'cw-0');
      expect(home.backBehavior, TvFocusBackBehavior.exitScreen);
      expect(home.traversalFor('cw-0')?.up, 'qa-live');
      expect(home.traversalFor('cw-0')?.down, 'featured-rail');
    });

    test('Live TV failure Back dismisses to channels with Retry first', () {
      final failure = TvFocusMaps.liveTvStreamFailure;
      expect(failure.firstFocusId, 'retry');
      expect(failure.backBehavior, TvFocusBackBehavior.dismissOverlay);
      expect(failure.backTargetId, 'back-to-channels');
      expect(failure.traversalFor('retry')?.down, 'switch-source');
    });

    test('Settings rail starts on Account with detail to the right', () {
      final settings = TvFocusMaps.settings;
      expect(settings.firstFocusId, 'cat-account');
      expect(settings.traversalFor('cat-account')?.right, 'detail-values');
      expect(settings.traversalFor('detail-values')?.left, 'cat-account');
    });

    test('Splash has no Back and no directional escapes', () {
      final splash = TvFocusMaps.splash;
      expect(splash.backBehavior, TvFocusBackBehavior.none);
      final edge = splash.traversalFor('brand');
      expect(edge?.up, isNull);
      expect(edge?.down, isNull);
      expect(edge?.left, isNull);
      expect(edge?.right, isNull);
    });

    test('VOD primary action is first focus and restore target', () {
      final vod = TvFocusMaps.vodPlayer;
      expect(vod.firstFocusId, 'play-pause');
      expect(vod.restoreFocusId, 'play-pause');
      expect(vod.traversalFor('play-pause')?.down, 'seek-back');
    });

    test('forScreen resolves catalog entries', () {
      expect(
        TvFocusMaps.forScreen(TvFocusScreen.search).title,
        'Search',
      );
    });

    test('Favorites first focus is Open on the first row', () {
      final favorites = TvFocusMaps.favorites;
      expect(favorites.firstFocusId, 'open-first');
      expect(favorites.restoreFocusId, 'open-first');
      expect(favorites.traversalFor('open-first')?.right, 'remove-first');
      expect(favorites.traversalFor('channels-group')?.down, 'vod-group');
    });

    test('Content detail first focus is Play with Related below', () {
      final detail = TvFocusMaps.contentDetail;
      expect(detail.firstFocusId, 'play');
      expect(detail.restoreFocusId, 'play');
      expect(detail.traversalFor('play')?.right, 'resume');
      expect(detail.traversalFor('play')?.down, 'related-0');
      expect(detail.traversalFor('favorite')?.left, 'resume');
    });
  });
}
