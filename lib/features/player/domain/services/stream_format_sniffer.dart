import '../entities/stream_protocol.dart';

/// Content sniffing for IPTV URLs, including extension-less paths (TV-051 / SRS §16).
///
/// Pure Dart — no Flutter / Media3 imports. Prefer [protocolHint] when the
/// catalog already classified the source.
abstract final class StreamFormatSniffer {
  /// Resolves the Media3 source protocol for [uri].
  static StreamProtocol sniff(
    Uri uri, {
    StreamProtocol? protocolHint,
    String? catalogProtocol,
  }) {
    if (protocolHint != null && protocolHint != StreamProtocol.unknown) {
      return protocolHint;
    }
    if (catalogProtocol != null && catalogProtocol.trim().isNotEmpty) {
      final parsed = StreamProtocolWire.parse(catalogProtocol);
      if (parsed != StreamProtocol.unknown) return parsed;
    }

    final path = uri.path.toLowerCase();
    final query = uri.queryParameters.map(
      (key, value) => MapEntry(key.toLowerCase(), value.toLowerCase()),
    );

    if (_endsWithExt(path, const ['.m3u8', '.m3u']) ||
        path.contains('.m3u8') ||
        _querySays(query, const ['hls', 'm3u8', 'm3u'])) {
      return StreamProtocol.hls;
    }
    if (_endsWithExt(path, const ['.mpd']) ||
        _querySays(query, const ['dash', 'mpd'])) {
      return StreamProtocol.dash;
    }
    if (_endsWithExt(path, const ['.mp4', '.m4v', '.mov', '.m4a']) ||
        _querySays(query, const ['mp4', 'progressive'])) {
      return StreamProtocol.progressiveMp4;
    }
    if (_endsWithExt(path, const ['.ts', '.m2ts', '.mts']) ||
        _querySays(query, const ['ts', 'mpegts'])) {
      return StreamProtocol.progressiveTs;
    }

    // Extension-less IPTV: common live playlist path tokens without a suffix.
    final segments =
        path.split('/').where((segment) => segment.isNotEmpty).toList();
    final last = segments.isEmpty ? '' : segments.last;
    if (last.contains('playlist') ||
        last.contains('index') ||
        last == 'live' ||
        last.contains('chunklist')) {
      return StreamProtocol.hls;
    }

    return StreamProtocol.unknown;
  }

  static bool _endsWithExt(String path, List<String> exts) {
    for (final ext in exts) {
      if (path.endsWith(ext)) return true;
    }
    return false;
  }

  static bool _querySays(Map<String, String> query, List<String> tokens) {
    for (final entry in query.entries) {
      if (entry.key == 'format' ||
          entry.key == 'type' ||
          entry.key == 'protocol' ||
          entry.key == 'ext') {
        for (final token in tokens) {
          if (entry.value == token || entry.value.contains(token)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
