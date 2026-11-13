import '../../../../core/persistence/local_media_store.dart';

/// Fast local-DB touch so startup opens SQLite without a long stall (TV-020).
///
/// Loads cheap non-secret tables in parallel. Failures are swallowed by the
/// caller — routing must not block on cache warm.
final class WarmLocalMedia {
  const WarmLocalMedia(this._store);

  final LocalMediaStore _store;

  Future<void> call() async {
    await Future.wait<void>([
      _store.loadSettings(),
      _store.loadSources(),
    ]);
  }
}
