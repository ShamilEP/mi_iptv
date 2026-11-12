import '../../domain/entities/content_item.dart';
import '../../domain/repositories/catalog_repository.dart';

/// In-memory catalog seed for Sprint 0 shared-domain wiring (TV-005).
final class InMemoryCatalogRepository implements CatalogRepository {
  InMemoryCatalogRepository({List<ContentItem>? seed})
      : _items = <String, ContentItem>{
          for (final item in seed ?? demoCatalog) item.contentId: item,
        };

  final Map<String, ContentItem> _items;

  static final List<ContentItem> demoCatalog = <ContentItem>[
    ContentItem(
      contentId: 'ch-12',
      type: ContentType.channel,
      title: '12 Signal News',
    ),
    ContentItem(
      contentId: 'ch-24',
      type: ContentType.channel,
      title: '24 Ember Sports',
    ),
    ContentItem(
      contentId: 'vod-ember',
      type: ContentType.vodMovie,
      title: 'Ember Night',
    ),
  ];

  @override
  Future<List<ContentItem>> listContent() async {
    return List<ContentItem>.unmodifiable(_items.values.toList(growable: false));
  }

  @override
  Future<ContentItem?> getById(String contentId) async => _items[contentId];
}
