import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/storage/memory_secure_storage.dart';
import 'package:mi_iptv/features/auth/data/repositories/secure_session_token_store.dart';
import 'package:mi_iptv/features/auth/domain/entities/session_tokens.dart';
import 'package:mi_iptv/features/devices/data/repositories/secure_pairing_store.dart';
import 'package:mi_iptv/features/devices/domain/entities/pairing_secure_data.dart';

void main() {
  late MemorySecureStorage storage;

  setUp(() {
    storage = MemorySecureStorage();
  });

  test('session tokens round-trip and clear without exposing in toString paths', () async {
    final store = SecureSessionTokenStore(storage);
    const tokens = SessionTokens(
      accessToken: 'access-test-value',
      refreshToken: 'refresh-test-value',
    );

    await store.save(tokens);
    final read = await store.read();
    expect(read?.accessToken, tokens.accessToken);
    expect(read?.refreshToken, tokens.refreshToken);

    await store.clear();
    expect(await store.read(), isNull);
  });

  test('pairing secure data round-trips and clears', () async {
    final store = SecurePairingStore(storage);
    const data = PairingSecureData(
      linkedTvDeviceId: 'tv-device-1',
      sessionSecret: 'pairing-secret-value',
    );

    await store.save(data);
    final read = await store.read();
    expect(read?.linkedTvDeviceId, data.linkedTvDeviceId);
    expect(read?.sessionSecret, data.sessionSecret);

    await store.clear();
    expect(await store.read(), isNull);
  });

  test('session and pairing share one vault instance', () async {
    final sessions = SecureSessionTokenStore(storage);
    final pairing = SecurePairingStore(storage);

    await sessions.save(
      const SessionTokens(accessToken: 'a', refreshToken: 'r'),
    );
    await pairing.save(
      const PairingSecureData(
        linkedTvDeviceId: 'tv-1',
        sessionSecret: 's',
      ),
    );

    expect(await sessions.read(), isNotNull);
    expect(await pairing.read(), isNotNull);

    await storage.clear();
    expect(await sessions.read(), isNull);
    expect(await pairing.read(), isNull);
  });
}
