import 'dart:async';

import 'package:flutter/services.dart';

import '../../domain/entities/playback_request.dart';
import '../../domain/entities/stream_protocol.dart';
import '../../domain/repositories/media_player_controller.dart';
import '../../domain/services/stream_format_sniffer.dart';

/// Android Media3 / ExoPlayer [MediaPlayerController] via platform channels
/// (TV-050 / TV-051, approved Option A).
///
/// Channel ownership / ExoPlayer lifecycle live in the native
/// `Media3PlayerPlugin` attached to the Flutter engine — not in player
/// screens. Only this adapter may talk to the Media3 channels.
final class Media3PlayerAdapter implements MediaPlayerController {
  Media3PlayerAdapter({
    MethodChannel? methodChannel,
    EventChannel? eventChannel,
  })  : _methods = methodChannel ??
            const MethodChannel('com.example.mi_iptv/media3_player'),
        _events = eventChannel ??
            const EventChannel('com.example.mi_iptv/media3_player_events') {
    _subscription = _events.receiveBroadcastStream().listen(
      _onEvent,
      onError: _onChannelError,
    );
    _statusController.add(const MediaPlayerStatus(phase: MediaPlayerPhase.idle));
  }

  final MethodChannel _methods;
  final EventChannel _events;
  final _statusController = StreamController<MediaPlayerStatus>.broadcast();
  StreamSubscription<dynamic>? _subscription;

  @override
  Stream<MediaPlayerStatus> get status => _statusController.stream;

  @override
  Future<void> play(PlaybackRequest request) {
    final protocol = StreamFormatSniffer.sniff(
      request.streamUri,
      protocolHint: request.protocolHint,
    );
    return _invoke('play', <String, Object?>{
      'uri': request.streamUri.toString(),
      'protocol': protocol.wireName,
      'headers': request.headers,
      'userAgent': request.userAgent,
    });
  }

  @override
  Future<void> pause() => _invoke('pause');

  @override
  Future<void> seek(Duration position) {
    return _invoke('seek', <String, Object?>{
      'positionMs': position.inMilliseconds,
    });
  }

  @override
  Future<void> stop() => _invoke('stop');

  /// Detach event subscription. Native ExoPlayer is released with the engine.
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    await _statusController.close();
  }

  Future<void> _invoke(String method, [Map<String, Object?>? args]) async {
    try {
      await _methods.invokeMethod<void>(method, args);
    } on MissingPluginException catch (error) {
      _emit(
        MediaPlayerStatus(
          phase: MediaPlayerPhase.error,
          message: error.message ?? 'missing_media3_plugin',
        ),
      );
    } on PlatformException catch (error) {
      // Never forward license keys / credentials — code + short message only.
      _emit(
        MediaPlayerStatus(
          phase: MediaPlayerPhase.error,
          message: error.code,
        ),
      );
    }
  }

  void _onEvent(dynamic raw) {
    if (raw is! Map) return;
    final map = Map<Object?, Object?>.from(raw);
    _emit(
      MediaPlayerStatus(
        phase: _phaseOf(map['phase']?.toString()),
        position: Duration(milliseconds: _intOf(map['positionMs'])),
        duration: Duration(milliseconds: _intOf(map['durationMs'])),
        message: map['message']?.toString(),
      ),
    );
  }

  void _onChannelError(Object error, StackTrace stackTrace) {
    _emit(
      MediaPlayerStatus(
        phase: MediaPlayerPhase.error,
        message: error is PlatformException ? error.code : 'channel_error',
      ),
    );
  }

  void _emit(MediaPlayerStatus next) {
    if (!_statusController.isClosed) {
      _statusController.add(next);
    }
  }

  static MediaPlayerPhase _phaseOf(String? raw) {
    return switch (raw) {
      'buffering' => MediaPlayerPhase.buffering,
      'playing' => MediaPlayerPhase.playing,
      'paused' => MediaPlayerPhase.paused,
      'ended' => MediaPlayerPhase.ended,
      'error' => MediaPlayerPhase.error,
      _ => MediaPlayerPhase.idle,
    };
  }

  static int _intOf(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return 0;
  }
}
