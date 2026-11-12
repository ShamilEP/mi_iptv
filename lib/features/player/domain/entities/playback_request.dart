import 'stream_protocol.dart';

/// UI-independent playback start request (TV-051).
///
/// Carries optional protocol hint, HTTP headers, and User-Agent for IPTV
/// sources. Never log [headers] values or credential-bearing [streamUri]s.
final class PlaybackRequest {
  const PlaybackRequest({
    required this.streamUri,
    this.protocolHint,
    this.headers = const <String, String>{},
    this.userAgent,
  });

  final Uri streamUri;

  /// Caller-known protocol (catalog `protocol` field). When null, sniff URI.
  final StreamProtocol? protocolHint;

  /// Extra HTTP request headers (e.g. `Referer`, `Authorization`).
  final Map<String, String> headers;

  /// Optional User-Agent override for the HTTP data source.
  final String? userAgent;
}
