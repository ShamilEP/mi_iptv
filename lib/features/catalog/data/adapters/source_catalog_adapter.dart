import '../../domain/entities/content_item.dart';

/// Normalizes a third-party catalog feed into canonical [ContentItem]s.
abstract interface class SourceCatalogAdapter {
  String get kind;
  Future<List<ContentItem>> loadCatalog();
}
