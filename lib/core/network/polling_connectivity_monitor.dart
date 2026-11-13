import 'dart:async';

import 'connectivity_monitor.dart';
import 'connectivity_probe.dart';
import 'connectivity_status.dart';

/// Polls a [ConnectivityProbe] on an interval (TV-010 / QA-039).
///
/// Prefer this over adding `connectivity_plus` until a plugin is approved.
/// Probe calls are hard-capped by [probeTimeout] so airplane mode and
/// backend-down cannot block the UI thread or bootstrap forever.
final class PollingConnectivityMonitor implements ConnectivityMonitor {
  PollingConnectivityMonitor({
    ConnectivityProbe? probe,
    this.interval = const Duration(seconds: 5),
    this.probeTimeout = DnsLookupConnectivityProbe.defaultTimeout,
    ConnectivityStatus initial = ConnectivityStatus.online,
  })  : _probe = probe ?? const DnsLookupConnectivityProbe(),
        _current = initial;

  final ConnectivityProbe _probe;
  final Duration interval;

  /// Hard ceiling around any [ConnectivityProbe.isReachable] call.
  final Duration probeTimeout;

  final StreamController<ConnectivityStatus> _controller =
      StreamController<ConnectivityStatus>.broadcast();

  ConnectivityStatus _current;
  Timer? _timer;
  bool _probing = false;

  @override
  ConnectivityStatus get current => _current;

  @override
  Stream<ConnectivityStatus> get onStatusChanged => _controller.stream;

  @override
  Future<void> start() async {
    if (_timer != null) return;
    // Schedule immediately; do not await the first probe so callers (bootstrap)
    // and interaction stay responsive under airplane mode / DNS hangs.
    _timer = Timer.periodic(interval, (_) {
      unawaited(_tick());
    });
    unawaited(_tick());
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    if (_probing) return;
    _probing = true;
    try {
      final online = await _probe.isReachable().timeout(
        probeTimeout,
        onTimeout: () => false,
      );
      final next =
          online ? ConnectivityStatus.online : ConnectivityStatus.offline;
      if (next == _current) return;
      _current = next;
      if (!_controller.isClosed) {
        _controller.add(next);
      }
    } finally {
      _probing = false;
    }
  }

  /// Test / shutdown helper.
  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }
}
