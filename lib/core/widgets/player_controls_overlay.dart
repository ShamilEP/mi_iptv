import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'focusable_surface.dart';
import 'mi_overlay_panel.dart';

/// Transport chrome for the player (DSN-015).
///
/// Lives in the bottom band; play/pause is expected in [OverlayStage.primaryAction]
/// so this bar never covers the primary control.
class PlayerControlsOverlay extends StatelessWidget {
  const PlayerControlsOverlay({
    super.key,
    this.visible = true,
    this.positionLabel = '00:00',
    this.durationLabel = '--:--',
    this.progress = 0,
    this.onSeekBackward,
    this.onSeekForward,
    this.onOpenInfo,
  }) : assert(progress >= 0 && progress <= 1, 'progress must be in [0, 1]');

  final bool visible;
  final String positionLabel;
  final String durationLabel;
  final double progress;
  final VoidCallback? onSeekBackward;
  final VoidCallback? onSeekForward;
  final VoidCallback? onOpenInfo;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppMotion.normal,
        curve: AppMotion.emphasized,
        child: MiOverlayPanel(
          band: OverlayBand.bottom,
          maxHeightFactor: 0.24,
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
                        minHeight: FocusStyles.ringWidth,
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
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TransportButton(
                    icon: Icons.replay_10,
                    label: 'Back 10 seconds',
                    onPressed: onSeekBackward,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _TransportButton(
                    icon: Icons.forward_10,
                    label: 'Forward 10 seconds',
                    onPressed: onSeekForward,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _TransportButton(
                    icon: Icons.info_outline,
                    label: 'Info',
                    onPressed: onOpenInfo,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({
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
      fill: brand.panel.withValues(alpha: 0.9),
      borderRadius: AppRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.sm),
      onPressed: onPressed,
      child: Icon(icon, color: brand.cloud, size: AppSpacing.xl, semanticLabel: label),
    );
  }
}
