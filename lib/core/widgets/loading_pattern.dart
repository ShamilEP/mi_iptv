import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Inline loading pattern with progress + label (DSN-016 / DSN-010 Loading).
///
/// Uses a fixed [minHeight] so replacing this with content does not jump.
class LoadingPattern extends StatelessWidget {
  const LoadingPattern({
    super.key,
    this.label,
    this.minHeight = 48,
  });

  final String? label;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final catalogLabel = UiStateCatalog.of(UiState.loading).label;
    final text = label ?? catalogLabel;

    return Semantics(
      liveRegion: true,
      label: text,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppSpacing.lg,
              height: AppSpacing.lg,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: brand.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: brand.cloud,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
