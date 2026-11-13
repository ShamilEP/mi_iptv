import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SEC-023 doc and Android NSC lock cleartext media policy', () {
    final doc = File('docs/security/network_security_cleartext.md');
    expect(doc.existsSync(), isTrue);
    final text = doc.readAsStringSync();
    expect(text, contains('SEC-023'));
    expect(text, contains('Security §3.1'));
    expect(text, contains('TransportSecurityPolicy'));
    expect(text, contains('network_security_config.xml'));
    expect(text, contains('cleartext'));

    final nsc = File('android/app/src/main/res/xml/network_security_config.xml')
        .readAsStringSync();
    expect(nsc, contains('cleartextTrafficPermitted="true"'));
    expect(nsc, contains('SEC-023'));

    final manifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(
      manifest,
      contains('android:networkSecurityConfig="@xml/network_security_config"'),
    );
    expect(manifest, contains('android:usesCleartextTraffic="true"'));
    expect(manifest, contains('SEC-023'));
  });
}
