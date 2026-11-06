import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'skeleton_block.dart';

/// Vertical list skeleton with fixed row heights (DSN-016).
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    super.key,
    this.rowCount = 5,
    this.rowHeight = 56,
    this.leadingSize = 40,
  }) : assert(rowCount > 0, 'rowCount must be > 0');

  final int rowCount;
  final double rowHeight;
  final double leadingSize;

  double get reservedHeight =>
      rowCount * rowHeight + (rowCount - 1) * AppGrid.rowGap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: reservedHeight,
      child: Column(
        children: [
          for (var i = 0; i < rowCount; i++) ...[
            if (i > 0) const SizedBox(height: AppGrid.rowGap),
            SizedBox(
              height: rowHeight,
              child: Row(
                children: [
                  SkeletonBlock(
                    width: leadingSize,
                    height: leadingSize,
                    borderRadius: AppRadius.sm,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonBlock(
                              width: constraints.maxWidth,
                              height: AppSpacing.md,
                              borderRadius: AppRadius.xs,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            SkeletonBlock(
                              width: constraints.maxWidth * 0.45,
                              height: AppSpacing.sm,
                              borderRadius: AppRadius.xs,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
