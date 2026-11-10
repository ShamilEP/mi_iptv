import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/content_card.dart';
import '../../../../core/widgets/content_row.dart';
import '../../../../core/widgets/content_row_list.dart';
import '../../../../core/widgets/status_pattern.dart';
import '../../../../core/widgets/status_pattern_copy.dart';
import 'tv_home_quick_access.dart';
import 'tv_home_surface_state.dart';

/// TV Home hi-fi shell (DSN-032 / TV-033).
///
/// Continue Watching is the first rail. Quick access exposes Live TV, Favorites,
/// Search, and Settings without a hero that pushes Live TV away. Initial focus
/// lands on the first Continue Watching card when [surfaceState] is ready.
/// Empty and offline surfaces reuse DSN-017 patterns with Home-specific copy.
class TvHomePage extends StatefulWidget {
  const TvHomePage({
    super.key,
    this.onQuickAccess,
    this.surfaceState = TvHomeSurfaceState.ready,
    this.onStatusAction,
  });

  final ValueChanged<TvHomeQuickDestination>? onQuickAccess;

  /// Ready rails, or no-sources / empty-catalog / offline panels (TV-033).
  final TvHomeSurfaceState surfaceState;

  /// Fired from empty / offline primary actions (Add source, Refresh, Try again).
  final VoidCallback? onStatusAction;

  static const continueWatchingTitle = 'Continue watching';
  static const featuredTitle = 'Featured';
  static const liveChannelsTitle = 'Live channels';

  @override
  State<TvHomePage> createState() => _TvHomePageState();
}

class _TvHomePageState extends State<TvHomePage> {
  final GlobalKey<ContentRowState> _continueRowKey = GlobalKey<ContentRowState>();

  static const _continueWatching =
      <({String title, String subtitle, double progress})>[
    (title: 'Evening news', subtitle: 'Live catch-up', progress: 0.35),
    (title: 'Series night', subtitle: 'S1 E4', progress: 0.6),
    (title: 'Film pick', subtitle: 'Almost done', progress: 0.85),
  ];

  static const _featured = <String>[
    'Featured A',
    'Featured B',
    'Featured C',
    'Featured D',
  ];

  static const _liveChannels = <String>[
    'Channel 1',
    'Channel 2',
    'Channel 3',
    'Channel 4',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.surfaceState != TvHomeSurfaceState.ready) return;
      _continueRowKey.currentState?.requestFocusAt(0);
    });
  }

  Widget _statusBody() {
    switch (widget.surfaceState) {
      case TvHomeSurfaceState.ready:
        return ContentRowList(
          rowCount: 3,
          rowBuilder: (context, rowIndex) {
            switch (rowIndex) {
              case 0:
                return ContentRow(
                  key: _continueRowKey,
                  title: TvHomePage.continueWatchingTitle,
                  storageId: 'home-continue-watching',
                  kind: ContentCardKind.continueWatching,
                  itemCount: _continueWatching.length,
                  itemBuilder: (context, index, focusNode) {
                    final item = _continueWatching[index];
                    return ContentCard(
                      kind: ContentCardKind.continueWatching,
                      title: item.title,
                      subtitle: item.subtitle,
                      progress: item.progress,
                      focusNode: focusNode,
                      onPressed: () {},
                    );
                  },
                );
              case 1:
                return ContentRow(
                  title: TvHomePage.featuredTitle,
                  storageId: 'home-featured',
                  kind: ContentCardKind.poster,
                  itemCount: _featured.length,
                  itemBuilder: (context, index, focusNode) {
                    return ContentCard(
                      kind: ContentCardKind.poster,
                      title: _featured[index],
                      focusNode: focusNode,
                      onPressed: () {},
                    );
                  },
                );
              default:
                return ContentRow(
                  title: TvHomePage.liveChannelsTitle,
                  storageId: 'home-live-channels',
                  kind: ContentCardKind.channelTile,
                  itemCount: _liveChannels.length,
                  itemBuilder: (context, index, focusNode) {
                    return ContentCard(
                      kind: ContentCardKind.channelTile,
                      title: _liveChannels[index],
                      focusNode: focusNode,
                      onPressed: () {},
                    );
                  },
                );
            }
          },
        );
      case TvHomeSurfaceState.noSources:
        return Center(
          child: EmptyPattern(
            copy: StatusPatternCopy.homeNoSources,
            icon: Iconography.sources.icon,
            onAction: widget.onStatusAction,
          ),
        );
      case TvHomeSurfaceState.emptyCatalog:
        return Center(
          child: EmptyPattern(
            copy: StatusPatternCopy.homeEmptyCatalog,
            onAction: widget.onStatusAction,
          ),
        );
      case TvHomeSurfaceState.offline:
        return Center(
          child: OfflinePattern(
            copy: StatusPatternCopy.homeOffline,
            onAction: widget.onStatusAction,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;

    return Scaffold(
      backgroundColor: brand.ink,
      body: Padding(
        padding: AppOverscan.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLockup(markHeight: 56),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: TvHomeQuickAccess(
                    onSelected: widget.onQuickAccess,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stack),
            Expanded(child: _statusBody()),
          ],
        ),
      ),
    );
  }
}
