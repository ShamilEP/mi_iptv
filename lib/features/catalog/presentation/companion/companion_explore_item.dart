/// Showcase catalog entry for Companion Explore (DSN-052).
class CompanionExploreItem {
  const CompanionExploreItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final CompanionExploreKind kind;
}

/// Showcase row kinds on Explore.
enum CompanionExploreKind { featured, live, movies, favorites }
