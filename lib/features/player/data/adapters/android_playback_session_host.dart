import 'dart:async';

import 'package:flutter/services.dart';

import '../../domain/entities/playback_session_signal.dart';
import '../../domain/repositories/playback_session_host.dart';

/// Android audio focus / keep-screen-on / HDMI via MethodChannel (TV-052).
///
/// No wakelock pub.dev package — Option A native host (same pattern as Media3).
final class AndroidPlaybackSessionHost implements PlaybackSessionHost {
  AndroidPlaybackSessionHost({
    MethodChannel? methodChannel,
    EventChannel? eventChannel,
  })  : _methods = methodChannel ??
            const MethodChannel('com.example.mi_iptv/playback_session'),
        _events = eventChannel ??
            const EventChannel('com.example.mi_iptv/playback_session_events');

  static const String methodName = 'com.example.mi_iptv/playback_session';
  static const String eventName = 'com.example.mi_iptv/playback_session_events';

  final MethodChannel _methods;
  final EventChannel _events;
  final _signals = StreamController<PlaybackSessionSignal>.broadcast();
  StreamSubscription<dynamic>? _subscription;

  @override
  Stream<PlaybackSessionSignal> get signals => _signals.stream;

  @override
  Future<void> start() async {
    _subscription ??= _events.receiveBroadcastStream().listen(_onEvent);
    try {
      await _methods.invokeMethod<void>('start');
    } on MissingPluginException {
      // Tests / non-Android hosts.
    } on PlatformException {
      // Best-effort.
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _methods.invokeMethod<void>('stop');
    } on MissingPluginException {
      // ignore
    } on PlatformException {
      // ignore
    }
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  Future<void> requestAudioFocus() => _invoke('requestAudioFocus');

  @override
  Future<void> abandonAudioFocus() => _invoke('abandonAudioFocus');

  @override
  Future<void> setKeepScreenOn(bool enabled) {
    return _invoke('setKeepScreenOn', <String, Object?>{'enabled': enabled});
  }

  Future<void> dispose() async {
    await stop();
    await _signals.close();
  }

  Future<void> _invoke(String method, [Map<String, Object?>? args]) async {
    try {
      await _methods.invokeMethod<void>(method, args);
    } on MissingPluginException {
      // ignore
    } on PlatformException {
      // ignore
    }
  }

  void _onEvent(dynamic raw) {
    if (raw is! Map) return;
    final name = raw['signal']?.toString();
    final signal = switch (name) {
      'audioFocusLost' => PlaybackSessionSignal.audioFocusLost,
      'audioFocusGained' => PlaybackSessionSignal.audioFocusGained,
      'hdmiDisconnected' => PlaybackSessionSignal.hdmiDisconnected,
      'hdmiConnected' => PlaybackSessionSignal.hdmiConnected,
      _ => null,
    };
    if (signal != null && !_signals.isClosed) {
      _signals.add(signal);
    }
  }
}
