/// Resolved deep-link destination (Companion opens detail / send-to-TV).
enum DeepLinkKind { vod, liveChannel }

final class DeepLinkTarget {
  const DeepLinkTarget({required this.kind, required this.id});

  final DeepLinkKind kind;
  final String id;
}
