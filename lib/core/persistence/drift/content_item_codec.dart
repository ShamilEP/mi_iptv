import 'dart:convert';

import '../../../features/catalog/domain/entities/content_item.dart';

/// Serialize / deserialize [ContentItem] for SQLite JSON columns (TV-007).
///
/// Stream and artwork URIs are persisted **without** userInfo so credentials
/// never land in the local DB.
final class ContentItemCodec {
  const ContentItemCodec();

  Map<String, Object?> encodeRow(ContentItem item) {
    return {
      'contentId': item.contentId,
      'type': item.type.name,
      'title': item.title,
      'posterUrl': _uriString(item.artwork.poster),
      'bannerUrl': _uriString(item.artwork.banner),
      'genresJson': jsonEncode(item.genres),
      'sourcesJson': jsonEncode(
        item.sources.map(_encodeSource).toList(growable: false),
      ),
    };
  }

  ContentItem decodeRow({
    required String contentId,
    required String type,
    required String title,
    String? posterUrl,
    String? bannerUrl,
    required String genresJson,
    required String sourcesJson,
  }) {
    final genres = (jsonDecode(genresJson) as List<dynamic>)
        .map((e) => e as String)
        .toList(growable: false);
    final sourcesRaw = jsonDecode(sourcesJson) as List<dynamic>;
    final sources = sourcesRaw
        .map((e) => _decodeSource(e as Map<String, dynamic>))
        .toList(growable: false);

    return ContentItem(
      contentId: contentId,
      type: ContentType.values.byName(type),
      title: title,
      artwork: ContentArtwork(
        poster: _parseUri(posterUrl),
        banner: _parseUri(bannerUrl),
      ),
      genres: genres,
      sources: sources,
    );
  }

  Map<String, Object?> _encodeSource(ContentSourceRef source) {
    return {
      'sourceId': source.sourceId,
      'kind': source.kind,
      'streamUri': _uriString(source.streamUri)!,
      'protocol': source.protocol,
      'priority': source.priority,
    };
  }

  ContentSourceRef _decodeSource(Map<String, dynamic> json) {
    return ContentSourceRef(
      sourceId: json['sourceId'] as String,
      kind: json['kind'] as String,
      streamUri: Uri.parse(json['streamUri'] as String),
      protocol: json['protocol'] as String,
      priority: json['priority'] as int? ?? 1,
    );
  }

  String? _uriString(Uri? uri) {
    if (uri == null) return null;
    return _stripCredentials(uri).toString();
  }

  Uri? _parseUri(String? value) {
    if (value == null || value.isEmpty) return null;
    return _stripCredentials(Uri.parse(value));
  }

  Uri _stripCredentials(Uri uri) {
    if (uri.userInfo.isEmpty) return uri;
    return uri.replace(userInfo: '');
  }
}
