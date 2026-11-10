import 'tv_focus_map.dart';

/// Catalog of MVP TV focus maps (DSN-040).
///
/// Each entry locks first focus, D-pad edges, Back behavior, and restore
/// targets for screens that already have hi-fi shells.
abstract final class TvFocusMaps {
  static const List<TvFocusMap> all = <TvFocusMap>[
    splash,
    onboardingAuth,
    home,
    liveTv,
    liveTvStreamFailure,
    search,
    favorites,
    settings,
    vodPlayer,
  ];

  static TvFocusMap forScreen(TvFocusScreen screen) {
    return all.firstWhere((map) => map.screen == screen);
  }

  static const TvFocusMap splash = TvFocusMap(
    screen: TvFocusScreen.splash,
    title: 'Splash / Startup',
    firstFocusId: 'brand',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'brand', label: 'Brand lockup'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(fromId: 'brand'),
    ],
    backBehavior: TvFocusBackBehavior.none,
    notes: 'Non-interactive identity hold; no D-pad destinations.',
  );

  static const TvFocusMap onboardingAuth = TvFocusMap(
    screen: TvFocusScreen.onboardingAuth,
    title: 'Onboarding / Auth',
    firstFocusId: 'primary-field',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'continue-later', label: 'Continue later'),
      TvFocusNodeSpec(id: 'primary-field', label: 'Primary OSK / field'),
      TvFocusNodeSpec(id: 'primary-action', label: 'Primary step action'),
      TvFocusNodeSpec(id: 'type-from-phone', label: 'Type from phone'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'continue-later',
        down: 'primary-field',
      ),
      TvFocusTraversal(
        fromId: 'primary-field',
        up: 'continue-later',
        down: 'primary-action',
        right: 'type-from-phone',
      ),
      TvFocusTraversal(
        fromId: 'type-from-phone',
        left: 'primary-field',
        down: 'primary-action',
      ),
      TvFocusTraversal(
        fromId: 'primary-action',
        up: 'primary-field',
      ),
    ],
    backBehavior: TvFocusBackBehavior.exitScreen,
    restoreFocusId: 'primary-field',
    notes: 'Step body shares the same map; Continue later stays in header.',
  );

  static const TvFocusMap home = TvFocusMap(
    screen: TvFocusScreen.home,
    title: 'Home',
    firstFocusId: 'cw-0',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'qa-live', label: 'Quick access Live TV'),
      TvFocusNodeSpec(id: 'qa-favorites', label: 'Quick access Favorites'),
      TvFocusNodeSpec(id: 'qa-search', label: 'Quick access Search'),
      TvFocusNodeSpec(id: 'qa-settings', label: 'Quick access Settings'),
      TvFocusNodeSpec(id: 'cw-0', label: 'Continue watching first card'),
      TvFocusNodeSpec(id: 'cw-rail', label: 'Continue watching rail'),
      TvFocusNodeSpec(id: 'featured-rail', label: 'Featured rail'),
      TvFocusNodeSpec(id: 'live-rail', label: 'Live channels rail'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'qa-live',
        right: 'qa-favorites',
        down: 'cw-0',
      ),
      TvFocusTraversal(
        fromId: 'qa-favorites',
        left: 'qa-live',
        right: 'qa-search',
        down: 'cw-0',
      ),
      TvFocusTraversal(
        fromId: 'qa-search',
        left: 'qa-favorites',
        right: 'qa-settings',
        down: 'cw-0',
      ),
      TvFocusTraversal(
        fromId: 'qa-settings',
        left: 'qa-search',
        down: 'cw-0',
      ),
      TvFocusTraversal(
        fromId: 'cw-0',
        up: 'qa-live',
        down: 'featured-rail',
        right: 'cw-rail',
      ),
      TvFocusTraversal(
        fromId: 'cw-rail',
        up: 'qa-live',
        left: 'cw-0',
        down: 'featured-rail',
      ),
      TvFocusTraversal(
        fromId: 'featured-rail',
        up: 'cw-0',
        down: 'live-rail',
      ),
      TvFocusTraversal(
        fromId: 'live-rail',
        up: 'featured-rail',
      ),
    ],
    backBehavior: TvFocusBackBehavior.exitScreen,
    restoreFocusId: 'cw-0',
    notes: 'Initial focus is first Continue watching card (DSN-032).',
  );

  static const TvFocusMap liveTv = TvFocusMap(
    screen: TvFocusScreen.liveTv,
    title: 'Live TV',
    firstFocusId: 'channel-list',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'channel-list', label: 'Channel list'),
      TvFocusNodeSpec(id: 'video-stage', label: 'Video stage'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'channel-list',
        right: 'video-stage',
        up: 'channel-list',
        down: 'channel-list',
      ),
      TvFocusTraversal(
        fromId: 'video-stage',
        left: 'channel-list',
      ),
    ],
    backBehavior: TvFocusBackBehavior.exitScreen,
    restoreFocusId: 'channel-list',
    notes: '↑/↓ zap channels while list focused; Select toggles list.',
  );

  static const TvFocusMap liveTvStreamFailure = TvFocusMap(
    screen: TvFocusScreen.liveTvStreamFailure,
    title: 'Live TV — stream failure',
    firstFocusId: 'retry',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'retry', label: 'Retry'),
      TvFocusNodeSpec(id: 'switch-source', label: 'Switch source'),
      TvFocusNodeSpec(id: 'back-to-channels', label: 'Back to channels'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'retry',
        down: 'switch-source',
      ),
      TvFocusTraversal(
        fromId: 'switch-source',
        up: 'retry',
        down: 'back-to-channels',
      ),
      TvFocusTraversal(
        fromId: 'back-to-channels',
        up: 'switch-source',
      ),
    ],
    backBehavior: TvFocusBackBehavior.dismissOverlay,
    backTargetId: 'back-to-channels',
    restoreFocusId: 'retry',
    notes: 'Channel list hidden; Back dismisses overlay to channel list.',
  );

  static const TvFocusMap search = TvFocusMap(
    screen: TvFocusScreen.search,
    title: 'Search',
    firstFocusId: 'osk',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'query-field', label: 'Query field'),
      TvFocusNodeSpec(id: 'osk', label: 'On-screen keyboard'),
      TvFocusNodeSpec(id: 'results-channels', label: 'Channels results'),
      TvFocusNodeSpec(id: 'results-vod', label: 'VOD results'),
      TvFocusNodeSpec(id: 'empty-clear', label: 'Empty Clear action'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'query-field',
        down: 'osk',
      ),
      TvFocusTraversal(
        fromId: 'osk',
        up: 'query-field',
        right: 'results-channels',
        down: 'results-channels',
      ),
      TvFocusTraversal(
        fromId: 'results-channels',
        left: 'osk',
        up: 'osk',
        down: 'results-vod',
      ),
      TvFocusTraversal(
        fromId: 'results-vod',
        left: 'osk',
        up: 'results-channels',
      ),
      TvFocusTraversal(
        fromId: 'empty-clear',
        up: 'osk',
        left: 'osk',
      ),
    ],
    backBehavior: TvFocusBackBehavior.exitScreen,
    restoreFocusId: 'osk',
    notes: 'Empty state swaps results for Clear; OSK remains left column.',
  );

  static const TvFocusMap favorites = TvFocusMap(
    screen: TvFocusScreen.favorites,
    title: 'Favorites',
    firstFocusId: 'open-first',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'open-first', label: 'Open first favorite'),
      TvFocusNodeSpec(id: 'remove-first', label: 'Remove first favorite'),
      TvFocusNodeSpec(id: 'channels-group', label: 'Channels group'),
      TvFocusNodeSpec(id: 'vod-group', label: 'VOD group'),
      TvFocusNodeSpec(id: 'empty-browse', label: 'Browse catalog'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'open-first',
        right: 'remove-first',
        down: 'vod-group',
      ),
      TvFocusTraversal(
        fromId: 'remove-first',
        left: 'open-first',
        down: 'vod-group',
      ),
      TvFocusTraversal(
        fromId: 'channels-group',
        down: 'vod-group',
        right: 'open-first',
      ),
      TvFocusTraversal(
        fromId: 'vod-group',
        up: 'channels-group',
      ),
      TvFocusTraversal(
        fromId: 'empty-browse',
      ),
    ],
    backBehavior: TvFocusBackBehavior.exitScreen,
    restoreFocusId: 'open-first',
    notes: 'Channels above VOD; Open/Remove are row quick actions (DSN-036).',
  );

  static const TvFocusMap settings = TvFocusMap(
    screen: TvFocusScreen.settings,
    title: 'Settings',
    firstFocusId: 'cat-account',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'cat-account', label: 'Category Account'),
      TvFocusNodeSpec(id: 'cat-sources', label: 'Category Sources'),
      TvFocusNodeSpec(id: 'cat-network', label: 'Category Network'),
      TvFocusNodeSpec(id: 'cat-language', label: 'Category Language'),
      TvFocusNodeSpec(id: 'cat-playback', label: 'Category Playback'),
      TvFocusNodeSpec(id: 'detail-values', label: 'Detail current values'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'cat-account',
        down: 'cat-sources',
        right: 'detail-values',
      ),
      TvFocusTraversal(
        fromId: 'cat-sources',
        up: 'cat-account',
        down: 'cat-network',
        right: 'detail-values',
      ),
      TvFocusTraversal(
        fromId: 'cat-network',
        up: 'cat-sources',
        down: 'cat-language',
        right: 'detail-values',
      ),
      TvFocusTraversal(
        fromId: 'cat-language',
        up: 'cat-network',
        down: 'cat-playback',
        right: 'detail-values',
      ),
      TvFocusTraversal(
        fromId: 'cat-playback',
        up: 'cat-language',
        right: 'detail-values',
      ),
      TvFocusTraversal(
        fromId: 'detail-values',
        left: 'cat-account',
      ),
    ],
    backBehavior: TvFocusBackBehavior.exitScreen,
    restoreFocusId: 'cat-account',
    notes: 'Left rail owns hierarchy; detail is read-only values in the shell.',
  );

  static const TvFocusMap vodPlayer = TvFocusMap(
    screen: TvFocusScreen.vodPlayer,
    title: 'VOD player',
    firstFocusId: 'play-pause',
    nodes: <TvFocusNodeSpec>[
      TvFocusNodeSpec(id: 'play-pause', label: 'Play / Pause'),
      TvFocusNodeSpec(id: 'seek-back', label: 'Seek back 10s'),
      TvFocusNodeSpec(id: 'seek-forward', label: 'Seek forward 10s'),
      TvFocusNodeSpec(id: 'volume-down', label: 'Volume down'),
      TvFocusNodeSpec(id: 'mute', label: 'Mute'),
      TvFocusNodeSpec(id: 'volume-up', label: 'Volume up'),
    ],
    traversals: <TvFocusTraversal>[
      TvFocusTraversal(
        fromId: 'play-pause',
        down: 'seek-back',
      ),
      TvFocusTraversal(
        fromId: 'seek-back',
        up: 'play-pause',
        right: 'seek-forward',
        down: 'volume-down',
      ),
      TvFocusTraversal(
        fromId: 'seek-forward',
        up: 'play-pause',
        left: 'seek-back',
        down: 'mute',
      ),
      TvFocusTraversal(
        fromId: 'volume-down',
        up: 'seek-back',
        right: 'mute',
      ),
      TvFocusTraversal(
        fromId: 'mute',
        up: 'seek-forward',
        left: 'volume-down',
        right: 'volume-up',
      ),
      TvFocusTraversal(
        fromId: 'volume-up',
        up: 'seek-forward',
        left: 'mute',
      ),
    ],
    backBehavior: TvFocusBackBehavior.exitScreen,
    restoreFocusId: 'play-pause',
    notes:
        'Hidden chrome re-shows on any D-pad; primary action stays uncovered.',
  );
}
