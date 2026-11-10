import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/vod_player_controls_overlay.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_vod_player_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvVodPlayerPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvVodPlayerPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-037 shows timeline, large seek, and volume chrome', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(TvVodPlayerPage.demoTitle), findsOneWidget);
    expect(find.text('12:40'), findsOneWidget);
    expect(find.text('1:45:00'), findsOneWidget);
    expect(find.byIcon(Icons.replay_10), findsOneWidget);
    expect(find.byIcon(Icons.forward_10), findsOneWidget);
    expect(find.byIcon(Icons.volume_down), findsOneWidget);
    expect(find.byIcon(Icons.volume_up), findsWidgets);
    expect(find.byKey(const ValueKey('vod-play-pause')), findsOneWidget);
    expect(find.byType(VodPlayerControlsOverlay), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('controls auto-hide and return on select', (tester) async {
    await pump(tester);

    expect(find.text(TvVodPlayerPage.demoTitle), findsOneWidget);
    await tester.pump(AppMotion.playerControlsAutoHide);
    await tester.pump(AppMotion.normal);
    expect(find.text(TvVodPlayerPage.demoTitle), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pump();
    expect(find.text(TvVodPlayerPage.demoTitle), findsOneWidget);
  });

  testWidgets('seek and mute callbacks fire', (tester) async {
    var seekBack = 0;
    var seekForward = 0;
    var muted = 0;
    await pump(
      tester,
      page: TvVodPlayerPage(
        onSeekBackward: () => seekBack++,
        onSeekForward: () => seekForward++,
        onMuteToggle: () => muted++,
      ),
    );

    await tester.tap(find.byIcon(Icons.replay_10));
    await tester.tap(find.byIcon(Icons.forward_10));
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is Icon &&
            widget.semanticLabel == VodPlayerControlsOverlay.muteLabel,
      ),
    );
    await tester.pump();

    expect(seekBack, 1);
    expect(seekForward, 1);
    expect(muted, 1);
  });
}
