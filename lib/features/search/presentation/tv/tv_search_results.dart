import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/content_card.dart';
import '../../../../core/widgets/status_pattern.dart';
import '../../../../core/widgets/status_pattern_copy.dart';
import 'tv_search_copy.dart';
import 'tv_search_result.dart';

/// Channels and VOD result groups with visible card focus (DSN-035).
class TvSearchResults extends StatelessWidget {
  const TvSearchResults({
    super.key,
    required this.channels,
    required this.vod,
    this.onClear,
    this.onSelected,
  });

  final List<TvSearchResult> channels;
  final List<TvSearchResult> vod;
  final VoidCallback? onClear;
  final ValueChanged<TvSearchResult>? onSelected;

  bool get isEmpty => channels.isEmpty && vod.isEmpty;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return EmptyPattern(
        copy: const StatusPatternCopy(
          title: TvSearchCopy.emptyTitle,
          message: TvSearchCopy.emptyMessage,
          actionLabel: TvSearchCopy.emptyAction,
        ),
        onAction: onClear,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (channels.isNotEmpty) ...[
          _Group(
            title: TvSearchCopy.channelsGroup,
            items: channels,
            kind: ContentCardKind.channelTile,
            onSelected: onSelected,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (vod.isNotEmpty)
          _Group(
            title: TvSearchCopy.vodGroup,
            items: vod,
            kind: ContentCardKind.poster,
            onSelected: onSelected,
          ),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.items,
    required this.kind,
    this.onSelected,
  });

  final String title;
  final List<TvSearchResult> items;
  final ContentCardKind kind;
  final ValueChanged<TvSearchResult>? onSelected;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final height = ContentCardMetrics.sizeOf(kind).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleLarge?.copyWith(color: brand.cloud)),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppGrid.gutter),
            itemBuilder: (context, index) {
              final item = items[index];
              return ContentCard(
                key: ValueKey<String>('search-${item.id}'),
                kind: kind,
                title: item.title,
                subtitle: item.subtitle,
                onPressed: onSelected == null ? null : () => onSelected!(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
