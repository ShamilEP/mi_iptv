import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/channel_info_overlay.dart';
import '../../../../core/widgets/mi_overlay_panel.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/stream_failure_recovery_overlay.dart';
import 'tv_live_tv_channel.dart';
import 'tv_live_tv_channel_list.dart';

/// TV Live TV hi-fi shell (DSN-033).
///
/// Video is dominant; channel list selects the current channel; info overlay
/// shows name, number, logo, and source; LIVE + active-source badges indicate
/// status. When [streamFailed] is true, [StreamFailureRecoveryOverlay] keeps
/// that channel context and offers recovery actions (DSN-039).
class TvLiveTvPage extends StatefulWidget {
  const TvLiveTvPage({
    super.key,
    this.channels = demoChannels,
    this.initialIndex = 0,
    this.showChannelList = true,
    this.streamFailed = false,
    this.failureMessage = StreamFailureRecoveryOverlay.defaultMessage,
    this.onRetry,
    this.onSwitchSource,
    this.onBackToChannels,
  });

  final List<TvLiveTvChannel> channels;
  final int initialIndex;
  final bool showChannelList;

  /// Whether the current channel's stream failed (DSN-039).
  final bool streamFailed;

  /// Actionable copy for [StreamFailureRecoveryOverlay].
  final String failureMessage;

  /// Called when Retry is activated on the recovery overlay.
  final VoidCallback? onRetry;

  /// Called when Switch source is activated on the recovery overlay.
  final VoidCallback? onSwitchSource;

  /// Called when Back to channels is activated on the recovery overlay.
  final VoidCallback? onBackToChannels;

  static const List<TvLiveTvChannel> demoChannels = <TvLiveTvChannel>[
    TvLiveTvChannel(
      number: '12',
      name: 'Signal News',
      sourceLabel: 'Home Xtream',
      nowPlaying: 'Evening briefing',
    ),
    TvLiveTvChannel(
      number: '24',
      name: 'Ember Sports',
      sourceLabel: 'Home Xtream',
      nowPlaying: 'Match center',
    ),
    TvLiveTvChannel(
      number: '41',
      name: 'Cloud Cinema',
      sourceLabel: 'M3U Playlist',
      nowPlaying: 'Feature presentation',
    ),
  ];

  @override
  State<TvLiveTvPage> createState() => _TvLiveTvPageState();
}

class _TvLiveTvPageState extends State<TvLiveTvPage> {
  late int _selectedIndex = widget.initialIndex.clamp(
    0,
    widget.channels.isEmpty ? 0 : widget.channels.length - 1,
  );
  final GlobalKey<ChannelInfoOverlayState> _infoKey =
      GlobalKey<ChannelInfoOverlayState>();
  bool _listVisible = true;

  TvLiveTvChannel? get _channel {
    if (widget.channels.isEmpty) return null;
    return widget.channels[_selectedIndex];
  }

  void _select(int index) {
    if (index < 0 || index >= widget.channels.length) return;
    setState(() => _selectedIndex = index);
    _infoKey.currentState?.reveal();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (widget.streamFailed) return KeyEventResult.ignored;
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _select(_selectedIndex - 1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _select(_selectedIndex + 1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      setState(() => _listVisible = !_listVisible);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final channel = _channel;
    final failedChannel = widget.streamFailed ? channel : null;
    final showList =
        widget.showChannelList && _listVisible && failedChannel == null;

    return Focus(
      autofocus: failedChannel == null,
      canRequestFocus: failedChannel == null,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: brand.ink,
        body: OverlayStage(
          topOverlay: channel == null
              ? null
              : ChannelInfoOverlay(
                  key: _infoKey,
                  channelNumber: channel.number,
                  channelTitle: channel.name,
                  sourceLabel: channel.sourceLabel,
                  nowPlaying: channel.nowPlaying,
                  autoHide: failedChannel == null,
                ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video-dominant stage (placeholder until player adapter lands).
              ColoredBox(
                color: brand.panel,
                child: Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 96,
                    color: brand.mist,
                    semanticLabel: 'Video',
                  ),
                ),
              ),
              Positioned(
                top: AppOverscan.inset,
                right: AppOverscan.inset,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const StatusBadge.live(),
                    const SizedBox(width: AppSpacing.sm),
                    StatusBadge.activeSource(
                      label: channel?.sourceLabel ??
                          StatusBadgeSpec.activeSource.label,
                    ),
                  ],
                ),
              ),
              if (showList && channel != null)
                Positioned(
                  left: AppOverscan.inset,
                  top: AppOverscan.inset + 120,
                  bottom: AppOverscan.inset,
                  child: TvLiveTvChannelList(
                    channels: widget.channels,
                    selectedIndex: _selectedIndex,
                    onSelected: _select,
                  ),
                ),
              if (failedChannel != null)
                Positioned.fill(
                  child: StreamFailureRecoveryOverlay(
                    channelNumber: failedChannel.number,
                    channelTitle: failedChannel.name,
                    sourceLabel: failedChannel.sourceLabel,
                    message: widget.failureMessage,
                    onRetry: widget.onRetry,
                    onSwitchSource: widget.onSwitchSource,
                    onBackToChannels: widget.onBackToChannels,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
