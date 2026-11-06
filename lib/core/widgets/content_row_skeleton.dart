import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'content_card_metrics.dart';
import 'content_card_skeleton.dart';
import 'skeleton_block.dart';

/// Horizontal rail skeleton: title bar + fixed card slots (DSN-016).
///
/// Height matches a real [ContentRow] rail so content swap avoids layout shift.
class ContentRowSkeleton extends StatelessWidget {
  const ContentRowSkeleton({
    super.key,
    required this.kind,
    this.slotCount = 4,
    this.cardWidth,
    this.titleWidth = 220,
  }) : assert(slotCount > 0, 'slotCount must be > 0');

  final ContentCardKind kind;
  final int slotCount;
  final double? cardWidth;
  final double titleWidth;

  /// Reserved height for title + stackTight + scaled card rail.
  static double reservedHeight(ContentCardKind kind, {double? cardWidth}) {
    final card = ContentCardMetrics.sizeOf(kind, width: cardWidth);
    final railHeight =
        card.height * FocusStyles.scale + FocusStyles.glowSpread + AppSpacing.xs;
    // Match ContentRow title: Theme.textTheme.headlineMedium (TV headline).
    const titleBlock = AppTypography.tvHeadlineLine + AppSpacing.stackTight;
    return titleBlock + railHeight;
  }

  @override
  Widget build(BuildContext context) {
    final height = reservedHeight(kind, cardWidth: cardWidth);

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBlock(
            width: titleWidth,
            height: AppTypography.tvHeadlineLine,
            borderRadius: AppRadius.xs,
          ),
          const SizedBox(height: AppSpacing.stackTight),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: slotCount,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppGrid.gutter),
              itemBuilder: (context, index) {
                return ContentCardSkeleton(kind: kind, width: cardWidth);
              },
            ),
          ),
        ],
      ),
    );
  }
}
