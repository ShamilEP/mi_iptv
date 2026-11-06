import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/mi_list_row.dart';
import '../../../../core/widgets/ui_state.dart';
import 'tv_live_tv_channel.dart';

/// Focusable channel selector rail for Live TV (DSN-033).
class TvLiveTvChannelList extends StatelessWidget {
  const TvLiveTvChannelList({
    super.key,
    required this.channels,
    required this.selectedIndex,
    required this.onSelected,
    this.width = 320,
  });

  final List<TvLiveTvChannel> channels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double width;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: brand.panel.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.sm),
          itemCount: channels.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final channel = channels[index];
            final selected = index == selectedIndex;
            return MiListRow(
              key: ValueKey<String>('live-channel-${channel.number}'),
              title: '${channel.number}  ${channel.name}',
              subtitle: channel.sourceLabel,
              state: selected ? UiState.selected : UiState.defaults,
              leading: Icon(
                Icons.live_tv_outlined,
                color: selected ? brand.primary : brand.mist,
                size: AppSpacing.lg,
              ),
              onPressed: () => onSelected(index),
            );
          },
        ),
      ),
    );
  }
}
