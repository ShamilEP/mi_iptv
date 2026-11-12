import '../app_environment.dart';
import '../client_kind.dart';

/// Manual composition root (CMP-002 / TV-002).
///
/// No third-party DI package until Product/engineering approves one
/// (e.g. get_it). Wire adapters here as they land.
final class AppDependencies {
  AppDependencies({
    required this.clientKind,
    this.environment = AppEnvironment.dev,
  });

  final ClientKind clientKind;
  final AppEnvironment environment;

  static AppDependencies? _mounted;

  /// Active graph for the running client. Null before [bootstrap].
  static AppDependencies get instance {
    final mounted = _mounted;
    if (mounted == null) {
      throw StateError('AppDependencies not mounted — call bootstrap first');
    }
    return mounted;
  }

  static bool get isMounted => _mounted != null;

  /// Install the graph for this process. Idempotent replace is allowed in tests.
  static void mount(AppDependencies dependencies) {
    _mounted = dependencies;
  }

  /// Test-only reset.
  static void debugReset() {
    _mounted = null;
  }
}
