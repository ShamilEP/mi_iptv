import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/features/devices/data/repositories/local_linked_tv_status_store.dart';
import 'package:mi_iptv/features/devices/domain/entities/linked_tv_snapshot.dart';

void main() {
  test('CMP-006 persists and clears last-known TV status without secrets', () async {
    final store = MemoryLocalMediaStore();
    final status = LocalLinkedTvStatusStore(store);
    final snapshot = LinkedTvSnapshot(
      deviceId: 'tv-living',
      displayName: 'Living room',
      lastKnownOnline: true,
      updatedAt: DateTime.utc(2026, 11, 13, 12),
    );

    await status.save(snapshot);
    final loaded = await status.load();
    expect(loaded, isNotNull);
    expect(loaded!.deviceId, 'tv-living');
    expect(loaded.displayName, 'Living room');
    expect(loaded.lastKnownOnline, isTrue);

    final raw = await store.loadSetting(LocalLinkedTvStatusStore.settingKey);
    expect(raw!.value, isNot(contains('token')));
    expect(raw.value, isNot(contains('password')));

    await status.clear();
    expect(await status.load(), isNull);
  });
}
