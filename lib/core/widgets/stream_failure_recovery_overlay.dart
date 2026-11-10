import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'mi_button.dart';
import 'mi_overlay_panel.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Stream-failure recovery card for Live TV (DSN-039).
///
/// Shows an actionable [message] plus Retry, Switch source, and Back to
/// channels, and repeats [channelNumber], [channelTitle], and [sourceLabel]
/// so the failed channel stays identifiable.
class StreamFailureRecoveryOverlay extends StatefulWidget {
  const StreamFailureRecoveryOverlay({
    super.key,
    required this.channelNumber,
    required this.channelTitle,
    required this.sourceLabel,
    this.message = defaultMessage,
    this.logo,
    this.onRetry,
    this.onSwitchSource,
    this.onBackToChannels,
  });

  /// Channel number shown with the failure (for example `12`).
  final String channelNumber;

  /// Channel name shown with the failure.
  final String channelTitle;

  /// Active source name for this channel.
  final String sourceLabel;

  /// Actionable failure copy. Defaults to [defaultMessage].
  final String message;

  /// Optional channel logo. A live-TV glyph is used when omitted.
  final Widget? logo;

  /// Called when Retry is activated.
  final VoidCallback? onRetry;

  /// Called when Switch source is activated.
  final VoidCallback? onSwitchSource;

  /// Called when Back to channels is activated.
  final VoidCallback? onBackToChannels;

  static const String defaultMessage =
      "Couldn't play this channel. Retry, switch source, or go back to channels.";

  static const String retryLabel = 'Retry';
  static const String switchSourceLabel = 'Switch source';
  static const String backToChannelsLabel = 'Back to channels';

  @override
  State<StreamFailureRecoveryOverlay> createState() =>
      _StreamFailureRecoveryOverlayState();
}

class _StreamFailureRecoveryOverlayState
    extends State<StreamFailureRecoveryOverlay> {
  final FocusNode _retryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _retryFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _retryFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final errorLabel = UiStateCatalog.of(UiState.error).label;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppOverscan.inset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 0.72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: MiOverlayPanel.scrimColor(context),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppElevation.overlay(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          children: [
                            Text(
                              errorLabel,
                              style: textTheme.labelLarge
                                  ?.copyWith(color: brand.error),
                            ),
                            Text(
                              widget.message,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: brand.cloud),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      SizedBox(
                        width: AppSpacing.xxl,
                        height: AppSpacing.xxl,
                        child: widget.logo ??
                            Icon(
                              Icons.live_tv_outlined,
                              color: brand.cloud,
                              size: AppSpacing.xl,
                            ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.channelNumber,
                              style: textTheme.labelSmall
                                  ?.copyWith(color: brand.primary),
                            ),
                            Text(
                              widget.channelTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleLarge
                                  ?.copyWith(color: brand.cloud),
                            ),
                            Text(
                              widget.sourceLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelLarge
                                  ?.copyWith(color: brand.mist),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      MiButton(
                        label: StreamFailureRecoveryOverlay.retryLabel,
                        emphasis: ControlEmphasis.primary,
                        focusNode: _retryFocus,
                        onPressed: widget.onRetry,
                      ),
                      MiButton(
                        label: StreamFailureRecoveryOverlay.switchSourceLabel,
                        emphasis: ControlEmphasis.secondary,
                        onPressed: widget.onSwitchSource,
                      ),
                      MiButton(
                        label:
                            StreamFailureRecoveryOverlay.backToChannelsLabel,
                        emphasis: ControlEmphasis.secondary,
                        onPressed: widget.onBackToChannels,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
