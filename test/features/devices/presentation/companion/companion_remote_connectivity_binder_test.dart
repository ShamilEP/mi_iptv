import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/connectivity_status.dart';
import 'package:mi_iptv/core/network/memory_connectivity_monitor.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/devices/data/repositories/local_linked_tv_status_store.dart';
import 'package:mi_iptv/features/devices/domain/entities/linked_tv_snapshot.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_connectivity_binder.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_copy.dart';

void main() {
  testWidgets('CMP-006 remote uses last-known TV name and offline flag', (
    tester,
  ) async {
    final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
    await monitor.start();
    final store = LocalLinkedTvStatusStore(MemoryLocalMediaStore());
    await store.save(
      LinkedTvSnapshot(
        deviceId: 'tv-den',
        displayName: 'Den TV',
        lastKnownOnline: false,
        updatedAt: DateTime.utc(2026, 11, 13),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: CompanionRemoteConnectivityBinder(
          connectivity: monitor,
          linkedTvStatusStore: store,
          onFeedback: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Den TV'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text(CompanionRemoteCopy.demoTvName), findsNothing);

    await monitor.dispose();
  });
}
