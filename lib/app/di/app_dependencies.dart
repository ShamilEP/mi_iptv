import '../../features/catalog/data/repositories/in_memory_catalog_repository.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/sync/data/repositories/in_memory_sync_repository.dart';
import '../../features/sync/domain/repositories/sync_repository.dart';
import '../../features/sync/domain/usecases/resolve_sync_conflict.dart';
import '../app_environment.dart';
import '../client_kind.dart';

/// Manual composition root (CMP-002 / TV-002 / TV-005).
///
/// TV and Companion mount the **same** shared domain graph; only [clientKind]
/// (and later surface adapters) differ. No third-party DI until approved.
final class AppDependencies {
  AppDependencies({
    required this.clientKind,
    this.environment = AppEnvironment.dev,
    CatalogRepository? catalogRepository,
    SyncRepository? syncRepository,
    this.syncConflictResolver = const ResolveSyncConflict(),
  })  : catalogRepository =
            catalogRepository ?? InMemoryCatalogRepository(),
        syncRepository = syncRepository ??
            InMemorySyncRepository(
              conflictResolver: syncConflictResolver,
            );

  final ClientKind clientKind;
  final AppEnvironment environment;
  final CatalogRepository catalogRepository;
  final SyncRepository syncRepository;
  final ResolveSyncConflict syncConflictResolver;

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
