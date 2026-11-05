import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'mi_overlay_panel.dart';

/// Live channel HUD: number, title, optional now-playing (DSN-015).
///
/// Auto-hides after [AppMotion.channelInfoAutoHide] (4 s). Occupies the top
/// band only so the center primary action stays clear.
class ChannelInfoOverlay extends StatefulWidget {
  const ChannelInfoOverlay({
    super.key,
    required this.channelNumber,
    required this.channelTitle,
    this.nowPlaying,
    this.visible = true,
    this.autoHide = true,
    this.onHidden,
  });

  final String channelNumber;
  final String channelTitle;
  final String? nowPlaying;
  final bool visible;
  final bool autoHide;
  final VoidCallback? onHidden;

  @override
  State<ChannelInfoOverlay> createState() => ChannelInfoOverlayState();
}

class ChannelInfoOverlayState extends State<ChannelInfoOverlay> {
  Timer? _hideTimer;
  late bool _showing;

  bool get isShowing => _showing;

  @override
  void initState() {
    super.initState();
    _showing = widget.visible;
    _armTimer();
  }

  @override
  void didUpdateWidget(covariant ChannelInfoOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible ||
        widget.channelNumber != oldWidget.channelNumber ||
        widget.channelTitle != oldWidget.channelTitle) {
      setState(() => _showing = widget.visible);
      _armTimer();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  /// Re-shows the HUD and restarts the auto-hide timer (channel zap).
  void reveal() {
    setState(() => _showing = true);
    _armTimer();
  }

  void _armTimer() {
    _hideTimer?.cancel();
    if (!widget.autoHide || !_showing) return;
    _hideTimer = Timer(AppMotion.channelInfoAutoHide, () {
      if (!mounted) return;
      setState(() => _showing = false);
      widget.onHidden?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _showing ? 1 : 0,
        duration: AppMotion.normal,
        curve: AppMotion.emphasized,
        child: MiOverlayPanel(
          band: OverlayBand.top,
          maxHeightFactor: 0.26,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.channelNumber,
                  style: textTheme.labelSmall?.copyWith(color: brand.primary),
                ),
                Text(
                  widget.channelTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(color: brand.cloud),
                ),
                if (widget.nowPlaying != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    widget.nowPlaying!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge?.copyWith(color: brand.mist),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
