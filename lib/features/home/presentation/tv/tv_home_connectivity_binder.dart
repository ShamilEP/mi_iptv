import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/di/app_dependencies.dart';
import '../../../../core/network/connectivity_monitor.dart';
import '../../../../core/network/connectivity_status.dart';
import '../../../../core/network/offline_cache_availability.dart';
import '../../../../core/network/offline_mode_policy.dart';
import '../../../../core/persistence/local_media_store.dart';
import 'tv_home_page.dart';
import 'tv_home_quick_access.dart';
import 'tv_home_surface_state.dart';

/// Binds [ConnectivityMonitor] + local cache to [TvHomePage] surfaces (TV-010).
///
/// When [AppDependencies] is mounted (device bootstrap), uses the composition
/// root. Tests may inject [connectivity] / [localMediaStore] directly.
class TvHomeConnectivityBinder extends StatefulWidget {
  const TvHomeConnectivityBinder({
    super.key,
    this.connectivity,
    this.localMediaStore,
    this.onQuickAccess,
    this.onStatusAction,
  });

  final ConnectivityMonitor? connectivity;
  final LocalMediaStore? localMediaStore;
  final ValueChanged<TvHomeQuickDestination>? onQuickAccess;
  final VoidCallback? onStatusAction;

  @override
  State<TvHomeConnectivityBinder> createState() =>
      _TvHomeConnectivityBinderState();
}

class _TvHomeConnectivityBinderState extends State<TvHomeConnectivityBinder> {
  TvHomeSurfaceState _surface = TvHomeSurfaceState.ready;
  StreamSubscription<ConnectivityStatus>? _sub;

  ConnectivityMonitor? get _monitor {
    if (widget.connectivity != null) return widget.connectivity;
    if (AppDependencies.isMounted) {
      return AppDependencies.instance.connectivity;
    }
    return null;
  }

  LocalMediaStore? get _store {
    if (widget.localMediaStore != null) return widget.localMediaStore;
    if (AppDependencies.isMounted) {
      return AppDependencies.instance.localMediaStore;
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
    final store = _store;
    if (monitor == null || store == null) {
      if (mounted) setState(() => _surface = TvHomeSurfaceState.ready);
      return;
    }
    final hasCache =
        await OfflineCacheAvailability.hasBrowseableCache(store);
    final presentation = OfflineModePolicy.resolve(
      connectivity: monitor.current,
      hasCachedContent: hasCache,
    );
    if (!mounted) return;
    setState(() {
      switch (presentation) {
        case OfflinePresentation.online:
          _surface = TvHomeSurfaceState.ready;
        case OfflinePresentation.offlineCached:
          _surface = TvHomeSurfaceState.offlineCached;
        case OfflinePresentation.offlineEmpty:
          _surface = TvHomeSurfaceState.offline;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TvHomePage(
      surfaceState: _surface,
      onQuickAccess: widget.onQuickAccess,
      onStatusAction: widget.onStatusAction ?? () => unawaited(_refresh()),
    );
  }
}
