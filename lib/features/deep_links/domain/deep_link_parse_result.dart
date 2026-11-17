import 'deep_link_target.dart';

/// Outcome of parsing an inbound URI (CMP-050).
sealed class DeepLinkParseResult {
  const DeepLinkParseResult();
}

final class DeepLinkParseSuccess extends DeepLinkParseResult {
  const DeepLinkParseSuccess(this.target);
  final DeepLinkTarget target;
}

final class DeepLinkParseUnsupported extends DeepLinkParseResult {
  const DeepLinkParseUnsupported([this.reason = 'unsupported']);
  final String reason;
}
