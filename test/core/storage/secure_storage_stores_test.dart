import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/storage/memory_secure_storage.dart';
import 'package:mi_iptv/features/auth/data/repositories/secure_session_token_store.dart';
import 'package:mi_iptv/features/auth/domain/entities/session_tokens.dart';
import 'package:mi_iptv/features/devices/data/repositories/secure_pairing_store.dart';
import 'package:mi_iptv/features/devices/domain/entities/pairing_secure_data.dart';
import 'package:mi_iptv/features/sources/data/repositories/secure_source_credential_store.dart';
import 'package:mi_iptv/features/sources/domain/entities/source_credentials.dart';

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
    expect(tokens.toString(), isNot(contains('access-test-value')));

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

  test('source credentials round-trip with redacted toString', () async {
    final store = SecureSourceCredentialStore(storage);
    const credentials = SourceCredentials(
      sourceId: 'src-1',
      username: 'viewer',
      password: 'xtream-secret',
      token: 'm3u-token',
    );

    await store.save(credentials);
    final read = await store.read('src-1');
    expect(read?.username, 'viewer');
    expect(read?.password, 'xtream-secret');
    expect(read?.token, 'm3u-token');
    expect(credentials.toString(), isNot(contains('xtream-secret')));
    expect(credentials.toString(), isNot(contains('m3u-token')));

    await store.delete('src-1');
    expect(await store.read('src-1'), isNull);
  });

  test('session, pairing, and source credentials share one vault', () async {
    final sessions = SecureSessionTokenStore(storage);
    final pairing = SecurePairingStore(storage);
    final sources = SecureSourceCredentialStore(storage);

    await sessions.save(
      const SessionTokens(accessToken: 'a', refreshToken: 'r'),
    );
    await pairing.save(
      const PairingSecureData(
        linkedTvDeviceId: 'tv-1',
        sessionSecret: 's',
      ),
    );
    await sources.save(
      const SourceCredentials(sourceId: 'src-1', password: 'p'),
    );

    expect(await sessions.read(), isNotNull);
    expect(await pairing.read(), isNotNull);
    expect(await sources.read('src-1'), isNotNull);

    await storage.clear();
    expect(await sessions.read(), isNull);
    expect(await pairing.read(), isNull);
    expect(await sources.read('src-1'), isNull);
  });
}
