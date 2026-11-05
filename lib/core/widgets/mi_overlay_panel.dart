import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Edge band for overlay chrome so the center primary action stays clear
/// (DSN-015 — semi-transparent, never covering the primary action).
enum OverlayBand {
  top,
  bottom,
}

/// Shared semi-transparent overlay surface (DSN-015).
class MiOverlayPanel extends StatelessWidget {
  const MiOverlayPanel({
    super.key,
    required this.child,
    this.band = OverlayBand.bottom,
    this.padding,
    this.maxHeightFactor = 0.28,
  });

  final Widget child;
  final OverlayBand band;
  final EdgeInsetsGeometry? padding;

  /// Max fraction of the parent height the band may occupy (keeps center free).
  final double maxHeightFactor;

  static Color scrimColor(BuildContext context) {
    final brand = context.brandColors;
    return brand.ink.withValues(alpha: 0.72);
  }

  @override
  Widget build(BuildContext context) {
    final alignment =
        band == OverlayBand.top ? Alignment.topCenter : Alignment.bottomCenter;

    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: maxHeightFactor,
        alignment: alignment,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scrimColor(context),
            boxShadow: AppElevation.overlay(),
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Stacks media content with edge overlay bands; [primaryAction] stays in the
/// uncovered center and is never painted over by overlay chrome.
class OverlayStage extends StatelessWidget {
  const OverlayStage({
    super.key,
    this.topOverlay,
    this.bottomOverlay,
    this.primaryAction,
    required this.child,
  });

  final Widget? topOverlay;
  final Widget? bottomOverlay;

  /// Centered primary control (play, retry focus target, etc.).
  final Widget? primaryAction;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ?topOverlay,
        ?bottomOverlay,
        // Primary action paints above edge bands so chrome never covers it.
        if (primaryAction != null)
          Center(
            child: KeyedSubtree(
              key: const ValueKey<String>('overlay-primary-action'),
              child: primaryAction!,
            ),
          ),
      ],
    );
  }
}
