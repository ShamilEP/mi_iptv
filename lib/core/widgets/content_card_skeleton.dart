import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'content_card_metrics.dart';
import 'skeleton_block.dart';

/// Card-shaped skeleton locked to [ContentCardMetrics] (DSN-016).
class ContentCardSkeleton extends StatelessWidget {
  const ContentCardSkeleton({
    super.key,
    required this.kind,
    this.width,
  });

  final ContentCardKind kind;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = ContentCardMetrics.sizeOf(kind, width: width);
    return SkeletonBlock(
      width: size.width,
      height: size.height,
      borderRadius: AppRadius.md,
    );
  }
}
