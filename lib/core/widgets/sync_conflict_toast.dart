import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'mi_button.dart';
import 'mi_overlay_panel.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Sync conflict toast (DSN-015) — warning icon + copy, bottom band only.
class SyncConflictToast extends StatelessWidget {
  const SyncConflictToast({
    super.key,
    required this.message,
    this.onResolve,
    this.resolveLabel = 'Resolve',
    this.visible = true,
  });

  final String message;
  final VoidCallback? onResolve;
  final String resolveLabel;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final conflictLabel = UiStateCatalog.of(UiState.syncConflict).label;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppMotion.normal,
        curve: AppMotion.emphasized,
        child: MiOverlayPanel(
          band: OverlayBand.bottom,
          maxHeightFactor: 0.2,
          child: Row(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      conflictLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: brand.warning,
                      ),
                    ),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge?.copyWith(color: brand.cloud),
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
