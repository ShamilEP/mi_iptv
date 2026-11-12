import '../persistence/local_media_store.dart';
import 'connectivity_monitor.dart';
import 'connectivity_status.dart';
import 'offline_cache_availability.dart';
import 'offline_mode_policy.dart';

/// Resolves offline presentation from live connectivity + local cache (TV-010).
final class OfflineModeResolver {
  const OfflineModeResolver({
    required this.connectivity,
    required this.localMediaStore,
  });

  final ConnectivityMonitor connectivity;
  final LocalMediaStore localMediaStore;

  Future<OfflinePresentation> resolve() async {
    final hasCache =
        await OfflineCacheAvailability.hasBrowseableCache(localMediaStore);
    return OfflineModePolicy.resolve(
      connectivity: connectivity.current,
      hasCachedContent: hasCache,
    );
  }
}

/// Maps [OfflinePresentation] onto Home surface states.
OfflinePresentation offlinePresentationForHome(
  ConnectivityStatus status, {
  required bool hasCachedContent,
}) {
  return OfflineModePolicy.resolve(
    connectivity: status,
    hasCachedContent: hasCachedContent,
  );
}
