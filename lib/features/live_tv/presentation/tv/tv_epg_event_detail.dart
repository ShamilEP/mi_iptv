import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import 'tv_epg_models.dart';

/// Focused / selected programme detail strip under the EPG grid (DSN-060).
class TvEpgEventDetail extends StatelessWidget {
  const TvEpgEventDetail({
    super.key,
    required this.event,
    required this.channel,
  });

  final TvEpgEvent? event;
  final TvEpgChannel? channel;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final current = event;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: brand.panel,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: brand.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.insetCard),
        child: current == null
            ? Text(
                TvEpgCopy.emptyDetail,
                style: textTheme.bodyLarge?.copyWith(color: brand.mist),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    TvEpgCopy.detailHeading,
                    style: textTheme.labelLarge?.copyWith(color: brand.mist),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    current.title,
                    style: textTheme.headlineMedium?.copyWith(
                      color: brand.cloud,
                    ),
                  ),
                  if (channel != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${channel!.number}  ${channel!.name}',
                      style: textTheme.titleLarge?.copyWith(color: brand.mist),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _timeRange(current),
                    style: textTheme.bodyLarge?.copyWith(color: brand.cloud),
                  ),
                  if (current.subtitle.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      current.subtitle,
                      style: textTheme.bodyLarge?.copyWith(color: brand.mist),
                    ),
                  ],
                  if (current.isCurrent) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      TvEpgCopy.nowLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: brand.primary,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  static String _timeRange(TvEpgEvent event) {
    String stamp(int minute) {
      final hour = 20 + (minute ~/ 60);
      final min = minute % 60;
      return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    }

    return '${stamp(event.startMinute)} – ${stamp(event.endMinute)}';
  }
}
