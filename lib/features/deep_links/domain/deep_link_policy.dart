/// Interim HTTPS deep-link scheme for CMP-050 / FR-030 (Release 1 lock).
abstract final class DeepLinkPolicy {
  static const String scheme = 'https';
  static const String host = 'link.mi-iptv.app';
  static const String vodPathPrefix = '/vod/';
  static const String livePathPrefix = '/live/';
}
