import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_hero.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_personalized_models.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_quick_access.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_personalized_home_page.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    TvPersonalizedHomePage? page,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvPersonalizedHomePage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-070 shows compact hero and recommendation rows', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byType(TvHomeHero), findsOneWidget);
    expect(find.text(demoHomeHero.title), findsOneWidget);
    expect(find.text(TvHomePersonalizedCopy.recommendedForYou), findsOneWidget);
    expect(
      find.textContaining(TvHomePersonalizedCopy.becauseYouWatchedPrefix),
      findsOneWidget,
    );
    expect(find.text(TvHomePage.continueWatchingTitle), findsOneWidget);
    expect(find.text(TvHomePersonalizedCopy.heroLiveTvRule), findsOneWidget);
  });

  testWidgets('DSN-070 Live TV stays in header above the hero', (tester) async {
    TvHomeQuickDestination? selected;
    await pump(
      tester,
      page: TvPersonalizedHomePage(onQuickAccess: (d) => selected = d),
    );

    expect(find.text(Iconography.liveTv.label), findsOneWidget);

    final liveTvY = tester.getTopLeft(find.text(Iconography.liveTv.label)).dy;
    final heroY = tester.getTopLeft(find.byType(TvHomeHero)).dy;
    expect(liveTvY, lessThan(heroY));

    final continueY =
        tester.getTopLeft(find.text(TvHomePage.continueWatchingTitle)).dy;
    expect(heroY, lessThan(continueY));

    await tester.tap(find.text(Iconography.liveTv.label));
    await tester.pumpAndSettle();
    expect(selected, TvHomeQuickDestination.liveTv);
  });

  testWidgets('hero CTA and recommendation selection fire', (tester) async {
    var hero = 0;
    String? picked;
    await pump(
      tester,
      page: TvPersonalizedHomePage(
        onHeroWatch: () => hero++,
        onRecommendationSelected: (title) => picked = title,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('home-hero-cta')));
    await tester.pumpAndSettle();
    expect(hero, 1);

    await tester.tap(
      find.byKey(const ValueKey<String>('home-rec-because-harbor-0')),
    );
    await tester.pumpAndSettle();
    expect(picked, 'Night Run');
  });
}
