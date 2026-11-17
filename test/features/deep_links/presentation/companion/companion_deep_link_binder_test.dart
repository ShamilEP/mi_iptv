import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_copy.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';
import 'package:mi_iptv/features/deep_links/data/memory_deep_link_ingress.dart';
import 'package:mi_iptv/features/deep_links/domain/deep_link_policy.dart';
import 'package:mi_iptv/features/deep_links/presentation/companion/companion_deep_link_binder.dart';

void main() {
  testWidgets('CMP-050 deep link opens Explore detail for matching id', (
    tester,
  ) async {
    final ingress = MemoryDeepLinkIngress(
      initial: Uri.parse('https://${DeepLinkPolicy.host}/vod/movie-1'),
    );
    addTearDown(ingress.dispose);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: CompanionDeepLinkBinder(
          ingress: ingress,
          // Bypass connectivity binder — inject via initial on explore through
          // a custom path: binder always builds CompanionExploreConnectivityBinder.
        ),
      ),
    );
    // Connectivity binder starts loading then settles to demo catalog.
    await tester.pumpAndSettle();

    expect(find.text(CompanionExploreCopy.sendToTvLabel), findsOneWidget);
    expect(find.text('Harbor Lights'), findsWidgets);
  });

  testWidgets('CMP-050 unsupported link shows error banner', (tester) async {
    final ingress = MemoryDeepLinkIngress(
      initial: Uri.parse('https://evil.example/vod/movie-1'),
    );
    addTearDown(ingress.dispose);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: CompanionDeepLinkBinder(ingress: ingress),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('deep-link-error')), findsOneWidget);
    expect(find.text(CompanionDeepLinkCopy.unsupportedLink), findsOneWidget);
  });

  testWidgets('CMP-050 Explore initialItemId selects detail', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: const CompanionExplorePage(initialItemId: 'live-12'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(CompanionExploreCopy.sendToTvLabel), findsOneWidget);
    expect(find.text('12 Signal News'), findsWidgets);
  });
}
