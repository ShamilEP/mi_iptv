import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'focusable_surface.dart';
import 'mi_overlay_panel.dart';

/// Large VOD transport chrome for the temporary player overlay (DSN-037).
///
/// Bottom band only: timeline, seek ±10 s, and volume / mute. Play/pause stays
/// in [OverlayStage.primaryAction] so this bar never covers the primary action.
class VodPlayerControlsOverlay extends StatelessWidget {
  const VodPlayerControlsOverlay({
    super.key,
    this.visible = true,
    this.positionLabel = '00:00',
    this.durationLabel = '--:--',
    this.progress = 0,
    this.muted = false,
    this.onSeekBackward,
    this.onSeekForward,
    this.onVolumeDown,
    this.onVolumeUp,
    this.onMuteToggle,
    this.onOpenTrackSelector,
    this.trackSelectorLabel = 'Audio and subtitles',
  }) : assert(progress >= 0 && progress <= 1, 'progress must be in [0, 1]');

  final bool visible;
  final String positionLabel;
  final String durationLabel;
  final double progress;
  final bool muted;
  final VoidCallback? onSeekBackward;
  final VoidCallback? onSeekForward;
  final VoidCallback? onVolumeDown;
  final VoidCallback? onVolumeUp;
  final VoidCallback? onMuteToggle;
  final VoidCallback? onOpenTrackSelector;
  final String trackSelectorLabel;

  static const String seekBackLabel = 'Back 10 seconds';
  static const String seekForwardLabel = 'Forward 10 seconds';
  static const String volumeDownLabel = 'Volume down';
  static const String volumeUpLabel = 'Volume up';
  static const String muteLabel = 'Mute';
  static const String unmuteLabel = 'Unmute';

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final muteText = muted ? unmuteLabel : muteLabel;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppMotion.durationOf(context, AppMotion.normal),
        curve: AppMotion.curveOf(context, AppMotion.emphasized),
        child: MiOverlayPanel(
          band: OverlayBand.bottom,
          maxHeightFactor: 0.32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    positionLabel,
                    style: textTheme.labelSmall?.copyWith(color: brand.cloud),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: AppSpacing.xs,
                        backgroundColor: brand.border,
                        color: brand.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    durationLabel,
                    style: textTheme.labelSmall?.copyWith(color: brand.mist),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LargeControl(
                    icon: Icons.replay_10,
                    label: seekBackLabel,
                    onPressed: onSeekBackward,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _LargeControl(
                    icon: Icons.forward_10,
                    label: seekForwardLabel,
                    onPressed: onSeekForward,
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  _LargeControl(
                    icon: Icons.volume_down,
                    label: volumeDownLabel,
                    onPressed: onVolumeDown,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _LargeControl(
                    icon: muted ? Icons.volume_off : Icons.volume_up,
                    label: muteText,
                    onPressed: onMuteToggle,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _LargeControl(
                    icon: Icons.volume_up,
                    label: volumeUpLabel,
                    onPressed: onVolumeUp,
                  ),
                  if (onOpenTrackSelector != null) ...[
                    const SizedBox(width: AppSpacing.xl),
                    _LargeControl(
                      key: const ValueKey<String>('vod-track-selector'),
                      icon: Icons.closed_caption,
                      label: trackSelectorLabel,
                      onPressed: onOpenTrackSelector,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LargeControl extends StatelessWidget {
  const _LargeControl({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return FocusableSurface(
      kind: FocusControlKind.button,
      fill: brand.panel.withValues(alpha: 0.92),
      borderRadius: AppRadius.md,
      padding: const EdgeInsets.all(AppSpacing.md),
      onPressed: onPressed,
      child: Icon(
        icon,
        color: brand.cloud,
        size: AppSpacing.xxl,
        semanticLabel: label,
      ),
    );
  }
}
