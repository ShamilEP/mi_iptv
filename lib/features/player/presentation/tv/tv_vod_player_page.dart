import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/focusable_surface.dart';
import '../../../../core/widgets/mi_overlay_panel.dart';
import '../../../../core/widgets/mi_subtitle_caption.dart';
import '../../../../core/widgets/vod_player_controls_overlay.dart';
import '../../domain/entities/playback_request.dart';
import '../../domain/repositories/media_player_controller.dart';
import '../../domain/services/accelerated_seek.dart';
import 'tv_track_models.dart';
import 'tv_track_selector_panel.dart';
import 'vod_playback_clock.dart';
import 'vod_transport_session.dart';

/// TV VOD player UI (TV-062 / DSN-037 / FR-014).
///
/// Temporary overlay with timeline, play/pause, ±10 s seek, accelerated hold
/// seek, volume/mute, and Back to exit. Optional [mediaPlayer] wires Media3.
class TvVodPlayerPage extends StatefulWidget {
  const TvVodPlayerPage({
    super.key,
    this.title = demoTitle,
    this.subtitleText = demoSubtitle,
    this.subtitleSize = SubtitleSizePreset.standard,
    this.autoHide = true,
    this.initialPreference = const TvTrackPreference(),
    this.audioTracks = demoAudioTracks,
    this.subtitleTracks = demoSubtitleTracks,
    this.mediaPlayer,
    this.playbackRequest,
    this.onExit,
    this.onSeekBackward,
    this.onSeekForward,
    this.onVolumeDown,
    this.onVolumeUp,
    this.onMuteToggle,
    this.onPlayPause,
    this.onPreferenceChanged,
  });

  final String title;
  final String? subtitleText;
  final SubtitleSizePreset subtitleSize;
  final bool autoHide;
  final TvTrackPreference initialPreference;
  final List<TvMediaTrack> audioTracks;
  final List<TvMediaTrack> subtitleTracks;

  /// When set, transport syncs to Media3 via [VodTransportSession].
  final MediaPlayerController? mediaPlayer;

  /// Optional stream to start when [mediaPlayer] is present.
  final PlaybackRequest? playbackRequest;

  /// Called after Back exits playback (in addition to [Navigator.maybePop]).
  final VoidCallback? onExit;

  final VoidCallback? onSeekBackward;
  final VoidCallback? onSeekForward;
  final VoidCallback? onVolumeDown;
  final VoidCallback? onVolumeUp;
  final VoidCallback? onMuteToggle;
  final VoidCallback? onPlayPause;
  final ValueChanged<TvTrackPreference>? onPreferenceChanged;

  static const String demoTitle = 'Harbor Lights';
  static const String demoSubtitle =
      'The harbor lights flickered across the water.';

  @override
  State<TvVodPlayerPage> createState() => _TvVodPlayerPageState();
}

class _TvVodPlayerPageState extends State<TvVodPlayerPage> {
  bool _controlsVisible = true;
  bool _trackSelectorOpen = false;
  late TvTrackPreference _preference = widget.initialPreference;
  Timer? _hideTimer;
  late final VodTransportSession _transport;

  @override
  void initState() {
    super.initState();
    _transport = VodTransportSession(
      player: widget.mediaPlayer,
      activeRequest: widget.playbackRequest,
    )..addListener(_onTransport);
    final request = widget.playbackRequest;
    if (widget.mediaPlayer != null && request != null) {
      unawaited(_transport.start(request));
    }
    _armHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _transport
      ..removeListener(_onTransport)
      ..dispose();
    super.dispose();
  }

  void _onTransport() {
    if (mounted) setState(() {});
  }

  void _armHideTimer() {
    _hideTimer?.cancel();
    if (!widget.autoHide || !_controlsVisible || _trackSelectorOpen) return;
    _hideTimer = Timer(AppMotion.playerControlsAutoHide, () {
      if (!mounted) return;
      setState(() => _controlsVisible = false);
    });
  }

  void _reveal() {
    setState(() => _controlsVisible = true);
    _armHideTimer();
  }

  Future<void> _togglePlay() async {
    await _transport.togglePlayPause();
    _reveal();
    widget.onPlayPause?.call();
  }

  Future<void> _seekTap({required bool forward}) async {
    await _transport.seekBy(
      forward ? AcceleratedSeek.tapStep : -AcceleratedSeek.tapStep,
    );
    _reveal();
    if (forward) {
      widget.onSeekForward?.call();
    } else {
      widget.onSeekBackward?.call();
    }
  }

