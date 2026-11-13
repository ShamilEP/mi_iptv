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
    this.favorites = const <CompanionExploreItem>[],
    required this.onSelect,
    this.cachedLabels = false,
    this.featuredTitle,
    this.liveTitle,
    this.moviesTitle,
    this.favoritesTitle,
  });

  final List<CompanionExploreItem> featured;
  final List<CompanionExploreItem> live;
  final List<CompanionExploreItem> movies;
  final List<CompanionExploreItem> favorites;
  final ValueChanged<CompanionExploreItem> onSelect;

  /// Appends `(cached)` to rail titles when offline-with-cache (CMP-006).
  final bool cachedLabels;

  final String? featuredTitle;
  final String? liveTitle;
  final String? moviesTitle;
  final String? favoritesTitle;

  String _title(String base) => cachedLabels ? '$base (cached)' : base;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Rail(
          title: _title(featuredTitle ?? CompanionExploreCopy.featuredTitle),
          items: featured,
          kind: ContentCardKind.landscape,
          onSelect: onSelect,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Rail(
          title: _title(liveTitle ?? CompanionExploreCopy.liveTitle),
          items: live,
          kind: ContentCardKind.channelTile,
          onSelect: onSelect,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Rail(
          title: _title(moviesTitle ?? CompanionExploreCopy.moviesTitle),
          items: movies,
          kind: ContentCardKind.poster,
          onSelect: onSelect,
        ),
        if (favorites.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _Rail(
            title: _title(favoritesTitle ?? CompanionExploreCopy.favoritesTitle),
            items: favorites,
            kind: ContentCardKind.poster,
            onSelect: onSelect,
          ),
        ],
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
          // Grow with Dynamic Type so titles remain reachable (CMP-063).
          height: MediaQuery.textScalerOf(context).scale(
            ContentCardMetrics.sizeOf(kind).height,
          ),
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
    this.detailTitle,
    this.sendLabel,
    this.noPlayerNote,
    this.backLabel,
  });

  final CompanionExploreItem item;
  final String tvName;
  final VoidCallback onSendToTv;
  final VoidCallback onBack;
  final String? sentLabel;
  final String? detailTitle;
  final String? sendLabel;
  final String? noPlayerNote;
  final String? backLabel;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final kind = switch (item.kind) {
      CompanionExploreKind.featured => ContentCardKind.landscape,
      CompanionExploreKind.live => ContentCardKind.channelTile,
      CompanionExploreKind.movies ||
      CompanionExploreKind.favorites =>
        ContentCardKind.poster,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detailTitle ?? CompanionExploreCopy.detailTitle,
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
          noPlayerNote ?? CompanionExploreCopy.noPlayerNote,
          style: textTheme.bodyLarge?.copyWith(color: brand.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: MiButton(
            label: sendLabel ?? CompanionExploreCopy.sendToTvLabel,
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
          label: backLabel ?? CompanionExploreCopy.backToCatalogLabel,
          emphasis: ControlEmphasis.secondary,
          onPressed: onBack,
        ),
      ],
    );
  }
}
