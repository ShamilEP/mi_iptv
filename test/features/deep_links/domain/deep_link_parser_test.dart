import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/deep_links/domain/deep_link_parse_result.dart';
import 'package:mi_iptv/features/deep_links/domain/deep_link_parser.dart';
import 'package:mi_iptv/features/deep_links/domain/deep_link_policy.dart';
import 'package:mi_iptv/features/deep_links/domain/deep_link_target.dart';

void main() {
  group('CMP-050 DeepLinkParser', () {
    test('parses vod and live https paths on the interim host', () {
      final vod = DeepLinkParser.parse(
        Uri.parse('https://${DeepLinkPolicy.host}/vod/movie-1'),
      );
      expect(vod, isA<DeepLinkParseSuccess>());
      final vodTarget = (vod as DeepLinkParseSuccess).target;
      expect(vodTarget.kind, DeepLinkKind.vod);
      expect(vodTarget.id, 'movie-1');

      final live = DeepLinkParser.parse(
        Uri.parse('https://${DeepLinkPolicy.host}/live/live-12'),
      );
      expect(live, isA<DeepLinkParseSuccess>());
      final liveTarget = (live as DeepLinkParseSuccess).target;
      expect(liveTarget.kind, DeepLinkKind.liveChannel);
      expect(liveTarget.id, 'live-12');
    });

    test('rejects wrong host, scheme, or empty id', () {
      expect(
        DeepLinkParser.parse(Uri.parse('http://${DeepLinkPolicy.host}/vod/a')),
        isA<DeepLinkParseUnsupported>(),
      );
      expect(
        DeepLinkParser.parse(Uri.parse('https://evil.example/vod/a')),
        isA<DeepLinkParseUnsupported>(),
      );
      expect(
        DeepLinkParser.parse(
          Uri.parse('https://${DeepLinkPolicy.host}/vod/'),
        ),
        isA<DeepLinkParseUnsupported>(),
      );
      expect(
        DeepLinkParser.parse(
          Uri.parse('https://${DeepLinkPolicy.host}/other/x'),
        ),
        isA<DeepLinkParseUnsupported>(),
      );
    });
  });
}
