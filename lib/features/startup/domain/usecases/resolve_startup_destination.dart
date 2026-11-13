import '../../../auth/domain/repositories/session_token_store.dart';
import '../entities/startup_destination.dart';
import '../services/session_jwt_inspector.dart';

/// Reads the secure session store and picks Home vs Onboarding (TV-020).
final class ResolveStartupDestination {
  const ResolveStartupDestination(this._sessionTokens);

  final SessionTokenStore _sessionTokens;

  Future<StartupDestination> call() async {
    final tokens = await _sessionTokens.read();
    if (SessionJwtInspector.hasUsableAccessToken(tokens)) {
      return StartupDestination.home;
    }
    return StartupDestination.onboarding;
  }
}
