/// One Search result row item (TV DSN-035 / Companion CMP-041 shells).
enum SearchHitKind { channel, vod }

/// Demo / shell search hit (local catalog — no search API).
class SearchHit {
  const SearchHit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final SearchHitKind kind;
}

/// TV naming alias for existing call sites.
typedef TvSearchResult = SearchHit;

/// TV naming alias for existing call sites.
typedef TvSearchResultKind = SearchHitKind;
