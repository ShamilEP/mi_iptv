/// Kind for a Favorites row (DSN-036).
enum TvFavoritesKind { channel, vod }

/// One favorited channel or VOD title with stable list order.
class TvFavoritesItem {
  const TvFavoritesItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.order,
  });

  final String id;
  final String title;
  final String subtitle;
  final TvFavoritesKind kind;

  /// Stable ascending order within the Favorites list (lower = earlier).
  final int order;
}
