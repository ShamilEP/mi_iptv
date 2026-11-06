import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Fixed-size skeleton bone (DSN-016 / NFR-001).
///
/// Always takes [width] × [height] so swapping real content does not shift
/// layout. Pulse is intentionally omitted so test `pumpAndSettle` and TV idle
/// frames stay quiet; Loading state motion lives in [LoadingPattern].
class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final radius = widgetBorderRadius;

    return Semantics(
      label: 'Loading',
      child: ExcludeFocus(
        child: SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: brand.panel,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: brand.border),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.35,
                heightFactor: 1,
                child: ColoredBox(
                  color: brand.border.withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get widgetBorderRadius => borderRadius ?? AppRadius.md;
}
