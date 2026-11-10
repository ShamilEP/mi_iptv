import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/focusable_surface.dart';
import '../../../../core/widgets/mi_overlay_panel.dart';
import '../../../../core/widgets/mi_subtitle_caption.dart';
import '../../../../core/widgets/vod_player_controls_overlay.dart';

/// TV VOD player hi-fi shell (DSN-037 / DSN-021 captions).
///
/// Temporary controls overlay with large seek / volume chrome and a timeline.
/// Play/pause sits in the uncovered primary action slot. Optional captions use
/// [AppSubtitleStyle] defaults.
class TvVodPlayerPage extends StatefulWidget {
  const TvVodPlayerPage({
    super.key,
    this.title = demoTitle,
    this.subtitleText = demoSubtitle,
    this.subtitleSize = SubtitleSizePreset.standard,
    this.positionLabel = '12:40',
    this.durationLabel = '1:45:00',
    this.progress = 0.32,
    this.autoHide = true,
    this.onSeekBackward,
    this.onSeekForward,
    this.onVolumeDown,
    this.onVolumeUp,
    this.onMuteToggle,
    this.onPlayPause,
  }) : assert(progress >= 0 && progress <= 1, 'progress must be in [0, 1]');

  final String title;
  final String? subtitleText;
  final SubtitleSizePreset subtitleSize;
  final String positionLabel;
  final String durationLabel;
  final double progress;
  final bool autoHide;
  final VoidCallback? onSeekBackward;
  final VoidCallback? onSeekForward;
  final VoidCallback? onVolumeDown;
  final VoidCallback? onVolumeUp;
  final VoidCallback? onMuteToggle;
  final VoidCallback? onPlayPause;

  static const String demoTitle = 'Harbor Lights';
  static const String demoSubtitle =
      'The harbor lights flickered across the water.';

  @override
  State<TvVodPlayerPage> createState() => _TvVodPlayerPageState();
}

class _TvVodPlayerPageState extends State<TvVodPlayerPage> {
  bool _controlsVisible = true;
  bool _playing = true;
  bool _muted = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _armHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _armHideTimer() {
    _hideTimer?.cancel();
    if (!widget.autoHide || !_controlsVisible) return;
    _hideTimer = Timer(AppMotion.playerControlsAutoHide, () {
      if (!mounted) return;
      setState(() => _controlsVisible = false);
    });
  }

  void _reveal() {
    setState(() => _controlsVisible = true);
    _armHideTimer();
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    _reveal();
    widget.onPlayPause?.call();
  }

  void _toggleMute() {
    setState(() => _muted = !_muted);
    _reveal();
    widget.onMuteToggle?.call();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (!_controlsVisible) {
        _reveal();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    final caption = widget.subtitleText;

    return TvAccessibleScope(
      child: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: Scaffold(
          backgroundColor: brand.ink,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _reveal,
            child: OverlayStage(
              topOverlay: _controlsVisible
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        heightFactor: 0.18,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: MiOverlayPanel.scrimColor(context),
                          ),
                          child: Padding(
                            padding: AppOverscan.padding,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.headlineMedium?.copyWith(
                                  color: brand.cloud,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
              primaryAction: _controlsVisible
                  ? FocusableSurface(
                      key: const ValueKey<String>('vod-play-pause'),
                      kind: FocusControlKind.button,
                      fill: brand.panel.withValues(alpha: 0.5),
                      borderRadius: AppRadius.full,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      onPressed: _togglePlay,
                      child: Icon(
                        _playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: AppSpacing.xxxl + AppSpacing.lg,
                        color: brand.cloud,
                        semanticLabel: _playing ? 'Pause' : 'Play',
                      ),
                    )
                  : null,
              bottomOverlay: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (caption != null && caption.trim().isNotEmpty)
                        Positioned(
                          left: AppSpacing.xl,
                          right: AppSpacing.xl,
                          // Sit just above the ~32% bottom transport band.
                          bottom: constraints.maxHeight * 0.32 + AppSpacing.sm,
                          child: MiSubtitleCaption(
                            key: const ValueKey<String>('vod-subtitle'),
                            text: caption,
                            size: widget.subtitleSize,
                          ),
                        ),
                      VodPlayerControlsOverlay(
                        visible: _controlsVisible,
                        positionLabel: widget.positionLabel,
                        durationLabel: widget.durationLabel,
                        progress: widget.progress,
                        muted: _muted,
                        onSeekBackward: () {
                          _reveal();
                          widget.onSeekBackward?.call();
                        },
                        onSeekForward: () {
                          _reveal();
                          widget.onSeekForward?.call();
                        },
                        onVolumeDown: () {
                          _reveal();
                          widget.onVolumeDown?.call();
                        },
                        onVolumeUp: () {
                          _reveal();
                          widget.onVolumeUp?.call();
                        },
                        onMuteToggle: _toggleMute,
                      ),
                    ],
                  );
                },
              ),
              child: ColoredBox(
                color: brand.panel,
                child: Center(
                  child: Icon(
                    Icons.movie_outlined,
                    size: 96,
                    color: brand.mist,
                    semanticLabel: 'Video',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
