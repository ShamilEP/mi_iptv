import 'dart:async';

import 'connectivity_monitor.dart';
import 'connectivity_status.dart';

/// In-memory [ConnectivityMonitor] for unit / widget tests (TV-010).
final class MemoryConnectivityMonitor implements ConnectivityMonitor {
  MemoryConnectivityMonitor([
    ConnectivityStatus initial = ConnectivityStatus.online,
  ]) : _current = initial;

  final StreamController<ConnectivityStatus> _controller =
      StreamController<ConnectivityStatus>.broadcast();

  ConnectivityStatus _current;
  bool _started = false;

  @override
  ConnectivityStatus get current => _current;

  @override
  Stream<ConnectivityStatus> get onStatusChanged => _controller.stream;

  @override
  Future<void> start() async {
    _started = true;
  }

  @override
  Future<void> stop() async {
    _started = false;
  }

  bool get isStarted => _started;

  /// Forces a status change (tests).
  void emit(ConnectivityStatus status) {
    if (status == _current) return;
    _current = status;
    if (!_controller.isClosed) {
      _controller.add(status);
    }
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }
}
