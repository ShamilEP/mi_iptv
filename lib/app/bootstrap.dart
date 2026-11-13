import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/network/polling_connectivity_monitor.dart';
import '../core/oem/android_oem_device_identity_reader.dart';
import '../core/oem/oem_compatibility.dart';
import '../core/persistence/drift/app_database.dart';
import '../core/persistence/drift/drift_local_media_store.dart';
import '../core/storage/flutter_secure_storage_adapter.dart';
import '../features/player/data/adapters/media3_player_adapter.dart';
import '../features/player/data/adapters/memory_media_player_controller.dart';
import '../features/player/domain/repositories/media_player_controller.dart';
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
  final connectivity = PollingConnectivityMonitor();
  final oem = await _oemFor(clientKind);
  AppDependencies.mount(
    AppDependencies(
      clientKind: clientKind,
      environment: resolvedEnv,
      // CMP-005 / TV-008: Keystore/Keychain; unit tests inject memory.
      secureStorage: FlutterSecureStorageAdapter(),
      // TV-007: durable SQLite via Drift; unit tests keep MemoryLocalMediaStore.
      localMediaStore: DriftLocalMediaStore(mediaDb),
      // TV-010: DNS polling probe (no connectivity_plus until approved).
      connectivity: connectivity,
      // TV-011: OEM key map / decoder / display / quirks from Build fingerprint.
      oemCompatibility: oem,
      // TV-050: Media3 on TV; Companion keeps memory (no MVP video playback).
      mediaPlayer: _mediaPlayerFor(clientKind),
    ),
  );
  // QA-039 / NFR-004: never stall first paint on airplane mode / DNS hangs.
  unawaited(connectivity.start());
  runApp(MiIptvApp(clientKind: clientKind));
}

Future<OemCompatibility> _oemFor(ClientKind clientKind) async {
  if (clientKind != ClientKind.tv) {
    return OemCompatibility.unknown();
  }
  final identity = await AndroidOemDeviceIdentityReader().read();
  return OemCompatibility.forIdentity(identity);
}

MediaPlayerController _mediaPlayerFor(ClientKind clientKind) {
  return switch (clientKind) {
    ClientKind.tv => Media3PlayerAdapter(),
    ClientKind.companion => MemoryMediaPlayerController(),
  };
}
