import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'mi_button.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Compact Offline banner when cached content stays browsable (TV-010 / DSN-010).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    this.message = defaultMessage,
    this.onRetry,
    this.retryLabel = 'Try again',
  });

  static const String defaultMessage =
      'You are offline. Showing cached titles until the network returns.';

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final offlineLabel = UiStateCatalog.of(UiState.offline).label;

    return Semantics(
      container: true,
      label: '$offlineLabel. $message',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: brand.panel,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: brand.warning.withValues(alpha: 0.7)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.wifi_off_outlined,
                color: brand.warning,
                size: AppSpacing.lg,
                semanticLabel: offlineLabel,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offlineLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: brand.warning,
                      ),
                    ),
                    Text(
                      message,
                      style: textTheme.bodyLarge?.copyWith(color: brand.cloud),
                    ),
                  ],
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(width: AppSpacing.sm),
                MiButton(
                  label: retryLabel,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
