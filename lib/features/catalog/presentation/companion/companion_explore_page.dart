import 'package:flutter/material.dart';

import '../../../../core/accessibility/companion_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/loading_pattern.dart';
import '../../../../core/widgets/status_pattern.dart';
import '../../../../core/widgets/status_pattern_copy.dart';
import '../../../../core/widgets/sync_conflict_banner.dart';
import '../../../../core/widgets/syncing_pattern.dart';
import 'companion_explore_copy.dart';
import 'companion_explore_item.dart';
import 'companion_explore_panels.dart';

/// Companion Explore showcase catalog and Send-to-TV (DSN-052 / CMP-045).
///
/// Browse Featured, Live, and Movies. Open a title for details and a
/// prominent Ember **Reproducir en TV** action. There is no local video player.
/// [surfaceState] exercises Loading, Empty, Error, Offline, Syncing, and
/// Sync Conflict on this companion surface.
class CompanionExplorePage extends StatefulWidget {
  const CompanionExplorePage({
    super.key,
    this.featured = demoFeatured,
    this.live = demoLive,
    this.movies = demoMovies,
    this.tvName = CompanionExploreCopy.demoTvName,
    this.surfaceState = CompanionExploreSurfaceState.ready,
    this.onSendToTv,
    this.onRetry,
    this.onResolveConflict,
  });

  final List<CompanionExploreItem> featured;
  final List<CompanionExploreItem> live;
  final List<CompanionExploreItem> movies;
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
      case CompanionExploreSurfaceState.syncing:
        return const Center(child: SyncingPattern(minHeight: AppSpacing.xxxl));
      case CompanionExploreSurfaceState.syncConflict:
        return SyncConflictBanner(
          message: CompanionExploreCopy.syncConflictMessage,
          onResolve: widget.onResolveConflict,
        );
      case CompanionExploreSurfaceState.ready:
        final selected = _selected;
        if (selected == null) {
          return CompanionExploreCatalog(
            featured: widget.featured,
            live: widget.live,
            movies: widget.movies,
            onSelect: _select,
          );
        }
        return CompanionExploreDetail(
          item: selected,
          tvName: widget.tvName,
          sentLabel: _sentLabel,
          onSendToTv: _send,
          onBack: _back,
        );
    }
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
                  CompanionExploreCopy.title,
                  style: textTheme.headlineMedium?.copyWith(color: brand.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  CompanionExploreCopy.body,
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
