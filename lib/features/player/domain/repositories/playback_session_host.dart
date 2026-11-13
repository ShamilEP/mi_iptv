import '../entities/playback_session_signal.dart';

/// Platform capabilities for playback session lifecycle (TV-052).
///
/// Audio focus, keep-screen-on / screensaver prevention, and HDMI plugs are
/// owned by the native host. App lifecycle is forwarded from Flutter separately.
abstract interface class PlaybackSessionHost {
  /// Platform signals (audio focus, HDMI).
  Stream<PlaybackSessionSignal> get signals;

  /// Begin listening for HDMI / focus callbacks.
  Future<void> start();

  /// Stop receivers / abandon focus / clear keep-screen-on.
  Future<void> stop();

  Future<void> requestAudioFocus();

  Future<void> abandonAudioFocus();

  /// Prevent screensaver / sleep while video is on-screen.
  Future<void> setKeepScreenOn(bool enabled);
}
