import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import 'tv_epg_event_cell.dart';
import 'tv_epg_models.dart';

/// Channel × time EPG grid with block-level D-pad focus (DSN-060).
class TvEpgGrid extends StatelessWidget {
  const TvEpgGrid({
    super.key,
    required this.channels,
    required this.windowMinutes,
    required this.pixelsPerMinute,
    required this.focusedEventId,
    required this.onEventFocused,
    required this.onEventSelected,
    required this.focusNodes,
    this.timeMarks = const <int>[0, 30, 60, 90, 120],
  });

  final List<TvEpgChannel> channels;
  final int windowMinutes;
  final double pixelsPerMinute;
  final String? focusedEventId;
  final ValueChanged<TvEpgEvent> onEventFocused;
  final ValueChanged<TvEpgEvent> onEventSelected;
  final Map<String, FocusNode> focusNodes;
  final List<int> timeMarks;

  double get _gridWidth => windowMinutes * pixelsPerMinute;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 200,
              child: Text(
                TvEpgCopy.windowLabel,
                style: textTheme.labelLarge?.copyWith(color: brand.mist),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: _gridWidth,
                  child: Row(
                    children: [
                      for (final mark in timeMarks)
                        SizedBox(
                          width: 30 * pixelsPerMinute,
                          child: Text(
                            _formatMark(mark),
                            style: textTheme.labelLarge?.copyWith(
                              color: brand.mist,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ListView.separated(
            itemCount: channels.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              final channel = channels[index];
              return SizedBox(
                height: TvEpgEventCell.rowHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${channel.number}  ${channel.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleLarge?.copyWith(
                            color: brand.cloud,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: _gridWidth,
                          child: Row(
                            children: [
                              for (final event in channel.events)
                                TvEpgEventCell(
                                  event: event,
                                  width:
                                      event.durationMinutes * pixelsPerMinute,
                                  focusNode: focusNodes[event.id],
                                  onFocus: () => onEventFocused(event),
                                  onSelect: () => onEventSelected(event),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static String _formatMark(int minute) {
    final hour = 20 + (minute ~/ 60);
    final min = minute % 60;
    return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }
}
