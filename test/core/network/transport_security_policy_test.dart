import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/transport_security_policy.dart';

void main() {
  group('SEC-023 TransportSecurityPolicy', () {
    test('backend allows HTTPS only', () {
      expect(
        TransportSecurityPolicy.isBackendUriAllowed(
          Uri.parse('https://api.example/v1'),
        ),
        isTrue,
      );
      expect(
        TransportSecurityPolicy.isBackendUriAllowed(
          Uri.parse('http://api.example/v1'),
        ),
        isFalse,
      );
      expect(
        TransportSecurityPolicy.tryParseBackendUri('http://api.example'),
        isNull,
      );
      expect(
        TransportSecurityPolicy.tryParseBackendUri('https://api.example/'),
        Uri.parse('https://api.example/'),
      );
    });

    test('media allows http and https; warns on cleartext', () {
      final https = Uri.parse('https://cdn.example/live.m3u8');
      final http = Uri.parse('http://cdn.example/live.m3u8');
      expect(TransportSecurityPolicy.isMediaStreamUriAllowed(https), isTrue);
      expect(TransportSecurityPolicy.isMediaStreamUriAllowed(http), isTrue);
      expect(TransportSecurityPolicy.requiresCleartextMediaWarning(https), isFalse);
      expect(TransportSecurityPolicy.requiresCleartextMediaWarning(http), isTrue);
      expect(
        TransportSecurityPolicy.isMediaStreamUriAllowed(
          Uri.parse('file:///tmp/a.m3u8'),
        ),
        isFalse,
      );
      expect(
        TransportSecurityPolicy.tryParseMediaStreamUri('  http://x.example/a.ts '),
        Uri.parse('http://x.example/a.ts'),
      );
    });

    test('cleartext warning copy prefers HTTPS without embedding secrets', () {
      expect(
        TransportSecurityPolicy.cleartextMediaWarning.toLowerCase(),
        contains('https'),
      );
      expect(
        TransportSecurityPolicy.cleartextMediaWarning,
        isNot(contains('password')),
      );
      expect(
        TransportSecurityPolicy.cleartextMediaWarning,
        isNot(contains('http://')),
      );
    });
  });
}
