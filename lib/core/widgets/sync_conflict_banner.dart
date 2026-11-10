import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'mi_button.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Theme-aware Sync Conflict banner for light and dark surfaces (DSN-010).
///
/// Warning accent always ships with icon + Sync Conflict label. Prefer this on
/// Companion; player overlays can keep [SyncConflictToast].
class SyncConflictBanner extends StatelessWidget {
  const SyncConflictBanner({
    super.key,
    required this.message,
    this.onResolve,
    this.resolveLabel = 'Resolve',
  });

  final String message;
  final VoidCallback? onResolve;
  final String resolveLabel;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final companion = Theme.of(context).brightness == Brightness.light;
    final conflictLabel = UiStateCatalog.of(UiState.syncConflict).label;
    final titleColor = companion ? brand.ink : brand.cloud;
    final fill = companion ? brand.cloud : brand.panel;

    return Semantics(
      container: true,
      label: '$conflictLabel. $message',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: brand.warning.withValues(alpha: 0.7)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: brand.warning,
                size: AppSpacing.xl,
                semanticLabel: conflictLabel,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conflictLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: brand.warning,
                      ),
                    ),
                    Text(
                      message,
                      style: textTheme.bodyLarge?.copyWith(color: titleColor),
                    ),
                  ],
                ),
              ),
              if (onResolve != null) ...[
                const SizedBox(width: AppSpacing.sm),
                MiButton(
                  label: resolveLabel,
                  onPressed: onResolve,
                  emphasis: ControlEmphasis.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
