import '../../core/storage/memory_secure_storage.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/auth/data/repositories/secure_session_token_store.dart';
import '../../features/auth/domain/repositories/session_token_store.dart';
import '../../features/catalog/data/repositories/in_memory_catalog_repository.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/devices/data/repositories/secure_pairing_store.dart';
import '../../features/devices/domain/repositories/pairing_secure_store.dart';
import '../../features/sync/data/repositories/in_memory_sync_repository.dart';
import '../../features/sync/domain/repositories/sync_repository.dart';
import '../../features/sync/domain/usecases/resolve_sync_conflict.dart';
import '../app_environment.dart';
import '../client_kind.dart';

/// Manual composition root (CMP-002 / TV-002 / TV-005 / CMP-005).
///
/// TV and Companion mount the **same** shared domain graph; only [clientKind]
/// (and later surface adapters) differ. No third-party DI until approved.
///
/// [secureStorage] defaults to [MemorySecureStorage] until Product approves a
/// Keystore/Keychain plugin adapter (CMP-005).
final class AppDependencies {
  factory AppDependencies({
    required ClientKind clientKind,
    AppEnvironment environment = AppEnvironment.dev,
    CatalogRepository? catalogRepository,
    SyncRepository? syncRepository,
    SecureStorage? secureStorage,
    SessionTokenStore? sessionTokenStore,
    PairingSecureStore? pairingSecureStore,
    ResolveSyncConflict syncConflictResolver = const ResolveSyncConflict(),
  }) {
    final storage = secureStorage ?? MemorySecureStorage();
    return AppDependencies._(
      clientKind: clientKind,
      environment: environment,
      catalogRepository: catalogRepository ?? InMemoryCatalogRepository(),
      syncConflictResolver: syncConflictResolver,
      syncRepository: syncRepository ??
          InMemorySyncRepository(conflictResolver: syncConflictResolver),
      secureStorage: storage,
      sessionTokenStore:
          sessionTokenStore ?? SecureSessionTokenStore(storage),
      pairingSecureStore:
          pairingSecureStore ?? SecurePairingStore(storage),
    );
  }

  AppDependencies._({
    required this.clientKind,
    required this.environment,
    required this.catalogRepository,
    required this.syncRepository,
    required this.syncConflictResolver,
    required this.secureStorage,
    required this.sessionTokenStore,
    required this.pairingSecureStore,
  });

  final ClientKind clientKind;
  final AppEnvironment environment;
  final CatalogRepository catalogRepository;
  final SyncRepository syncRepository;
  final ResolveSyncConflict syncConflictResolver;
  final SecureStorage secureStorage;
  final SessionTokenStore sessionTokenStore;
  final PairingSecureStore pairingSecureStore;

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