  void _toggleMute() {
    _transport.toggleMute();
    _reveal();
    widget.onMuteToggle?.call();
  }

  void _volumeDown() {
    _transport.volumeDown();
    _reveal();
    widget.onVolumeDown?.call();
  }

  void _volumeUp() {
    _transport.volumeUp();
    _reveal();
    widget.onVolumeUp?.call();
  }

  void _openTrackSelector() {
    setState(() {
      _trackSelectorOpen = true;
      _controlsVisible = true;
    });
    _hideTimer?.cancel();
  }

  void _closeTrackSelector() {
    setState(() => _trackSelectorOpen = false);
    _armHideTimer();
  }

  void _setPreference(TvTrackPreference next) {
    setState(() => _preference = next);
    widget.onPreferenceChanged?.call(next);
  }

  Future<void> _exit() async {
    widget.onExit?.call();
    if (mounted) {
      await Navigator.of(context).maybePop();
    }
  }

  bool get _subtitlesOn {
    final match = widget.subtitleTracks.where(
      (t) => t.id == _preference.subtitleTrackId,
    );
    if (match.isEmpty) return false;
    return !match.first.isOff;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _transport.stopAcceleratedSeek();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape ||
        event.logicalKey == LogicalKeyboardKey.goBack) {
      if (_trackSelectorOpen) {
        _closeTrackSelector();
        return KeyEventResult.handled;
      }
      unawaited(_exit());
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.mediaPlayPause ||
        event.logicalKey == LogicalKeyboardKey.space) {
      unawaited(_togglePlay());
      return KeyEventResult.handled;
    }

    if (_controlsVisible && !_trackSelectorOpen) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _transport.startAcceleratedSeek(forward: false);
        _reveal();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _transport.startAcceleratedSeek(forward: true);
        _reveal();
        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (!_controlsVisible && !_trackSelectorOpen) {
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
    final showCaption =
        _subtitlesOn && caption != null && caption.trim().isNotEmpty;
    final positionLabel = formatVodClock(_transport.position);
    final durationLabel = formatVodClock(_transport.duration);

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
              topOverlay: _controlsVisible && !_trackSelectorOpen
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
              primaryAction: _controlsVisible && !_trackSelectorOpen
                  ? FocusableSurface(
                      key: const ValueKey<String>('vod-play-pause'),
                      kind: FocusControlKind.button,
                      fill: brand.panel.withValues(alpha: 0.5),
                      borderRadius: AppRadius.full,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      onPressed: () => unawaited(_togglePlay()),
                      child: Icon(
                        _transport.playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: AppSpacing.xxxl + AppSpacing.lg,
                        color: brand.cloud,
                        semanticLabel:
                            _transport.playing ? 'Pause' : 'Play',
                      ),
                    )
                  : null,
              bottomOverlay: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (showCaption)
                        Positioned(
                          left: AppSpacing.xl,
                          right: AppSpacing.xl,
                          bottom: constraints.maxHeight * 0.32 + AppSpacing.sm,
                          child: MiSubtitleCaption(
                            key: const ValueKey<String>('vod-subtitle'),
                            text: caption,
                            size: widget.subtitleSize,
                          ),
                        ),
                      VodPlayerControlsOverlay(
                        visible: _controlsVisible && !_trackSelectorOpen,
                        positionLabel: positionLabel,
                        durationLabel: durationLabel,
                        progress: _transport.progress,
                        muted: _transport.muted,
                        trackSelectorLabel: TvTrackSelectorCopy.openLabel,
                        onSeekBackward: () =>
                            unawaited(_seekTap(forward: false)),
                        onSeekForward: () =>
                            unawaited(_seekTap(forward: true)),
                        onVolumeDown: _volumeDown,
                        onVolumeUp: _volumeUp,
                        onMuteToggle: _toggleMute,
                        onOpenTrackSelector: _openTrackSelector,
                      ),
                      if (_trackSelectorOpen)
                        TvTrackSelectorPanel(
                          key: const ValueKey<String>('track-selector-panel'),
                          preference: _preference,
                          audioTracks: widget.audioTracks,
                          subtitleTracks: widget.subtitleTracks,
                          onAudioSelected: (track) {
                            _setPreference(
                              _preference.copyWith(audioTrackId: track.id),
                            );
                          },
                          onSubtitleSelected: (track) {
                            _setPreference(
                              _preference.copyWith(subtitleTrackId: track.id),
                            );
                          },
                          onClose: _closeTrackSelector,
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
