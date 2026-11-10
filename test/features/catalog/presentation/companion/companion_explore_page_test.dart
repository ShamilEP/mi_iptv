import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/control_chrome.dart';
import 'package:mi_iptv/core/widgets/mi_button.dart';
import 'package:mi_iptv/core/widgets/ui_state.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_copy.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_item.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {CompanionExplorePage? page}) async {
    await tester.binding.setSurfaceSize(const Size(390, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? const CompanionExplorePage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-052 showcase catalog has rails and no video player', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(CompanionExploreCopy.title), findsOneWidget);
    expect(find.text(CompanionExploreCopy.featuredTitle), findsOneWidget);
    expect(find.text(CompanionExploreCopy.liveTitle), findsOneWidget);
    expect(find.text(CompanionExploreCopy.moviesTitle), findsOneWidget);
    expect(find.text('Signal Night'), findsOneWidget);
    expect(find.text(CompanionExploreCopy.noPlayerNote), findsNothing);
    expect(find.byIcon(Icons.play_circle_outline), findsNothing);
    expect(find.byIcon(Icons.videocam), findsNothing);
  });

  testWidgets('send-to-TV emphasis resolves to companionLive', (tester) async {
    late Color fill;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: Builder(
          builder: (context) {
            fill = ControlChrome.resolve(
              context,
              state: UiState.defaults,
              role: ControlRole.button,
              emphasis: ControlEmphasis.sendToTv,
            ).fill;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(fill, AppColors.companionLive);
  });

  testWidgets('selecting a title shows Ember Reproducir en TV', (tester) async {
    CompanionExploreItem? sent;
    await pump(
      tester,
      page: CompanionExplorePage(onSendToTv: (item) => sent = item),
    );

    await tester.tap(find.byKey(const ValueKey('explore-featured-1')));
    await tester.pumpAndSettle();

    expect(find.text(CompanionExploreCopy.detailTitle), findsOneWidget);
    expect(find.text(CompanionExploreCopy.noPlayerNote), findsOneWidget);
    expect(find.text(CompanionExploreCopy.demoTvName), findsOneWidget);
    expect(find.text(CompanionExploreCopy.sendToTvLabel), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_outline), findsNothing);

    final button = tester.widget<MiButton>(
      find.widgetWithText(MiButton, CompanionExploreCopy.sendToTvLabel),
    );
    expect(button.emphasis, ControlEmphasis.sendToTv);

    await tester.tap(find.text(CompanionExploreCopy.sendToTvLabel));
    await tester.pump();

    expect(sent?.id, 'featured-1');
    expect(
      find.text('${CompanionExploreCopy.sentPrefix} Signal Night'),
      findsOneWidget,
    );
  });

  testWidgets('back returns to showcase rails', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('explore-movie-1')));
    await tester.pumpAndSettle();
    expect(find.text(CompanionExploreCopy.sendToTvLabel), findsOneWidget);

    await tester.tap(find.text(CompanionExploreCopy.backToCatalogLabel));
    await tester.pumpAndSettle();

    expect(find.text(CompanionExploreCopy.featuredTitle), findsOneWidget);
    expect(find.text(CompanionExploreCopy.sendToTvLabel), findsNothing);
  });
}
