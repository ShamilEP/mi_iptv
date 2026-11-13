import 'dart:async';

import '../../domain/entities/playback_session_signal.dart';
import '../../domain/repositories/playback_session_host.dart';

/// In-memory [PlaybackSessionHost] for unit tests (TV-052).
final class MemoryPlaybackSessionHost implements PlaybackSessionHost {
  final _signals = StreamController<PlaybackSessionSignal>.broadcast();

  bool started = false;
  bool audioFocusHeld = false;
  bool keepScreenOn = false;
  int requestFocusCalls = 0;
  int abandonFocusCalls = 0;

  @override
  Stream<PlaybackSessionSignal> get signals => _signals.stream;

  @override
  Future<void> start() async {
    started = true;
  }

  @override
  Future<void> stop() async {
    started = false;
    audioFocusHeld = false;
    keepScreenOn = false;
  }

  @override
  Future<void> requestAudioFocus() async {
    requestFocusCalls += 1;
    audioFocusHeld = true;
  }

  @override
  Future<void> abandonAudioFocus() async {
    abandonFocusCalls += 1;
    audioFocusHeld = false;
  }

  @override
  Future<void> setKeepScreenOn(bool enabled) async {
    keepScreenOn = enabled;
  }

  void emit(PlaybackSessionSignal signal) {
    if (!_signals.isClosed) {
      _signals.add(signal);
    }
  }

  Future<void> dispose() async {
    await _signals.close();
  }
}
