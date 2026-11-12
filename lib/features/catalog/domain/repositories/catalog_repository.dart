import '../entities/content_item.dart';

/// Shared catalog port (TV + Companion). Implementations live in `data/`.
abstract interface class CatalogRepository {
  Future<List<ContentItem>> listContent();
  Future<ContentItem?> getById(String contentId);
}
