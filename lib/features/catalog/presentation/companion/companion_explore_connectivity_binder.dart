import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/di/app_dependencies.dart';
import '../../../../core/network/connectivity_monitor.dart';
import '../../../../core/network/connectivity_status.dart';
import '../../../../core/network/offline_mode_policy.dart';
import '../../../devices/domain/entities/linked_tv_snapshot.dart';
import '../../../sync/domain/entities/favorite_entry.dart';
import '../../../sync/domain/entities/sync_metadata.dart';
import '../../domain/entities/companion_cached_browse.dart';
import '../../domain/entities/content_item.dart';
import '../../domain/services/companion_local_cache.dart';
import 'companion_explore_copy.dart';
import 'companion_explore_from_cache.dart';
import 'companion_explore_item.dart';
import 'companion_explore_page.dart';

/// Binds connectivity + local cache to Companion Explore (CMP-006 / NFR-011).
///
/// Clears offline / empty / error surfaces when the network returns or the
/// user taps retry after cache is available.
class CompanionExploreConnectivityBinder extends StatefulWidget {
  const CompanionExploreConnectivityBinder({
    super.key,
    this.connectivity,
    this.localCache,
    this.onSendToTv,
    this.onRetry,
    this.onResolveConflict,
  });

  final ConnectivityMonitor? connectivity;
  final CompanionLocalCache? localCache;
  final ValueChanged<CompanionExploreItem>? onSendToTv;
  final VoidCallback? onRetry;
  final VoidCallback? onResolveConflict;

  @override
  State<CompanionExploreConnectivityBinder> createState() =>
      _CompanionExploreConnectivityBinderState();
}

class _CompanionExploreConnectivityBinderState
    extends State<CompanionExploreConnectivityBinder> {
  CompanionExploreSurfaceState _surface = CompanionExploreSurfaceState.loading;
  List<CompanionExploreItem> _featured = CompanionExplorePage.demoFeatured;
  List<CompanionExploreItem> _live = CompanionExplorePage.demoLive;
  List<CompanionExploreItem> _movies = CompanionExplorePage.demoMovies;
  List<CompanionExploreItem> _favorites = const <CompanionExploreItem>[];
  String _tvName = CompanionExploreCopy.demoTvName;
  StreamSubscription<ConnectivityStatus>? _sub;

  ConnectivityMonitor? get _monitor {
    if (widget.connectivity != null) return widget.connectivity;
    if (AppDependencies.isMounted) {
      return AppDependencies.instance.connectivity;
    }
    return null;
  }

  CompanionLocalCache? get _cache {
    if (widget.localCache != null) return widget.localCache;
    if (AppDependencies.isMounted) {
      return AppDependencies.instance.companionLocalCache;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
    final monitor = _monitor;
    if (monitor != null) {
      _sub = monitor.onStatusChanged.listen((_) {
        unawaited(_refresh());
      });
    }
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel() ?? Future<void>.value());
    super.dispose();
  }

  Future<void> _refresh() async {
    final monitor = _monitor;
    final cache = _cache;
    if (monitor == null || cache == null) {
      if (mounted) {
        setState(() => _surface = CompanionExploreSurfaceState.ready);
      }
      return;
    }

    var browse = await cache.loadBrowse();
    if (monitor.current == ConnectivityStatus.online && browse.isEmpty) {
      await _seedDemoCache(cache);
      browse = await cache.loadBrowse();
    }

    final presentation = OfflineModePolicy.resolve(
      connectivity: monitor.current,
      hasCachedContent: browse.hasCatalog || browse.hasFavorites,
    );

    if (!mounted) return;
    setState(() {
      _applyBrowse(
        browse,
        preferCache: presentation != OfflinePresentation.online,
      );
      switch (presentation) {
        case OfflinePresentation.online:
          _surface = CompanionExploreSurfaceState.ready;
        case OfflinePresentation.offlineCached:
          _surface = CompanionExploreSurfaceState.offlineCached;
        case OfflinePresentation.offlineEmpty:
          _surface = CompanionExploreSurfaceState.offline;
      }
    });
  }

  /// Persists showcase catalog / favorites / TV name so offline mode has data.
  Future<void> _seedDemoCache(CompanionLocalCache cache) {
    return Future.wait(<Future<void>>[
      cache.saveCatalog(
        channels: const <ContentItem>[
          ContentItem(
            contentId: 'live-12',
            type: ContentType.channel,
            title: '12 Signal News',
          ),
          ContentItem(
            contentId: 'live-24',
            type: ContentType.channel,
            title: '24 Ember Sports',
          ),
        ],
        vod: const <ContentItem>[
          ContentItem(
            contentId: 'featured-1',
            type: ContentType.vodMovie,
            title: 'Signal Night',
            genres: <String>['Featured film'],
          ),
          ContentItem(
            contentId: 'movie-1',
            type: ContentType.vodMovie,
            title: 'Harbor Lights',
            genres: <String>['Drama'],
          ),
          ContentItem(
            contentId: 'movie-2',
            type: ContentType.vodMovie,
            title: 'Night Run',
            genres: <String>['Action'],
          ),
        ],
      ),
      cache.saveFavorites(<FavoriteEntry>[
        FavoriteEntry(
          contentId: 'movie-1',
          contentType: ContentType.vodMovie,
          title: 'Harbor Lights',
          order: 0,
          sync: SyncMetadata(
            syncVersion: 1,
            updatedAtServer: DateTime.utc(2026, 1, 1),
          ),
        ),
      ]),
      cache.saveLinkedTv(
        LinkedTvSnapshot(
          deviceId: 'demo-living-room',
          displayName: CompanionExploreCopy.demoTvName,
          lastKnownOnline: true,
          updatedAt: DateTime.now().toUtc(),
        ),
      ),
    ]);
  }

  void _applyBrowse(CompanionCachedBrowse browse, {required bool preferCache}) {
    final live = CompanionExploreFromCache.live(browse);
    final movies = CompanionExploreFromCache.movies(browse);
    final featured = CompanionExploreFromCache.featured(browse);
    final favorites = CompanionExploreFromCache.favorites(browse);
    final useCache =
        preferCache && (live.isNotEmpty || movies.isNotEmpty || favorites.isNotEmpty);

    if (useCache || (browse.hasCatalog || browse.hasFavorites)) {
      if (featured.isNotEmpty) _featured = featured;
      if (live.isNotEmpty) _live = live;
      if (movies.isNotEmpty) _movies = movies;
      _favorites = favorites;
    } else if (!preferCache) {
      _featured = CompanionExplorePage.demoFeatured;
      _live = CompanionExplorePage.demoLive;
      _movies = CompanionExplorePage.demoMovies;
      _favorites = favorites;
    }

    final tv = browse.linkedTv;
    if (tv != null) {
      _tvName = tv.displayName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompanionExplorePage(
      featured: _featured,
      live: _live,
      movies: _movies,
      favorites: _favorites,
      tvName: _tvName,
      surfaceState: _surface,
      onSendToTv: widget.onSendToTv,
      onRetry: widget.onRetry ?? () => unawaited(_refresh()),
      onResolveConflict: widget.onResolveConflict,
    );
  }
}
