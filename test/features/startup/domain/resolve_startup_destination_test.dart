import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/auth/domain/entities/session_tokens.dart';
import 'package:mi_iptv/features/auth/domain/repositories/session_token_store.dart';
import 'package:mi_iptv/features/startup/domain/entities/startup_destination.dart';
import 'package:mi_iptv/features/startup/domain/services/session_jwt_inspector.dart';
import 'package:mi_iptv/features/startup/domain/usecases/resolve_startup_destination.dart';
import 'package:mi_iptv/features/startup/domain/usecases/run_tv_startup.dart';
import 'package:mi_iptv/features/startup/domain/usecases/warm_local_media.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';

void main() {
  group('TV-020 startup routing', () {
    test('JWT inspector accepts three-segment access tokens only', () {
      expect(SessionJwtInspector.hasUsableAccessToken(null), isFalse);
      expect(
        SessionJwtInspector.hasUsableAccessToken(
          const SessionTokens(accessToken: '', refreshToken: 'r'),
        ),
        isFalse,
      );
      expect(
        SessionJwtInspector.hasUsableAccessToken(
          const SessionTokens(accessToken: 'not-a-jwt', refreshToken: 'r'),
        ),
        isFalse,
      );
      expect(
        SessionJwtInspector.hasUsableAccessToken(
          const SessionTokens(
            accessToken: 'aaa.bbb.ccc',
            refreshToken: 'r',
          ),
        ),
        isTrue,
      );
    });

    test('resolve routes home when stored JWT looks usable', () async {
      final store = _MemorySessionStore(
        const SessionTokens(accessToken: 'hdr.pay.sig', refreshToken: 'r'),
      );
      final destination = await ResolveStartupDestination(store)();
      expect(destination, StartupDestination.home);
    });

    test('resolve routes onboarding when session missing', () async {
      final destination = await ResolveStartupDestination(_MemorySessionStore())();
      expect(destination, StartupDestination.onboarding);
    });

    test('RunTvStartup warms local media and returns destination', () async {
      final media = MemoryLocalMediaStore();
      final sessions = _MemorySessionStore();
      final destination = await RunTvStartup(
        warmLocalMedia: WarmLocalMedia(media),
        resolveDestination: ResolveStartupDestination(sessions),
      )();
      expect(destination, StartupDestination.onboarding);
      expect(await media.loadSettings(), isEmpty);
    });
  });
}

final class _MemorySessionStore implements SessionTokenStore {
  _MemorySessionStore([this._tokens]);

  SessionTokens? _tokens;

  @override
  Future<void> clear() async => _tokens = null;

  @override
  Future<SessionTokens?> read() async => _tokens;

  @override
  Future<void> save(SessionTokens tokens) async => _tokens = tokens;
}
