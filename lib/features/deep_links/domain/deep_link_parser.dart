import 'deep_link_parse_result.dart';
import 'deep_link_policy.dart';
import 'deep_link_target.dart';

/// Parses Companion deep links against [DeepLinkPolicy] (no Flutter imports).
abstract final class DeepLinkParser {
  static DeepLinkParseResult parse(Uri uri) {
    if (uri.scheme.toLowerCase() != DeepLinkPolicy.scheme) {
      return const DeepLinkParseUnsupported('scheme');
    }
    if (uri.host.toLowerCase() != DeepLinkPolicy.host) {
      return const DeepLinkParseUnsupported('host');
    }

    final path = uri.path;
    if (path.startsWith(DeepLinkPolicy.vodPathPrefix)) {
      final id = path.substring(DeepLinkPolicy.vodPathPrefix.length);
      if (!_validId(id)) {
        return const DeepLinkParseUnsupported('vod-id');
      }
      return DeepLinkParseSuccess(
        DeepLinkTarget(kind: DeepLinkKind.vod, id: id),
      );
    }
    if (path.startsWith(DeepLinkPolicy.livePathPrefix)) {
      final id = path.substring(DeepLinkPolicy.livePathPrefix.length);
      if (!_validId(id)) {
        return const DeepLinkParseUnsupported('live-id');
      }
      return DeepLinkParseSuccess(
        DeepLinkTarget(kind: DeepLinkKind.liveChannel, id: id),
      );
    }
    return const DeepLinkParseUnsupported('path');
  }

  static bool _validId(String id) {
    if (id.isEmpty || id.contains('/')) return false;
    return RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(id);
  }
}
