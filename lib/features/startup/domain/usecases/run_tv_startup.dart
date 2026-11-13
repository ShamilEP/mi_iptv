import '../entities/startup_destination.dart';
import 'resolve_startup_destination.dart';
import 'warm_local_media.dart';

/// Parallel local warm + JWT inspect for TV splash gate (TV-020).
final class RunTvStartup {
  const RunTvStartup({
    required this.warmLocalMedia,
    required this.resolveDestination,
  });

  final WarmLocalMedia warmLocalMedia;
  final ResolveStartupDestination resolveDestination;

  /// Warms local data and resolves the next route concurrently.
  ///
  /// Warm failures are ignored so a usable JWT still reaches Home.
  Future<StartupDestination> call() async {
    final results = await Future.wait<Object?>([
      _warmIgnoringErrors(),
      resolveDestination(),
    ]);
    return results[1]! as StartupDestination;
  }

  Future<void> _warmIgnoringErrors() async {
    try {
      await warmLocalMedia();
    } on Object {
      // Local cache warm is best-effort during splash.
    }
  }
}
