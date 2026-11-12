import '../../../catalog/domain/entities/content_item.dart';
import 'sync_metadata.dart';

/// Favorited catalog item shared by TV and Companion (domain — not UI chrome).
final class FavoriteEntry {
  const FavoriteEntry({
    required this.contentId,
    required this.contentType,
    required this.title,
    required this.order,
    required this.sync,
  });

  final String contentId;
  final ContentType contentType;
  final String title;
  final int order;
  final SyncMetadata sync;
}
