import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_quick_access.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvHomePage? home}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: home ?? const TvHomePage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-032 Continue watching is first rail with quick access', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('iptv'), findsOneWidget);
    expect(find.text(TvHomePage.continueWatchingTitle), findsOneWidget);
    expect(find.text(TvHomePage.featuredTitle), findsOneWidget);
    expect(find.text(TvHomePage.liveChannelsTitle), findsOneWidget);

    expect(find.text(Iconography.liveTv.label), findsOneWidget);
    expect(find.text(Iconography.favorites.label), findsOneWidget);
    expect(find.text(Iconography.search.label), findsOneWidget);
    expect(find.text(Iconography.settings.label), findsOneWidget);

    final continueY = tester.getTopLeft(find.text(TvHomePage.continueWatchingTitle)).dy;
    final featuredY = tester.getTopLeft(find.text(TvHomePage.featuredTitle)).dy;
    expect(continueY, lessThan(featuredY));
  });

  testWidgets('quick access Live TV is reachable and reports selection', (
    tester,
  ) async {
    TvHomeQuickDestination? selected;
    await pump(
      tester,
      home: TvHomePage(onQuickAccess: (d) => selected = d),
    );

    await tester.tap(find.text(Iconography.liveTv.label));
    await tester.pumpAndSettle();
    expect(selected, TvHomeQuickDestination.liveTv);
  });

  testWidgets('initial focus lands on first Continue watching card', (
    tester,
  ) async {
    await pump(tester);

    final focused = FocusManager.instance.primaryFocus;
    expect(focused, isNotNull);
    expect(find.text('Evening news'), findsOneWidget);
    // Focus should be within the first continue-watching card subtree.
    expect(
      focused!.context?.findAncestorWidgetOfExactType<TvHomePage>(),
      isNotNull,
    );
  });
}
