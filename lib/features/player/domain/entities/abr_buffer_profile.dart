import 'playback_mode.dart';

/// Media3 LoadControl + ABR track-selection knobs (TV-053 / NFR-QOE-04).
///
/// Pure values — no Flutter / Media3 imports. Native maps these onto
/// `DefaultLoadControl` and `DefaultTrackSelector`.
final class AbrBufferProfile {
  const AbrBufferProfile({
    required this.mode,
    required this.minBufferMs,
    required this.maxBufferMs,
    required this.bufferForPlaybackMs,
    required this.bufferForPlaybackAfterRebufferMs,
    required this.maxVideoBitrateBps,
    required this.maxWidth,
    required this.maxHeight,
    this.bandwidthFraction = 0.85,
    this.minDurationForQualityIncreaseMs = 10000,
    this.conservative = false,
  })  : assert(minBufferMs > 0),
        assert(maxBufferMs >= minBufferMs),
        assert(bufferForPlaybackMs > 0),
        assert(bufferForPlaybackAfterRebufferMs > 0),
        assert(maxVideoBitrateBps > 0),
        assert(maxWidth > 0 && maxHeight > 0),
        assert(bandwidthFraction > 0 && bandwidthFraction <= 1);

  final PlaybackMode mode;
  final int minBufferMs;
  final int maxBufferMs;
  final int bufferForPlaybackMs;
  final int bufferForPlaybackAfterRebufferMs;
  final int maxVideoBitrateBps;
  final int maxWidth;
  final int maxHeight;

  /// Fraction of measured bandwidth used for ABR upswitches.
  final double bandwidthFraction;

  /// Hold time before allowing a higher rung (stability).
  final int minDurationForQualityIncreaseMs;

  /// OEM / thermal-conservative path (TV-011 `conservativeAbr`).
  final bool conservative;

  Map<String, Object?> toWire() => <String, Object?>{
        'mode': mode.name,
        'minBufferMs': minBufferMs,
        'maxBufferMs': maxBufferMs,
        'bufferForPlaybackMs': bufferForPlaybackMs,
        'bufferForPlaybackAfterRebufferMs': bufferForPlaybackAfterRebufferMs,
        'maxVideoBitrateBps': maxVideoBitrateBps,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
        'bandwidthFraction': bandwidthFraction,
        'minDurationForQualityIncreaseMs': minDurationForQualityIncreaseMs,
        'conservative': conservative,
      };
}
