/// User-controlled playback loudness (TV-056 / NFR-QOE-06).
///
/// Mute and volume change **only** from explicit remote/UI actions — never from
/// play, pause, seek, retry, zap, or audio-focus interrupts.
final class PlaybackAudioState {
  const PlaybackAudioState({
    this.muted = false,
    this.volume = defaultVolume,
  }) : assert(volume >= 0 && volume <= 1);

  /// Default level when the user has not adjusted volume yet.
  static const double defaultVolume = 0.8;

  /// Step used by volume-up / volume-down chrome.
  static const double step = 0.1;

  final bool muted;

  /// Last user-chosen level in `0..1`, preserved while [muted] is true.
  final double volume;

  /// Effective ExoPlayer / engine gain (0 when muted).
  double get effectiveVolume => muted ? 0 : volume;

  PlaybackAudioState copyWith({bool? muted, double? volume}) {
    return PlaybackAudioState(
      muted: muted ?? this.muted,
      volume: volume ?? this.volume,
    );
  }

  PlaybackAudioState toggleMute() => copyWith(muted: !muted);

  PlaybackAudioState volumeDown() {
    final next = (volume - step).clamp(0.0, 1.0);
    return PlaybackAudioState(
      volume: next,
      muted: next == 0 ? true : muted,
    );
  }

  PlaybackAudioState volumeUp() {
    final next = (volume + step).clamp(0.0, 1.0);
    return PlaybackAudioState(
      volume: next,
      muted: next > 0 ? false : muted,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlaybackAudioState &&
        other.muted == muted &&
        other.volume == volume;
  }

  @override
  int get hashCode => Object.hash(muted, volume);
}
