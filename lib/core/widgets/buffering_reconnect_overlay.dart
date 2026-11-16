import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Centered spinner + plain status for buffering / reconnect (TV-055 / DSN-016).
///
/// Pass [label] from presentation (e.g. [PlaybackStatusFeedbackCopy]) — this
/// widget never shows raw error codes or technical bitrate jargon.
class BufferingReconnectOverlay extends StatelessWidget {
  const BufferingReconnectOverlay({
    super.key,
    required this.label,
  });

  /// Viewer-facing status such as `Loading…` or `Reconnecting…`.
  final String label;

  static const String bufferingLabel = 'Loading…';
  static const String reconnectingLabel = 'Reconnecting…';

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final companion = Theme.of(context).brightness == Brightness.light;

    return Semantics(
      liveRegion: true,
      label: label,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: brand.panel.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: AppElevation.overlay(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
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
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: companion ? brand.ink : brand.cloud,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
