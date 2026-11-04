/// Canonical content model (normalized from M3U / Xtream / proprietary).
enum ContentType { channel, vodMovie, vodSeries }

final class ContentArtwork {
  const ContentArtwork({this.poster, this.banner});
  final Uri? poster;
  final Uri? banner;
}

final class ContentSourceRef {
  const ContentSourceRef({
    required this.sourceId,
    required this.kind,
    required this.streamUri,
    required this.protocol,
    this.priority = 1,
  });

  final String sourceId;
  final String kind; // proprietary | xtream | m3u
  final Uri streamUri;
  final String protocol; // hls | dash | ts
  final int priority;
}

final class ContentItem {
  const ContentItem({
    required this.contentId,
    required this.type,
    required this.title,
    this.artwork = const ContentArtwork(),
    this.genres = const [],
    this.sources = const [],
  });

  final String contentId;
  final ContentType type;
  final String title;
  final ContentArtwork artwork;
  final List<String> genres;
  final List<ContentSourceRef> sources;
}
