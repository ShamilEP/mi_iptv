import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/content_card.dart';
import '../../../../core/widgets/content_row.dart';
import '../../../../core/widgets/content_row_list.dart';
import 'tv_home_hero.dart';
import 'tv_home_personalized_models.dart';
import 'tv_home_quick_access.dart';
import 'tv_home_page.dart';

/// Release 2 personalized Home shell (DSN-070).
///
/// Adds a **compact** hero and recommendation rows while keeping Live TV in
/// the header quick-access rail (never displaced). Continue watching remains
/// the first content rail under the hero.
class TvPersonalizedHomePage extends StatefulWidget {
  const TvPersonalizedHomePage({
    super.key,
    this.hero = demoHomeHero,
    this.recommendations = demoRecommendationRows,
    this.onQuickAccess,
    this.onHeroWatch,
    this.onRecommendationSelected,
  });

  final TvHomeHeroContent hero;
  final List<TvHomeRecommendationRow> recommendations;
  final ValueChanged<TvHomeQuickDestination>? onQuickAccess;
  final VoidCallback? onHeroWatch;
  final ValueChanged<String>? onRecommendationSelected;

  @override
  State<TvPersonalizedHomePage> createState() => _TvPersonalizedHomePageState();
}

class _TvPersonalizedHomePageState extends State<TvPersonalizedHomePage> {
  final GlobalKey<ContentRowState> _continueRowKey = GlobalKey<ContentRowState>();

  static const _continueWatching =
      <({String title, String subtitle, double progress})>[
    (title: 'Evening news', subtitle: 'Live catch-up', progress: 0.35),
    (title: 'Series night', subtitle: 'S1 E4', progress: 0.6),
    (title: 'Film pick', subtitle: 'Almost done', progress: 0.85),
  ];

  static const _liveChannels = <String>[
    'Channel 1',
    'Channel 2',
    'Channel 3',
    'Channel 4',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _continueRowKey.currentState?.requestFocusAt(0);
    });
  }

  int get _rowCount => 2 + widget.recommendations.length + 1;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;

    return TvAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.ink,
        body: Padding(
          padding: AppOverscan.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandLockup(markHeight: 56),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: TvHomeQuickAccess(
                      onSelected: widget.onQuickAccess,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TvHomeHero(
                content: widget.hero,
                onWatch: widget.onHeroWatch,
              ),
              const SizedBox(height: AppSpacing.stack),
              Expanded(
                child: ContentRowList(
                  rowCount: _rowCount,
                  rowBuilder: (context, rowIndex) {
                    if (rowIndex == 0) {
                      return ContentRow(
                        key: _continueRowKey,
                        title: TvHomePage.continueWatchingTitle,
                        storageId: 'home-r2-continue-watching',
                        kind: ContentCardKind.continueWatching,
                        itemCount: _continueWatching.length,
                        itemBuilder: (context, index, focusNode) {
                          final item = _continueWatching[index];
                          return ContentCard(
                            kind: ContentCardKind.continueWatching,
                            title: item.title,
                            subtitle: item.subtitle,
                            progress: item.progress,
                            focusNode: focusNode,
                            onPressed: () {},
                          );
                        },
                      );
                    }

                    final recIndex = rowIndex - 1;
                    if (recIndex < widget.recommendations.length) {
                      final row = widget.recommendations[recIndex];
                      return ContentRow(
                        title: row.title,
                        storageId: 'home-r2-rec-${row.id}',
                        kind: ContentCardKind.poster,
                        itemCount: row.items.length,
                        itemBuilder: (context, index, focusNode) {
                          final title = row.items[index];
                          return ContentCard(
                            key: ValueKey<String>('home-rec-${row.id}-$index'),
                            kind: ContentCardKind.poster,
                            title: title,
                            focusNode: focusNode,
                            onPressed: () =>
                                widget.onRecommendationSelected?.call(title),
                          );
                        },
                      );
                    }

                    return ContentRow(
                      title: TvHomePage.liveChannelsTitle,
                      storageId: 'home-r2-live-channels',
                      kind: ContentCardKind.channelTile,
                      itemCount: _liveChannels.length,
                      itemBuilder: (context, index, focusNode) {
                        return ContentCard(
                          kind: ContentCardKind.channelTile,
                          title: _liveChannels[index],
                          focusNode: focusNode,
                          onPressed: () {},
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
