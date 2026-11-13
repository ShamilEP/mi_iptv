import 'package:flutter/painting.dart';

import 'image_cache_controller.dart';
import 'image_pipeline_config.dart';

/// Configures the shared image cache and releases off-screen bitmaps (TV-012).
final class ImagePipeline {
  /// Unit tests default to [MemoryImageCacheController]. Device bootstrap
  /// injects [FlutterImageCacheController] so ceilings hit the process cache.
  ImagePipeline({
    ImagePipelineConfig config = ImagePipelineConfig.tvDefault,
    ImageCacheController? cache,
  }) : _cache = cache ?? MemoryImageCacheController() {
    apply(config);
  }

  factory ImagePipeline.forDevice({
    required ImagePipelineConfig config,
  }) {
    return ImagePipeline(
      config: config,
      cache: FlutterImageCacheController(),
    );
  }

  late ImagePipelineConfig _config;
  final ImageCacheController _cache;

  ImagePipelineConfig get config => _config;

  ImageCacheController get cache => _cache;

  /// Applies [config] memory ceilings to the process [ImageCache].
  void apply(ImagePipelineConfig config) {
    _config = config;
    _cache.maximumSize = config.maximumSize;
    _cache.maximumSizeBytes = config.maximumSizeBytes;
  }

  /// Releases keep-alive / live image handles (call on route pop or list reset).
  void releaseOffscreenImages() => _cache.clearLiveImages();

  /// Full cache wipe (rare — e.g. logout / source switch).
  void clearAll() => _cache.clear();

  /// Thumbnail-sized [ImageProvider] so decode stays within card budgets.
  ImageProvider providerFor(
    Uri uri, {
    required int cacheWidth,
    required int cacheHeight,
  }) {
    assert(cacheWidth > 0 && cacheHeight > 0);
    return ResizeImage(
      NetworkImage(uri.toString()),
      width: cacheWidth,
      height: cacheHeight,
      policy: ResizeImagePolicy.fit,
    );
  }
}
