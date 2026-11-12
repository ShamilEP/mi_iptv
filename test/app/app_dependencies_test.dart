import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app_environment.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/app/di/app_dependencies.dart';
import 'package:mi_iptv/features/catalog/data/repositories/in_memory_catalog_repository.dart';
import 'package:mi_iptv/features/sync/data/repositories/in_memory_sync_repository.dart';
import 'package:mi_iptv/features/sync/domain/usecases/resolve_sync_conflict.dart';

void main() {
  tearDown(AppDependencies.debugReset);

  test('mount exposes clientKind and environment', () {
    AppDependencies.mount(
      AppDependencies(
        clientKind: ClientKind.companion,
        environment: AppEnvironment.qa,
      ),
    );
    expect(AppDependencies.isMounted, isTrue);
    expect(AppDependencies.instance.clientKind, ClientKind.companion);
    expect(AppDependencies.instance.environment, AppEnvironment.qa);
  });

  test('environment defaults to dev when omitted', () {
    AppDependencies.mount(AppDependencies(clientKind: ClientKind.tv));
    expect(AppDependencies.instance.environment, AppEnvironment.dev);
  });

  test('TV and Companion share catalog and sync graph types', () {
    AppDependencies.mount(AppDependencies(clientKind: ClientKind.tv));
    final tv = AppDependencies.instance;
    expect(tv.catalogRepository, isA<InMemoryCatalogRepository>());
    expect(tv.syncRepository, isA<InMemorySyncRepository>());
    expect(tv.syncConflictResolver, isA<ResolveSyncConflict>());

    AppDependencies.mount(AppDependencies(clientKind: ClientKind.companion));
    final companion = AppDependencies.instance;
    expect(companion.catalogRepository, isA<InMemoryCatalogRepository>());
    expect(companion.syncRepository, isA<InMemorySyncRepository>());
  });

  test('instance throws before mount', () {
    expect(AppDependencies.isMounted, isFalse);
    expect(() => AppDependencies.instance, throwsStateError);
  });
}
