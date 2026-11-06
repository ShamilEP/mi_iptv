import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'skeleton_block.dart';

/// Detail / hero skeleton with fixed hero + text lines (DSN-016).
class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({
    super.key,
    this.heroWidth = 280,
    this.heroHeight = 158,
    this.lineCount = 3,
  }) : assert(lineCount > 0, 'lineCount must be > 0');

  final double heroWidth;
  final double heroHeight;
  final int lineCount;

  /// Total height reserved for the pattern (hero + gaps + lines).
  double get reservedHeight {
    const lineHeight = AppSpacing.lg;
    return heroHeight +
        AppSpacing.stack +
        lineCount * lineHeight +
        (lineCount - 1) * AppSpacing.xs;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: reservedHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBlock(
            width: heroWidth,
            height: heroHeight,
            borderRadius: AppRadius.md,
          ),
          const SizedBox(height: AppSpacing.stack),
          for (var i = 0; i < lineCount; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.xs),
            SkeletonBlock(
              width: i == lineCount - 1 ? heroWidth * 0.55 : heroWidth,
              height: AppSpacing.lg,
              borderRadius: AppRadius.xs,
            ),
          ],
        ],
      ),
    );
  }
}
