import '../entities/session_tokens.dart';

/// Auth session persistence port — backed by secure storage on device.
abstract interface class SessionTokenStore {
  Future<void> save(SessionTokens tokens);

  Future<SessionTokens?> read();

  Future<void> clear();
}
