/// Live vs VOD playback envelope for ABR / buffer profiles (TV-053).
enum PlaybackMode {
  /// Lower latency buffers; cautious upswitches.
  live,

  /// Deeper rebuffer budget for on-demand titles.
  vod,
}
