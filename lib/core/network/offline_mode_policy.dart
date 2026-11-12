import 'connectivity_status.dart';

/// How the TV client should present offline mode (TV-010).
enum OfflinePresentation {
  /// Network OK — normal surfaces.
  online,

  /// Offline with a usable local cache — banner + cached rails.
  offlineCached,

  /// Offline with no cache — full Offline pattern.
  offlineEmpty,
}

/// Pure policy: connectivity + whether [LocalMediaStore] has browseable rows.
abstract final class OfflineModePolicy {
  static OfflinePresentation resolve({
    required ConnectivityStatus connectivity,
    required bool hasCachedContent,
  }) {
    if (connectivity == ConnectivityStatus.online) {
      return OfflinePresentation.online;
    }
    return hasCachedContent
        ? OfflinePresentation.offlineCached
        : OfflinePresentation.offlineEmpty;
  }
}
