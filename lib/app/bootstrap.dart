import 'package:flutter/widgets.dart';

import '../core/persistence/drift/app_database.dart';
import '../core/persistence/drift/drift_local_media_store.dart';
import '../core/storage/flutter_secure_storage_adapter.dart';
import 'app.dart';
import 'app_environment.dart';
import 'client_kind.dart';
import 'di/app_dependencies.dart';

/// Composition root. Wire DI / adapters here once packages are approved.
Future<void> bootstrap({
  ClientKind clientKind = ClientKind.tv,
  AppEnvironment? environment,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final resolvedEnv = environment ?? AppEnvironment.fromDartDefine();
  final mediaDb = AppDatabase.defaults();
  AppDependencies.mount(
    AppDependencies(
      clientKind: clientKind,
      environment: resolvedEnv,
      // CMP-005 / TV-008: Keystore/Keychain; unit tests inject memory.
      secureStorage: FlutterSecureStorageAdapter(),
      // TV-007: durable SQLite via Drift; unit tests keep MemoryLocalMediaStore.
      localMediaStore: DriftLocalMediaStore(mediaDb),
    ),
  );
  runApp(MiIptvApp(clientKind: clientKind));
}
