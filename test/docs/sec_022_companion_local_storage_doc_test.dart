import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SEC-022 review locks Keychain, Keystore, logs, screenshots, clipboard', () {
    final doc =
        File('docs/security/companion_local_storage_review.md').readAsStringSync();
    expect(doc, contains('SEC-022'));
    expect(doc, contains('Keychain'));
    expect(doc, contains('first_unlock_this_device'));
    expect(doc, contains('Keystore'));
    expect(doc, contains('SecretRedactor'));
    expect(doc, contains('Clipboard'));
    expect(doc, contains('obscureText'));
  });

  test('secure storage adapter locks Companion iOS Keychain accessibility', () {
    final adapter = File(
      'lib/core/storage/flutter_secure_storage_adapter.dart',
    ).readAsStringSync();
    expect(adapter, contains('first_unlock_this_device'));
    expect(adapter, contains('synchronizable: false'));
    expect(adapter, contains('Android Keystore'));
  });

  test('lib has no Clipboard secret surface', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    for (final file in dartFiles) {
      final text = file.readAsStringSync();
      expect(
        text.contains('Clipboard.'),
        isFalse,
        reason: '${file.path} must not write the system clipboard',
      );
    }
  });
}
