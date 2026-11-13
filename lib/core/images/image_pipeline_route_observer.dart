import 'package:flutter/widgets.dart';

import 'image_pipeline.dart';

/// Releases live image handles when routes pop (TV-012 off-screen reclaim).
final class ImagePipelineRouteObserver extends NavigatorObserver {
  ImagePipelineRouteObserver(this.pipeline);

  final ImagePipeline pipeline;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pipeline.releaseOffscreenImages();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pipeline.releaseOffscreenImages();
  }
}
