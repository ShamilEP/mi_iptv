import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/focusable_surface.dart';
import 'tv_epg_models.dart';

/// One focusable programme block on the EPG grid (DSN-060).
///
/// Current events pair Signal fill with a visible **Now** label (DSN-010).
class TvEpgEventCell extends StatelessWidget {
  const TvEpgEventCell({
    super.key,
    required this.event,
    required this.width,
    required this.onFocus,
    required this.onSelect,
    this.focusNode,
  });

  final TvEpgEvent event;
  final double width;
  final VoidCallback onFocus;
  final VoidCallback onSelect;
  final FocusNode? focusNode;

  static const double rowHeight = 72;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final fill = event.isCurrent ? brand.primary : brand.surface;
    final fg = event.isCurrent ? brand.ink : brand.cloud;

    return SizedBox(
      width: width,
      height: rowHeight,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xxs),
        child: FocusableSurface(
          key: ValueKey<String>('epg-event-${event.id}'),
          focusNode: focusNode,
          kind: FocusControlKind.card,
          fill: fill,
          borderRadius: AppRadius.sm,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus) onFocus();
          },
          onPressed: onSelect,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelLarge?.copyWith(color: fg),
                    ),
                  ),
                  if (event.isCurrent) ...[
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      TvEpgCopy.nowLabel,
                      style: textTheme.labelLarge?.copyWith(color: fg),
                    ),
                  ],
                ],
              ),
              if (event.subtitle.isNotEmpty)
                Text(
                  event.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelLarge?.copyWith(
                    color: event.isCurrent ? brand.ink : brand.mist,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
