import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/brand_lockup.dart';
import 'package:mi_iptv/features/startup/presentation/tv/tv_splash_page.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    TvSplashPage? page,
    bool disableAnimations = false,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        builder: (context, child) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(disableAnimations: disableAnimations),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: page ?? const TvSplashPage(),
      ),
    );
  }

  testWidgets('DSN-030 shows centered BrandLockup on Ink', (tester) async {
    await pump(tester, page: const TvSplashPage(hold: Duration(days: 1)));
    await tester.pump();

    expect(find.byType(BrandLockup), findsOneWidget);
    expect(find.text(BrandAssets.wordmarkText), findsOneWidget);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.ink);
  });

  testWidgets('fires onFinished after short hold', (tester) async {
    var finished = 0;
    await pump(
      tester,
      page: TvSplashPage(
        hold: AppMotion.splashHold,
        onFinished: () => finished++,
      ),
    );
    await tester.pump();
    expect(finished, 0);

    // Complete the fade, then flush whenComplete so the hold timer arms.
    await tester.pump(AppMotion.fast);
    await tester.pump(Duration.zero);
    expect(finished, 0);

    await tester.pump(AppMotion.splashHold);
    expect(finished, 1);

    await tester.pump(AppMotion.splashHold);
    expect(finished, 1);
  });

  testWidgets('reduced motion skips fade and hold', (tester) async {
    var finished = 0;
    await pump(
      tester,
      disableAnimations: true,
      page: TvSplashPage(
        hold: AppMotion.splashHold,
        onFinished: () => finished++,
      ),
    );
    await tester.pump(); // post-frame: complete immediately
    expect(finished, 1);
    expect(find.byType(BrandLockup), findsOneWidget);
  });

  test('splashHold stays under one second', () {
    expect(AppMotion.splashHold.inMilliseconds, lessThan(1000));
    expect(AppMotion.splashHold.inMilliseconds, greaterThan(0));
  });
}
