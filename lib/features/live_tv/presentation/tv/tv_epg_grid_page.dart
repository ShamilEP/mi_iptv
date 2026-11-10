import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import 'tv_epg_event_detail.dart';
import 'tv_epg_grid.dart';
import 'tv_epg_models.dart';

/// TV EPG channel × time grid design shell (DSN-060).
///
/// Block-level D-pad focus, highlighted current programme, persistent focus
/// via [FocusNode] map, and an event detail strip. No schedule API calls.
class TvEpgGridPage extends StatefulWidget {
  const TvEpgGridPage({
    super.key,
    this.channels = demoChannels,
    this.windowMinutes = 150,
    this.pixelsPerMinute = 4,
    this.initialFocusEventId,
    this.onEventSelected,
  });

  final List<TvEpgChannel> channels;
  final int windowMinutes;
  final double pixelsPerMinute;
  final String? initialFocusEventId;
  final ValueChanged<TvEpgEvent>? onEventSelected;

  static const List<TvEpgChannel> demoChannels = <TvEpgChannel>[
    TvEpgChannel(
      number: '12',
      name: 'Signal News',
      events: <TvEpgEvent>[
        TvEpgEvent(
          id: '12-a',
          title: 'Evening bulletin',
          startMinute: 0,
          durationMinutes: 45,
          subtitle: 'Headlines',
          isCurrent: true,
        ),
        TvEpgEvent(
          id: '12-b',
          title: 'World desk',
          startMinute: 45,
          durationMinutes: 45,
          subtitle: 'Analysis',
        ),
        TvEpgEvent(
          id: '12-c',
          title: 'Late edition',
          startMinute: 90,
          durationMinutes: 60,
          subtitle: 'Recap',
        ),
      ],
    ),
    TvEpgChannel(
      number: '24',
      name: 'Ember Sports',
      events: <TvEpgEvent>[
        TvEpgEvent(
          id: '24-a',
          title: 'Match preview',
          startMinute: 0,
          durationMinutes: 30,
          subtitle: 'Studio',
        ),
        TvEpgEvent(
          id: '24-b',
          title: 'Live kickoff',
          startMinute: 30,
          durationMinutes: 90,
          subtitle: 'League',
          isCurrent: true,
        ),
        TvEpgEvent(
          id: '24-c',
          title: 'Post-match',
          startMinute: 120,
          durationMinutes: 30,
          subtitle: 'Interviews',
        ),
      ],
    ),
    TvEpgChannel(
      number: '48',
      name: 'Cloud Cinema',
      events: <TvEpgEvent>[
        TvEpgEvent(
          id: '48-a',
          title: 'Harbor Lights',
          startMinute: 0,
          durationMinutes: 120,
          subtitle: 'Drama',
          isCurrent: true,
        ),
        TvEpgEvent(
          id: '48-b',
          title: 'Night Run',
          startMinute: 120,
          durationMinutes: 30,
          subtitle: 'Action short',
        ),
      ],
    ),
  ];

  @override
  State<TvEpgGridPage> createState() => _TvEpgGridPageState();
}

class _TvEpgGridPageState extends State<TvEpgGridPage> {
  late final Map<String, FocusNode> _nodes = <String, FocusNode>{};
  String? _focusedId;
  TvEpgEvent? _detailEvent;
  TvEpgChannel? _detailChannel;

  @override
  void initState() {
    super.initState();
    for (final channel in widget.channels) {
      for (final event in channel.events) {
        _nodes[event.id] = FocusNode(debugLabel: 'epg-${event.id}');
      }
    }
    final initialId = widget.initialFocusEventId ?? _firstCurrentId();
    final initial = _findEvent(initialId);
    _focusedId = initial?.$2.id;
    _detailEvent = initial?.$2;
    _detailChannel = initial?.$1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _focusedId == null) return;
      _nodes[_focusedId!]?.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final node in _nodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  String? _firstCurrentId() {
    for (final channel in widget.channels) {
      for (final event in channel.events) {
        if (event.isCurrent) return event.id;
      }
    }
    return widget.channels.firstOrNull?.events.firstOrNull?.id;
  }

  (TvEpgChannel, TvEpgEvent)? _findEvent(String? id) {
    if (id == null) return null;
    for (final channel in widget.channels) {
      for (final event in channel.events) {
        if (event.id == id) return (channel, event);
      }
    }
    return null;
  }

  void _onFocused(TvEpgEvent event) {
    final found = _findEvent(event.id);
    setState(() {
      _focusedId = event.id;
      _detailEvent = event;
      _detailChannel = found?.$1;
    });
  }

  void _onSelected(TvEpgEvent event) {
    _onFocused(event);
    widget.onEventSelected?.call(event);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return TvAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.ink,
        body: Padding(
          padding: AppOverscan.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandLockup(markHeight: AppSpacing.xxl),
              const SizedBox(height: AppSpacing.md),
              Text(
                TvEpgCopy.title,
                style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: TvEpgGrid(
                  channels: widget.channels,
                  windowMinutes: widget.windowMinutes,
                  pixelsPerMinute: widget.pixelsPerMinute,
                  focusNodes: _nodes,
                  onEventFocused: _onFocused,
                  onEventSelected: _onSelected,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TvEpgEventDetail(
                event: _detailEvent,
                channel: _detailChannel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
