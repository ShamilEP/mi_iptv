import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/catalog/presentation/tv/tv_content_detail_copy.dart';
import 'package:mi_iptv/features/catalog/presentation/tv/tv_content_detail_models.dart';
import 'package:mi_iptv/features/catalog/presentation/tv/tv_content_detail_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvContentDetailPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvContentDetailPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-034 shows art, title, metadata, synopsis, and actions', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byKey(const ValueKey<String>('detail-hero-art')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('detail-title')), findsOneWidget);
    expect(find.text('Harbor Lights'), findsOneWidget);
    expect(find.text('2024'), findsOneWidget);
    expect(find.text('1h 48m'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('detail-synopsis')), findsOneWidget);
    expect(find.text(TvContentDetailCopy.playLabel), findsOneWidget);
    expect(find.text(TvContentDetailCopy.resumeLabel), findsOneWidget);
    expect(find.text(TvContentDetailCopy.favoriteLabel), findsOneWidget);
    expect(find.text(TvContentDetailCopy.relatedTitle), findsOneWidget);
    expect(find.text('Night Run'), findsOneWidget);
    expect(find.textContaining('Season'), findsNothing);
    expect(find.textContaining('Episode'), findsNothing);
  });

  testWidgets('Play, Resume, Favorite, and Related fire callbacks', (
    tester,
  ) async {
    TvContentDetail? played;
    TvContentDetail? resumed;
    TvContentDetail? favorited;
    TvRelatedContent? related;

    await pump(
      tester,
      page: TvContentDetailPage(
        onPlay: (detail) => played = detail,
        onResume: (detail) => resumed = detail,
        onFavoriteChanged: (detail) => favorited = detail,
        onRelatedSelected: (item) => related = item,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('detail-play')));
    await tester.pump();
    expect(played?.id, 'vod-harbor-lights');

    await tester.tap(find.byKey(const ValueKey<String>('detail-resume')));
    await tester.pump();
    expect(resumed?.id, 'vod-harbor-lights');

    await tester.tap(find.byKey(const ValueKey<String>('detail-favorite')));
    await tester.pump();
    expect(favorited?.isFavorite, isTrue);
    expect(find.text(TvContentDetailCopy.favoritedLabel), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('related-vod-night-run')));
    await tester.pump();
    expect(related?.id, 'vod-night-run');
  });

  testWidgets('Resume is hidden without recoverable progress', (tester) async {
    await pump(
      tester,
      page: const TvContentDetailPage(
        detail: TvContentDetail(
          id: 'vod-fresh',
          title: 'Fresh Start',
          synopsis: 'No progress yet.',
          metadata: <String>['Movie'],
          progress: 0.05,
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('detail-play')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('detail-resume')), findsNothing);
    expect(find.text(TvContentDetailCopy.relatedTitle), findsNothing);
  });
}
