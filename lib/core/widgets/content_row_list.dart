import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Finite, anchored vertical stack of content rails (TV-031 / DSN-012 / SRS §12).
///
/// Requires an explicit [rowCount] — never an unbounded / infinite generator.
/// Callers must know the row set up front (or swap in [ContentRowSkeleton]
/// rails while loading). Vertical rhythm uses [AppGrid.rowGap].
class ContentRowList extends StatelessWidget {
  const ContentRowList({
    super.key,
    required this.rowCount,
    required this.rowBuilder,
    this.padding,
    this.controller,
    this.physics,
  }) : assert(rowCount >= 0, 'rowCount must be >= 0');

  /// Number of rows; must be finite and known up front.
  final int rowCount;

  final IndexedWidgetBuilder rowBuilder;

  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      physics: physics,
      padding: padding,
      itemCount: rowCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppGrid.rowGap),
      itemBuilder: (context, index) {
        return KeyedSubtree(
          key: ValueKey<String>('content-row-list-$index'),
          child: rowBuilder(context, index),
        );
      },
    );
  }
}
