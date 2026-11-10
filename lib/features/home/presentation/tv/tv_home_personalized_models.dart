import 'package:flutter/foundation.dart';

/// Compact Home hero for Release 2 (DSN-070) — never replaces Live TV quick access.
@immutable
class TvHomeHeroContent {
  const TvHomeHeroContent({
    required this.title,
    required this.subtitle,
    this.ctaLabel = TvHomePersonalizedCopy.heroCta,
  });

  final String title;
  final String subtitle;
  final String ctaLabel;
}

/// One personalized recommendation rail (DSN-070).
@immutable
class TvHomeRecommendationRow {
  const TvHomeRecommendationRow({
    required this.id,
    required this.title,
    required this.items,
  });

  final String id;
  final String title;
  final List<String> items;
}

/// Locked copy for personalized Home (DSN-070).
abstract final class TvHomePersonalizedCopy {
  static const String heroCta = 'Watch now';
  static const String becauseYouWatchedPrefix = 'Because you watched';
  static const String recommendedForYou = 'Recommended for you';
  static const String heroLiveTvRule =
      'Live TV stays in the header — this hero never replaces it.';
}

const TvHomeHeroContent demoHomeHero = TvHomeHeroContent(
  title: 'Harbor Lights',
  subtitle: 'Tonight’s pick · Drama',
);

const List<TvHomeRecommendationRow> demoRecommendationRows =
    <TvHomeRecommendationRow>[
  TvHomeRecommendationRow(
    id: 'because-harbor',
    title: '${TvHomePersonalizedCopy.becauseYouWatchedPrefix} Harbor Lights',
    items: <String>['Night Run', 'Cloud Series', 'Ember Matchday'],
  ),
  TvHomeRecommendationRow(
    id: 'recommended',
    title: TvHomePersonalizedCopy.recommendedForYou,
    items: <String>['Signal Desk', 'Coastal Drive', 'Late Edition'],
  ),
];
