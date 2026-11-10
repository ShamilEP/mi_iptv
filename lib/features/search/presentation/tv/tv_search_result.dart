/// One Search result row item (DSN-035).
enum TvSearchResultKind { channel, vod }

/// Demo / shell search hit.
class TvSearchResult {
  const TvSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final TvSearchResultKind kind;
}
