import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'mi_button.dart';
import 'mi_overlay_panel.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Stream / load failure overlay with retry (DSN-015).
///
/// Message and icon sit in the bottom band; pass the primary retry control via
/// [OverlayStage.primaryAction] when the center CTA must stay uncovered, or use
/// the built-in retry button for compact flows.
class ErrorRetryOverlay extends StatelessWidget {
  const ErrorRetryOverlay({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.showInlineRetry = true,
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  /// When false, only the message band is shown (retry lives in primary slot).
  final bool showInlineRetry;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final errorLabel = UiStateCatalog.of(UiState.error).label;

    return MiOverlayPanel(
      band: OverlayBand.bottom,
      maxHeightFactor: 0.3,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: brand.error,
            size: AppSpacing.xl,
            semanticLabel: errorLabel,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorLabel,
                  style: textTheme.labelLarge?.copyWith(color: brand.error),
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
          if (showInlineRetry && onRetry != null) ...[
            const SizedBox(width: AppSpacing.sm),
            MiButton(
              label: retryLabel,
              onPressed: onRetry,
              emphasis: ControlEmphasis.primary,
            ),
          ],
        ],
      ),
    );
  }
}
