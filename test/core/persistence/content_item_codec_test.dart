import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/persistence/drift/content_item_codec.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';

void main() {
  const codec = ContentItemCodec();

  test('strips URI credentials when encoding content sources', () {
    final item = ContentItem(
      contentId: 'ch-1',
      type: ContentType.channel,
      title: 'News',
      artwork: ContentArtwork(
        poster: Uri.parse('https://user:secret@cdn.example/p.jpg'),
      ),
      sources: [
        ContentSourceRef(
          sourceId: 'src-1',
          kind: 'm3u',
          streamUri: Uri.parse('https://user:pass@stream.example/live.ts'),
          protocol: 'ts',
        ),
      ],
    );

    final row = codec.encodeRow(item);
    expect(row['posterUrl'], 'https://cdn.example/p.jpg');
    expect(row['sourcesJson'], isNot(contains('user')));
    expect(row['sourcesJson'], isNot(contains('pass')));
    expect(row['sourcesJson'], contains('https://stream.example/live.ts'));

    final decoded = codec.decodeRow(
      contentId: row['contentId']! as String,
      type: row['type']! as String,
      title: row['title']! as String,
      posterUrl: row['posterUrl'] as String?,
      bannerUrl: row['bannerUrl'] as String?,
      genresJson: row['genresJson']! as String,
      sourcesJson: row['sourcesJson']! as String,
    );
    expect(decoded.artwork.poster?.userInfo, isEmpty);
    expect(decoded.sources.single.streamUri.userInfo, isEmpty);
  });
}
