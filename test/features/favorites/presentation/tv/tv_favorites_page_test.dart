import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/status_pattern_copy.dart';
import 'package:mi_iptv/features/favorites/presentation/tv/tv_favorites_copy.dart';
import 'package:mi_iptv/features/favorites/presentation/tv/tv_favorites_item.dart';
import 'package:mi_iptv/features/favorites/presentation/tv/tv_favorites_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvFavoritesPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvFavoritesPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-036 separates Channels and VOD with stable order', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(TvFavoritesCopy.title), findsOneWidget);
    expect(find.text(TvFavoritesCopy.channelsGroup), findsOneWidget);
    expect(find.text(TvFavoritesCopy.vodGroup), findsOneWidget);
    expect(find.text('12 Signal News'), findsOneWidget);
    expect(find.text('Harbor Lights'), findsOneWidget);
    expect(find.textContaining('Order 1'), findsWidgets);

    final channelY = tester.getTopLeft(find.text('12 Signal News')).dy;
    final vodY = tester.getTopLeft(find.text('Harbor Lights')).dy;
    expect(channelY, lessThan(vodY));
  });

  testWidgets('Open and Remove quick actions fire', (tester) async {
    TvFavoritesItem? opened;
    TvFavoritesItem? removed;
    await pump(
      tester,
      page: TvFavoritesPage(
        onOpen: (item) => opened = item,
        onRemove: (item) => removed = item,
      ),
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('fav-vod-1')),
        matching: find.text(TvFavoritesCopy.openLabel),
      ),
    );
    await tester.pump();
    expect(opened?.id, 'vod-1');

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('fav-ch-12')),
        matching: find.text(TvFavoritesCopy.removeLabel),
      ),
    );
    await tester.pump();
    expect(removed?.id, 'ch-12');
    expect(find.text('12 Signal News'), findsNothing);
    expect(find.text('24 Ember Sports'), findsOneWidget);
  });

  testWidgets('empty state uses Favorites EmptyPattern', (tester) async {
    var browse = 0;
    await pump(
      tester,
      page: TvFavoritesPage(
        items: const <TvFavoritesItem>[],
        onBrowseCatalog: () => browse++,
      ),
    );

    expect(find.text(StatusPatternCopy.favoritesEmpty.title), findsOneWidget);
    await tester.tap(find.text(StatusPatternCopy.favoritesEmpty.actionLabel));
    await tester.pump();
    expect(browse, 1);
  });
}
