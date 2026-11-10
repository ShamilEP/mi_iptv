import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Syncing pattern with progress + catalog label (DSN-010 Syncing).
///
/// Pairs the Success accent with a non-color cue (progress + Syncing text).
class SyncingPattern extends StatelessWidget {
  const SyncingPattern({super.key, this.label, this.minHeight = 48});

  final String? label;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final companion = Theme.of(context).brightness == Brightness.light;
    final catalogLabel = UiStateCatalog.of(UiState.syncing).label;
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
                color: brand.success,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: companion ? brand.ink : brand.cloud),
            ),
          ],
        ),
      ),
    );
  }
}
