import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-005 secure storage doc proposes plugin and lands ports', () {
    final file = File('docs/architecture/cmp-005-secure-storage.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('CMP-005'));
    expect(text, contains('SEC-C06'));
    expect(text, contains('SecureStorage'));
    expect(text, contains('SessionTokenStore'));
    expect(text, contains('PairingSecureStore'));
    expect(text, contains('flutter_secure_storage'));
    expect(text, contains('MemorySecureStorage'));
  });

  test('secure storage port and stores exist', () {
    expect(File('lib/core/storage/secure_storage.dart').existsSync(), isTrue);
    expect(
      File('lib/features/auth/data/repositories/secure_session_token_store.dart')
          .existsSync(),
      isTrue,
    );
    expect(
      File('lib/features/devices/data/repositories/secure_pairing_store.dart')
          .existsSync(),
      isTrue,
    );
  });
}
