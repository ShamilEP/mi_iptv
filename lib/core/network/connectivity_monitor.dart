import 'connectivity_status.dart';

/// Port for network / backend reachability (TV-010).
///
/// Presentation and use cases depend on this contract only — never on a
/// concrete plugin. Device bootstrap mounts a polling probe; tests use
/// [MemoryConnectivityMonitor].
abstract interface class ConnectivityMonitor {
  ConnectivityStatus get current;

  Stream<ConnectivityStatus> get onStatusChanged;

  /// Starts listening / polling. Idempotent.
  Future<void> start();

  /// Stops listeners. Safe to call when not started.
  Future<void> stop();
}
