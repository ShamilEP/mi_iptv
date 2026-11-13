import '../../../../core/oem/oem_compatibility_profile.dart';
import '../../../../core/oem/oem_decoder_capabilities.dart';
import '../../../../core/oem/oem_quirk.dart';
import '../entities/abr_buffer_profile.dart';
import '../entities/playback_mode.dart';

/// Builds device- and mode-aware ABR / buffer profiles (TV-053 / NFR-QOE-04).
final class AbrBufferPolicy {
  const AbrBufferPolicy({this.oem});

  /// Optional OEM profile (TV-011) for resolution / stability ceilings.
  final OemCompatibilityProfile? oem;

  static const AbrBufferPolicy defaults = AbrBufferPolicy();

  AbrBufferProfile resolve(PlaybackMode mode) {
    final decoder = oem?.decoder ?? OemDecoderCapabilities.midRange;
    final conservative = oem?.hasQuirk(OemQuirk.conservativeAbr) ?? false;
    final prefer1080 = oem?.hasQuirk(OemQuirk.prefer1080pCeiling) ?? false;

    final maxWidth = prefer1080
        ? decoder.maxWidth.clamp(1, 1920)
        : decoder.maxWidth;
    final maxHeight = prefer1080
        ? decoder.maxHeight.clamp(1, 1080)
        : decoder.maxHeight;

    final maxBitrate = _maxBitrateBps(
      width: maxWidth,
      height: maxHeight,
      conservative: conservative,
    );

    return switch (mode) {
      PlaybackMode.live => AbrBufferProfile(
          mode: PlaybackMode.live,
          minBufferMs: conservative ? 2500 : 1500,
          maxBufferMs: conservative ? 12000 : 10000,
          bufferForPlaybackMs: conservative ? 2000 : 1500,
          bufferForPlaybackAfterRebufferMs: conservative ? 4000 : 3000,
          maxVideoBitrateBps: maxBitrate,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          bandwidthFraction: conservative ? 0.70 : 0.80,
          minDurationForQualityIncreaseMs: conservative ? 15000 : 12000,
          conservative: conservative,
        ),
      PlaybackMode.vod => AbrBufferProfile(
          mode: PlaybackMode.vod,
          minBufferMs: conservative ? 7500 : 5000,
          maxBufferMs: conservative ? 40000 : 50000,
          bufferForPlaybackMs: conservative ? 3000 : 2500,
          bufferForPlaybackAfterRebufferMs: conservative ? 6000 : 5000,
          maxVideoBitrateBps: maxBitrate,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          bandwidthFraction: conservative ? 0.75 : 0.85,
          minDurationForQualityIncreaseMs: conservative ? 15000 : 10000,
          conservative: conservative,
        ),
    };
  }

  /// Soft bitrate ceilings by decode class (not a measured network probe).
  static int _maxBitrateBps({
    required int width,
    required int height,
    required bool conservative,
  }) {
    final pixels = width * height;
    final base = pixels >= 3840 * 2160
        ? 12000000
        : pixels >= 1920 * 1080
            ? 6000000
            : 3000000;
    return conservative ? (base * 0.75).round() : base;
  }
}
