import 'package:flutter/material.dart';

import '../../../../core/accessibility/companion_accessibility.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/app_locale_scope.dart';
import '../../../../core/l10n/app_string_key.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/loading_pattern.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/status_pattern.dart';
import '../../../../core/widgets/status_pattern_copy.dart';
import '../../../../core/widgets/sync_conflict_banner.dart';
import '../../../../core/widgets/syncing_pattern.dart';
import 'companion_explore_copy.dart';
import 'companion_explore_item.dart';
import 'companion_explore_panels.dart';

/// Companion Explore showcase catalog and Send-to-TV (DSN-052 / CMP-045 / CMP-006).
///
/// Browse Featured, Live, Movies, and Favorites. Open a title for details and a
/// prominent Ember **Reproducir en TV** action. There is no local video player.
/// [surfaceState] exercises Loading, Empty, Error, Offline, Offline-cached,
/// Syncing, and Sync Conflict on this companion surface.
class CompanionExplorePage extends StatefulWidget {
  const CompanionExplorePage({
    super.key,
    this.featured = demoFeatured,
    this.live = demoLive,
    this.movies = demoMovies,
    this.favorites = const <CompanionExploreItem>[],
    this.tvName = CompanionExploreCopy.demoTvName,
    this.surfaceState = CompanionExploreSurfaceState.ready,
    this.onSendToTv,
    this.onRetry,
    this.onResolveConflict,
  });

  final List<CompanionExploreItem> featured;
  final List<CompanionExploreItem> live;
  final List<CompanionExploreItem> movies;
  final List<CompanionExploreItem> favorites;
  final String tvName;
  final CompanionExploreSurfaceState surfaceState;
  final ValueChanged<CompanionExploreItem>? onSendToTv;
  final VoidCallback? onRetry;
  final VoidCallback? onResolveConflict;

  static const List<CompanionExploreItem> demoFeatured = <CompanionExploreItem>[
    CompanionExploreItem(
      id: 'featured-1',
      title: 'Signal Night',
      subtitle: 'Featured film',
      kind: CompanionExploreKind.featured,
    ),
    CompanionExploreItem(
      id: 'featured-2',
      title: 'Cloud Series',
      subtitle: 'S1 premiere',
      kind: CompanionExploreKind.featured,
    ),
  ];

  static const List<CompanionExploreItem> demoLive = <CompanionExploreItem>[
    CompanionExploreItem(
      id: 'live-12',
      title: '12 Signal News',
      subtitle: 'Live',
      kind: CompanionExploreKind.live,
    ),
    CompanionExploreItem(
      id: 'live-24',
      title: '24 Ember Sports',
      subtitle: 'Live',
      kind: CompanionExploreKind.live,
    ),
  ];

  static const List<CompanionExploreItem> demoMovies = <CompanionExploreItem>[
    CompanionExploreItem(
      id: 'movie-1',
      title: 'Harbor Lights',
      subtitle: 'Drama',
      kind: CompanionExploreKind.movies,
    ),
    CompanionExploreItem(
      id: 'movie-2',
      title: 'Night Run',
      subtitle: 'Action',
      kind: CompanionExploreKind.movies,
    ),
  ];

  @override
  State<CompanionExplorePage> createState() => _CompanionExplorePageState();
}

class _CompanionExplorePageState extends State<CompanionExplorePage> {
  CompanionExploreItem? _selected;
  String? _sentLabel;

  AppLocale _localeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    return scope?.notifier?.locale ?? AppLocale.en;
  }

  String _t(BuildContext context, AppStringKey key) =>
      CompanionExploreCopy.forLocale(_localeOf(context), key);

  void _select(CompanionExploreItem item) {
    setState(() {
      _selected = item;
      _sentLabel = null;
    });
  }

  void _send() {
    final item = _selected;
    if (item == null) return;
    setState(() {
      _sentLabel = '${CompanionExploreCopy.sentPrefix} ${item.title}';
    });
    widget.onSendToTv?.call(item);
  }

  void _back() {
    setState(() {
      _selected = null;
      _sentLabel = null;
    });
  }

  Widget _stateBody(BuildContext context) {
    switch (widget.surfaceState) {
      case CompanionExploreSurfaceState.loading:
        return const Center(child: LoadingPattern(minHeight: AppSpacing.xxxl));
      case CompanionExploreSurfaceState.empty:
        return EmptyPattern(
          copy: StatusPatternCopy.exploreEmpty,
          onAction: widget.onRetry,
        );
      case CompanionExploreSurfaceState.error:
        return ErrorPattern(onAction: widget.onRetry);
      case CompanionExploreSurfaceState.offline:
        return OfflinePattern(onAction: widget.onRetry);
      case CompanionExploreSurfaceState.offlineCached:
        return _catalogOrDetail(context, cached: true);
      case CompanionExploreSurfaceState.syncing:
        return const Center(child: SyncingPattern(minHeight: AppSpacing.xxxl));
      case CompanionExploreSurfaceState.syncConflict:
        return SyncConflictBanner(
          message: _t(context, AppStringKey.exploreSyncConflict),
          onResolve: widget.onResolveConflict,
        );
      case CompanionExploreSurfaceState.ready:
        return _catalogOrDetail(context, cached: false);
    }
  }

  Widget _catalogOrDetail(BuildContext context, {required bool cached}) {
    final selected = _selected;
    final catalog = CompanionExploreCatalog(
      featured: widget.featured,
      live: widget.live,
      movies: widget.movies,
      favorites: widget.favorites,
      onSelect: _select,
      cachedLabels: cached,
      featuredTitle: _t(context, AppStringKey.exploreFeatured),
      liveTitle: _t(context, AppStringKey.exploreLive),
      moviesTitle: _t(context, AppStringKey.exploreMovies),
      favoritesTitle: _t(context, AppStringKey.exploreFavorites),
    );
    if (selected == null) {
      if (!cached) return catalog;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OfflineBanner(
            message: _t(context, AppStringKey.exploreOfflineCachedBanner),
            onRetry: widget.onRetry,
          ),
          const SizedBox(height: AppSpacing.md),
          catalog,
        ],
      );
    }
    return CompanionExploreDetail(
      item: selected,
      tvName: widget.tvName,
      sentLabel: _sentLabel,
      onSendToTv: _send,
      onBack: _back,
      detailTitle: _t(context, AppStringKey.exploreDetailTitle),
      sendLabel: CompanionExploreCopy.sendToTvLabel,
      noPlayerNote: _t(context, AppStringKey.exploreNoPlayerNote),
      backLabel: _t(context, AppStringKey.exploreBackToCatalog),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return CompanionAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.cloud,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.insetPageCompanion),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLockup(
                  markHeight: AppSpacing.xl,
                  tone: BrandMarkTone.companion,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  _t(context, AppStringKey.exploreTitle),
                  style: textTheme.headlineMedium?.copyWith(color: brand.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _t(context, AppStringKey.exploreBody),
                  style: textTheme.bodyLarge?.copyWith(color: brand.muted),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: SingleChildScrollView(child: _stateBody(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
