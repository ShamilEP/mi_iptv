import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/content_card.dart';
import '../../../../core/widgets/content_row.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import 'tv_content_detail_copy.dart';
import 'tv_content_detail_models.dart';

/// TV Content detail hi-fi shell (DSN-034 / FR-012 / US-12).
///
/// Large art, title, metadata, synopsis, Play / Resume / Favorite, and a
/// Related rail. Season/episode navigation is intentionally omitted (PRD-013).
class TvContentDetailPage extends StatefulWidget {
  const TvContentDetailPage({
    super.key,
    this.detail = demoDetail,
    this.onPlay,
    this.onResume,
    this.onFavoriteChanged,
    this.onRelatedSelected,
  });

  final TvContentDetail detail;
  final ValueChanged<TvContentDetail>? onPlay;
  final ValueChanged<TvContentDetail>? onResume;
  final ValueChanged<TvContentDetail>? onFavoriteChanged;
  final ValueChanged<TvRelatedContent>? onRelatedSelected;

  /// Demo VOD with resume progress and related titles.
  static const TvContentDetail demoDetail = TvContentDetail(
    id: 'vod-harbor-lights',
    title: 'Harbor Lights',
    synopsis:
        'A coastal detective returns home to untangle a blackout that '
        'swallows the harbor — and the people who keep its secrets.',
    metadata: <String>['2024', 'PG-13', 'Thriller', 'Movie'],
    durationLabel: '1h 48m',
    progress: 0.42,
    isFavorite: false,
    related: <TvRelatedContent>[
      TvRelatedContent(id: 'vod-night-run', title: 'Night Run', subtitle: 'Movie'),
      TvRelatedContent(
        id: 'vod-ember-tide',
        title: 'Ember Tide',
        subtitle: 'Movie',
      ),
      TvRelatedContent(
        id: 'vod-signal-fog',
        title: 'Signal Fog',
        subtitle: 'Movie',
      ),
    ],
  );

  /// Large poster width for the detail hero (2:3).
  static const double heroArtWidth = 280;

  @override
  State<TvContentDetailPage> createState() => _TvContentDetailPageState();
}

class _TvContentDetailPageState extends State<TvContentDetailPage> {
  late TvContentDetail _detail = widget.detail;

  @override
  void didUpdateWidget(covariant TvContentDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.detail != widget.detail) {
      _detail = widget.detail;
    }
  }

  void _toggleFavorite() {
    setState(() {
      _detail = _detail.copyWith(isFavorite: !_detail.isFavorite);
    });
    widget.onFavoriteChanged?.call(_detail);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final artSize = ContentCardMetrics.sizeOf(
      ContentCardKind.poster,
      width: TvContentDetailPage.heroArtWidth,
    );

    return TvAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.ink,
        body: Padding(
          padding: AppOverscan.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroArt(
                            title: _detail.title,
                            width: artSize.width,
                            height: artSize.height,
                          ),
                          const SizedBox(width: AppSpacing.xl),
                          Expanded(
                            child: _DetailBody(
                              detail: _detail,
                              textTheme: textTheme,
                              brand: brand,
                              onPlay: () => widget.onPlay?.call(_detail),
                              onResume: () => widget.onResume?.call(_detail),
                              onFavorite: _toggleFavorite,
                            ),
                          ),
                        ],
                      ),
                      if (_detail.related.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        ContentRow(
                          key: const ValueKey<String>('detail-related'),
                          title: TvContentDetailCopy.relatedTitle,
                          kind: ContentCardKind.poster,
                          storageId: 'dsn-034-related',
                          itemCount: _detail.related.length,
                          itemBuilder: (context, index, focusNode) {
                            final item = _detail.related[index];
                            return ContentCard(
                              key: ValueKey<String>('related-${item.id}'),
                              kind: ContentCardKind.poster,
                              title: item.title,
                              subtitle: item.subtitle,
                              focusNode: focusNode,
                              onPressed: () =>
                                  widget.onRelatedSelected?.call(item),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroArt extends StatelessWidget {
  const _HeroArt({
    required this.title,
    required this.width,
    required this.height,
  });

  final String title;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return SizedBox(
      key: const ValueKey<String>('detail-hero-art'),
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: brand.panel,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: brand.border),
        ),
        child: Center(
          child: Icon(
            Icons.movie_outlined,
            size: AppSpacing.xxxl,
            color: brand.mist,
            semanticLabel: title,
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.textTheme,
    required this.brand,
    required this.onPlay,
    required this.onResume,
    required this.onFavorite,
  });

  final TvContentDetail detail;
  final TextTheme textTheme;
  final MiBrandColors brand;
  final VoidCallback onPlay;
  final VoidCallback onResume;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.title,
          key: const ValueKey<String>('detail-title'),
          style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final chip in detail.metadata)
              _MetaChip(label: chip, brand: brand, textTheme: textTheme),
            if (detail.durationLabel != null)
              _MetaChip(
                label: detail.durationLabel!,
                brand: brand,
                textTheme: textTheme,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          detail.synopsis,
          key: const ValueKey<String>('detail-synopsis'),
          style: textTheme.bodyLarge?.copyWith(color: brand.mist),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            MiButton(
              key: const ValueKey<String>('detail-play'),
              label: TvContentDetailCopy.playLabel,
              emphasis: ControlEmphasis.primary,
              onPressed: onPlay,
            ),
            if (detail.showsResume)
              MiButton(
                key: const ValueKey<String>('detail-resume'),
                label: TvContentDetailCopy.resumeLabel,
                emphasis: ControlEmphasis.secondary,
                onPressed: onResume,
              ),
            MiButton(
              key: const ValueKey<String>('detail-favorite'),
              label: detail.isFavorite
                  ? TvContentDetailCopy.favoritedLabel
                  : TvContentDetailCopy.favoriteLabel,
              emphasis: ControlEmphasis.secondary,
              onPressed: onFavorite,
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.brand,
    required this.textTheme,
  });

  final String label;
  final MiBrandColors brand;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: brand.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(color: brand.cloud),
        ),
      ),
    );
  }
}
