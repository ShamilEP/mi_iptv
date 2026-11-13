import '../oem/oem_compatibility_profile.dart';
import '../oem/oem_quirk.dart';

/// Memory budget for Flutter [ImageCache] on TV / Companion (TV-012 / NFR-003).
final class ImagePipelineConfig {
  const ImagePipelineConfig({
    required this.maximumSize,
    required this.maximumSizeBytes,
    this.thumbnailPixelRatioCap = 2.0,
  })  : assert(maximumSize > 0, 'maximumSize must be > 0'),
        assert(maximumSizeBytes > 0, 'maximumSizeBytes must be > 0'),
        assert(thumbnailPixelRatioCap > 0, 'thumbnailPixelRatioCap must be > 0');

  /// Mid-range TV default (~100 decoded thumbs, ~48 MiB).
  static const ImagePipelineConfig tvDefault = ImagePipelineConfig(
    maximumSize: 100,
    maximumSizeBytes: 48 * 1024 * 1024,
  );

  /// Low-memory stick / OEM `prefer1080pCeiling` (~40 thumbs, ~24 MiB).
  static const ImagePipelineConfig tvLowMemory = ImagePipelineConfig(
    maximumSize: 40,
    maximumSizeBytes: 24 * 1024 * 1024,
    thumbnailPixelRatioCap: 1.5,
  );

  /// Companion browse defaults (smaller rails).
  static const ImagePipelineConfig companionDefault = ImagePipelineConfig(
    maximumSize: 80,
    maximumSizeBytes: 32 * 1024 * 1024,
  );

  /// Max decoded images retained in the live cache.
  final int maximumSize;

  /// Soft byte ceiling for decoded image bytes (Flutter LRU).
  final int maximumSizeBytes;

  /// Cap applied when computing decode `cacheWidth` / `cacheHeight`.
  final double thumbnailPixelRatioCap;

  /// Picks a budget from OEM quirks (TV-011 → TV-012).
  factory ImagePipelineConfig.forOem(OemCompatibilityProfile profile) {
    if (profile.hasQuirk(OemQuirk.prefer1080pCeiling)) {
      return ImagePipelineConfig.tvLowMemory;
    }
    return ImagePipelineConfig.tvDefault;
  }
}
