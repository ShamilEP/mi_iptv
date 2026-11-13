import '../../core/images/image_pipeline.dart';
import '../../core/images/image_pipeline_config.dart';
import '../../core/network/connectivity_monitor.dart';
import '../../core/network/memory_connectivity_monitor.dart';
import '../../core/network/offline_mode_resolver.dart';
import '../../core/oem/oem_compatibility.dart';
import '../../core/persistence/local_media_store.dart';
import '../../core/persistence/memory_local_media_store.dart';
import '../../core/storage/memory_secure_storage.dart';
import '../../core/storage/secure_storage.dart';
import '../../features/auth/data/repositories/secure_session_token_store.dart';
import '../../features/auth/domain/repositories/session_token_store.dart';
import '../../features/catalog/data/repositories/in_memory_catalog_repository.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/devices/data/repositories/secure_pairing_store.dart';
import '../../features/devices/domain/repositories/pairing_secure_store.dart';
import '../../features/player/data/adapters/memory_media_player_controller.dart';
import '../../features/player/domain/repositories/media_player_controller.dart';
import '../../features/player/domain/services/playback_retry_coordinator.dart';
import '../../features/player/domain/services/playback_retry_policy.dart';
import '../../features/sources/data/repositories/secure_source_credential_store.dart';
import '../../features/sources/domain/repositories/source_credential_store.dart';
import '../../features/sync/data/repositories/in_memory_sync_repository.dart';
import '../../features/sync/domain/repositories/sync_repository.dart';
import '../../features/sync/domain/usecases/resolve_sync_conflict.dart';
import '../app_environment.dart';
import '../client_kind.dart';

/// Manual composition root (CMP-002 / TV-002 / TV-005 / CMP-005 / TV-007 /
/// TV-008 / TV-010 / TV-011 / TV-012 / TV-050 / TV-054).
///
/// TV and Companion mount the **same** shared domain graph; only [clientKind]
/// (and later surface adapters) differ. No third-party DI until approved.
///
/// [secureStorage] defaults to [MemorySecureStorage] for unit tests.
/// Device [bootstrap] injects [FlutterSecureStorageAdapter] (CMP-005 / TV-008).
/// [localMediaStore] defaults to [MemoryLocalMediaStore] for unit tests;
/// device [bootstrap] injects [DriftLocalMediaStore] (TV-007).
/// [connectivity] defaults to [MemoryConnectivityMonitor] for unit tests;
/// device [bootstrap] injects [PollingConnectivityMonitor] (TV-010).
/// [oemCompatibility] defaults to [OemCompatibility.unknown]; TV [bootstrap]
/// resolves from Android `Build.*` (TV-011).
/// [imagePipeline] defaults from OEM / Companion budgets (TV-012).
/// [mediaPlayer] defaults to [MemoryMediaPlayerController]; TV [bootstrap]
/// injects [Media3PlayerAdapter] (TV-050). Lifecycle is owned here / native
/// engine — not by player screens.
/// [playbackRetry] wraps [mediaPlayer] with capped exponential backoff (TV-054).
final class AppDependencies {
  factory AppDependencies({
    required ClientKind clientKind,
    AppEnvironment environment = AppEnvironment.dev,
    CatalogRepository? catalogRepository,
    SyncRepository? syncRepository,
    SecureStorage? secureStorage,
    SessionTokenStore? sessionTokenStore,
    PairingSecureStore? pairingSecureStore,
    SourceCredentialStore? sourceCredentialStore,
    LocalMediaStore? localMediaStore,
    ConnectivityMonitor? connectivity,
    OemCompatibility? oemCompatibility,
    ImagePipeline? imagePipeline,
    MediaPlayerController? mediaPlayer,
    PlaybackRetryCoordinator? playbackRetry,
    PlaybackRetryPolicy retryPolicy = PlaybackRetryPolicy.defaults,
    ResolveSyncConflict syncConflictResolver = const ResolveSyncConflict(),
  }) {
    final storage = secureStorage ?? MemorySecureStorage();
    final player = mediaPlayer ?? MemoryMediaPlayerController();
    final mediaStore = localMediaStore ?? MemoryLocalMediaStore();
    final network = connectivity ?? MemoryConnectivityMonitor();
    final oem = oemCompatibility ?? OemCompatibility.unknown();
    final images = imagePipeline ??
        ImagePipeline(
          config: clientKind == ClientKind.companion
              ? ImagePipelineConfig.companionDefault
              : ImagePipelineConfig.forOem(oem.profile),
        );
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
      sourceCredentialStore:
          sourceCredentialStore ?? SecureSourceCredentialStore(storage),
      localMediaStore: mediaStore,
      connectivity: network,
      offlineMode: OfflineModeResolver(
        connectivity: network,
        localMediaStore: mediaStore,
      ),
      oemCompatibility: oem,
      imagePipeline: images,
      mediaPlayer: player,
      playbackRetry: playbackRetry ??
          PlaybackRetryCoordinator(player: player, policy: retryPolicy),
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
    required this.sourceCredentialStore,
    required this.localMediaStore,
    required this.connectivity,
    required this.offlineMode,
    required this.oemCompatibility,
    required this.imagePipeline,
    required this.mediaPlayer,
    required this.playbackRetry,
  });

  final ClientKind clientKind;
  final AppEnvironment environment;
  final CatalogRepository catalogRepository;
  final SyncRepository syncRepository;
  final ResolveSyncConflict syncConflictResolver;
  final SecureStorage secureStorage;
  final SessionTokenStore sessionTokenStore;
  final PairingSecureStore pairingSecureStore;
  final SourceCredentialStore sourceCredentialStore;
  final LocalMediaStore localMediaStore;
  final ConnectivityMonitor connectivity;
  final OfflineModeResolver offlineMode;
  final OemCompatibility oemCompatibility;
  final ImagePipeline imagePipeline;
  final MediaPlayerController mediaPlayer;
  final PlaybackRetryCoordinator playbackRetry;

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
