import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/di/app_dependencies.dart';
import '../../../../core/network/connectivity_monitor.dart';
import '../../../../core/network/connectivity_status.dart';
import '../../domain/entities/linked_tv_snapshot.dart';
import '../../domain/repositories/linked_tv_status_store.dart';
import 'companion_remote_copy.dart';
import 'companion_remote_page.dart';

/// Applies last-known TV status + connectivity to the Companion remote (CMP-006).
class CompanionRemoteConnectivityBinder extends StatefulWidget {
  const CompanionRemoteConnectivityBinder({
    super.key,
    this.connectivity,
    this.linkedTvStatusStore,
    this.onCommand,
    this.onKeyboardSubmit,
    this.onFeedback,
  });

  final ConnectivityMonitor? connectivity;
  final LinkedTvStatusStore? linkedTvStatusStore;
  final ValueChanged<CompanionRemoteCommand>? onCommand;
  final ValueChanged<String>? onKeyboardSubmit;
  final Future<void> Function()? onFeedback;

  @override
  State<CompanionRemoteConnectivityBinder> createState() =>
      _CompanionRemoteConnectivityBinderState();
}

class _CompanionRemoteConnectivityBinderState
    extends State<CompanionRemoteConnectivityBinder> {
  String _tvName = CompanionRemoteCopy.demoTvName;
  bool _connected = true;
  StreamSubscription<ConnectivityStatus>? _sub;

  ConnectivityMonitor? get _monitor {
    if (widget.connectivity != null) return widget.connectivity;
    if (AppDependencies.isMounted) {
      return AppDependencies.instance.connectivity;
    }
    return null;
  }

  LinkedTvStatusStore? get _statusStore {
    if (widget.linkedTvStatusStore != null) return widget.linkedTvStatusStore;
    if (AppDependencies.isMounted) {
      return AppDependencies.instance.linkedTvStatusStore;
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
    final store = _statusStore;
    LinkedTvSnapshot? snapshot;
    if (store != null) {
      snapshot = await store.load();
    }
    if (!mounted) return;
    setState(() {
      if (snapshot != null) {
        _tvName = snapshot.displayName;
      }
      final online = monitor?.current == ConnectivityStatus.online;
      // Phone offline or last-known TV offline → remote still usable, marked off.
      _connected = online && (snapshot?.lastKnownOnline ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompanionRemotePage(
      tvName: _tvName,
      connected: _connected,
      onCommand: widget.onCommand,
      onKeyboardSubmit: widget.onKeyboardSubmit,
      onFeedback: widget.onFeedback,
    );
  }
}
