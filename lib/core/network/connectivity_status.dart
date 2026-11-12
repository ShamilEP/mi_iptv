/// Client network reachability for offline mode (TV-010 / NFR-004).
enum ConnectivityStatus {
  /// Device can reach the network / backend probe host.
  online,

  /// No usable network (or probe failed) — show Offline and use cache.
  offline,
}
