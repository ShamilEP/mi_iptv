import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/connectivity_status.dart';
import 'package:mi_iptv/core/network/memory_connectivity_monitor.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/offline_banner.dart';
import 'package:mi_iptv/core/widgets/status_pattern.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_connectivity_binder.dart';

void main() {
  testWidgets('TV-010 binder shows offlineCached when offline with cache', (
    tester,
  ) async {
    final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
    await monitor.start();
    final store = MemoryLocalMediaStore();
    await store.replaceChannels(const <ContentItem>[
      ContentItem(
        contentId: 'ch-1',
        type: ContentType.channel,
        title: 'Signal News',
      ),
    ]);

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: TvHomeConnectivityBinder(
          connectivity: monitor,
          localMediaStore: store,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OfflineBanner), findsOneWidget);
    expect(find.textContaining('(cached)'), findsWidgets);
    expect(find.byType(OfflinePattern), findsNothing);

    await monitor.dispose();
  });

  testWidgets('TV-010 binder shows full Offline when offline without cache', (
    tester,
  ) async {
    final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
    await monitor.start();
    final store = MemoryLocalMediaStore();

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: TvHomeConnectivityBinder(
          connectivity: monitor,
          localMediaStore: store,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OfflinePattern), findsOneWidget);
    expect(find.byType(OfflineBanner), findsNothing);

    await monitor.dispose();
  });
}
