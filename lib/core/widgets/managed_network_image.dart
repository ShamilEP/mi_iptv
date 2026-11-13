import 'package:flutter/material.dart';

import '../images/artwork_uri.dart';
import '../images/image_pipeline.dart';
import '../images/image_pipeline_config.dart';
import '../images/image_thumbnail_sizes.dart';
import '../theme/theme.dart';
import 'content_card_metrics.dart';
import 'content_card_skeleton.dart';

/// Network artwork with thumbnail decode + skeleton placeholder (TV-012).
///
/// Uses [ImagePipeline] when provided; otherwise builds a local ResizeImage.
/// Off-screen release is owned by the pipeline / list dispose — not this widget.
class ManagedNetworkImage extends StatelessWidget {
  const ManagedNetworkImage({
    super.key,
    required this.url,
    required this.kind,
    this.width,
    this.pipeline,
    this.fit = BoxFit.cover,
    this.errorIcon,
  });

  final String url;
  final ContentCardKind kind;
  final double? width;
  final ImagePipeline? pipeline;
  final BoxFit fit;
  final IconData? errorIcon;

  @override
  Widget build(BuildContext context) {
    final uri = ArtworkUri.tryParse(url);
    final size = ContentCardMetrics.sizeOf(kind, width: width);
    if (uri == null) {
      return _ErrorPanel(kind: kind, width: width, icon: errorIcon);
    }

    final config = pipeline?.config ?? ImagePipelineConfig.tvDefault;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final decode = ImageThumbnailSizes.decodePixelsFor(
      kind,
      config: config,
      width: width,
      devicePixelRatio: dpr,
    );
    final provider = pipeline?.providerFor(
          uri,
          cacheWidth: decode.width.round(),
          cacheHeight: decode.height.round(),
        ) ??
        ResizeImage(
          NetworkImage(uri.toString()),
          width: decode.width.round(),
          height: decode.height.round(),
          policy: ResizeImagePolicy.fit,
        );

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Image(
        image: provider,
        fit: fit,
        gaplessPlayback: true,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return ContentCardSkeleton(kind: kind, width: width);
        },
        errorBuilder: (context, error, stackTrace) {
          return _ErrorPanel(kind: kind, width: width, icon: errorIcon);
        },
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({
    required this.kind,
    this.width,
    this.icon,
  });

  final ContentCardKind kind;
  final double? width;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final size = ContentCardMetrics.sizeOf(kind, width: width);
    final brand = context.brandColors;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ColoredBox(
        color: brand.panel,
        child: Center(
          child: Icon(
            icon ?? Icons.broken_image_outlined,
            color: brand.mist,
            size: AppSpacing.lg,
          ),
        ),
      ),
    );
  }
}
