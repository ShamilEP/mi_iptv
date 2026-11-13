import 'dart:ui';

import '../widgets/content_card_metrics.dart';
import 'image_pipeline_config.dart';

/// Decode-time thumbnail pixel targets (TV-012).
///
/// Keeps catalog rails from decoding full-resolution posters into the
/// [ImageCache] — logical card size × capped device pixel ratio.
abstract final class ImageThumbnailSizes {
  static Size decodePixelsFor(
    ContentCardKind kind, {
    required ImagePipelineConfig config,
    double? width,
    double devicePixelRatio = 1.0,
  }) {
    final logical = ContentCardMetrics.sizeOf(kind, width: width);
    final ratio = devicePixelRatio.clamp(1.0, config.thumbnailPixelRatioCap);
    return Size(
      (logical.width * ratio).roundToDouble(),
      (logical.height * ratio).roundToDouble(),
    );
  }
}
