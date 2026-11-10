import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/content_card.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_icon.dart';
import 'companion_explore_copy.dart';
import 'companion_explore_item.dart';

/// Showcase catalog rails for Companion Explore (DSN-052).
class CompanionExploreCatalog extends StatelessWidget {
  const CompanionExploreCatalog({
    super.key,
    required this.featured,
    required this.live,
    required this.movies,
    required this.onSelect,
  });

  final List<CompanionExploreItem> featured;
  final List<CompanionExploreItem> live;
  final List<CompanionExploreItem> movies;
  final ValueChanged<CompanionExploreItem> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Rail(
          title: CompanionExploreCopy.featuredTitle,
          items: featured,
          kind: ContentCardKind.landscape,
          onSelect: onSelect,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Rail(
          title: CompanionExploreCopy.liveTitle,
          items: live,
          kind: ContentCardKind.channelTile,
          onSelect: onSelect,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Rail(
          title: CompanionExploreCopy.moviesTitle,
          items: movies,
          kind: ContentCardKind.poster,
          onSelect: onSelect,
        ),
      ],
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({
    required this.title,
    required this.items,
    required this.kind,
    required this.onSelect,
  });

  final String title;
  final List<CompanionExploreItem> items;
  final ContentCardKind kind;
  final ValueChanged<CompanionExploreItem> onSelect;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleLarge?.copyWith(color: brand.ink)),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: ContentCardMetrics.sizeOf(kind).height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppGrid.gutter),
            itemBuilder: (context, index) {
              final item = items[index];
              return ContentCard(
                key: ValueKey<String>('explore-${item.id}'),
                kind: kind,
                title: item.title,
                subtitle: item.subtitle,
                onPressed: () => onSelect(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Selected title detail with Send-to-TV CTA and no local player.
class CompanionExploreDetail extends StatelessWidget {
  const CompanionExploreDetail({
    super.key,
    required this.item,
    required this.tvName,
    required this.onSendToTv,
    required this.onBack,
    this.sentLabel,
  });

  final CompanionExploreItem item;
  final String tvName;
  final VoidCallback onSendToTv;
  final VoidCallback onBack;
  final String? sentLabel;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final kind = switch (item.kind) {
      CompanionExploreKind.featured => ContentCardKind.landscape,
      CompanionExploreKind.live => ContentCardKind.channelTile,
      CompanionExploreKind.movies => ContentCardKind.poster,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CompanionExploreCopy.detailTitle,
          style: textTheme.headlineMedium?.copyWith(color: brand.ink),
        ),
        const SizedBox(height: AppSpacing.md),
        ContentCard(kind: kind, title: item.title, subtitle: item.subtitle),
        const SizedBox(height: AppSpacing.md),
        Text(
          item.title,
          style: textTheme.titleLarge?.copyWith(color: brand.ink),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          item.subtitle,
          style: textTheme.bodyLarge?.copyWith(color: brand.muted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            MiIcon(
              role: IconRole.devices,
              color: brand.ink,
              size: AppSpacing.lg,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                tvName,
                style: textTheme.labelLarge?.copyWith(color: brand.ink),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          CompanionExploreCopy.noPlayerNote,
          style: textTheme.bodyLarge?.copyWith(color: brand.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: MiButton(
            label: CompanionExploreCopy.sendToTvLabel,
            emphasis: ControlEmphasis.sendToTv,
            onPressed: onSendToTv,
          ),
        ),
        if (sentLabel != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            sentLabel!,
            style: textTheme.bodyLarge?.copyWith(color: brand.ink),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        MiButton(
          label: CompanionExploreCopy.backToCatalogLabel,
          emphasis: ControlEmphasis.secondary,
          onPressed: onBack,
        ),
      ],
    );
  }
}
