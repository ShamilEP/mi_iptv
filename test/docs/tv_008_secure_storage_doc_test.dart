import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-008 doc covers Keystore, source credentials, and Logcat', () {
    final file = File('docs/architecture/tv-008-secure-storage.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-008'));
    expect(text, contains('Keystore'));
    expect(text, contains('SourceCredential'));
    expect(text, contains('Logcat'));
    expect(text, contains('SecretRedactor'));
    expect(text, contains('flutter_secure_storage'));
  });
}
