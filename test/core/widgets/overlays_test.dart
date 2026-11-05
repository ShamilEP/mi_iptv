import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/channel_info_overlay.dart';
import 'package:mi_iptv/core/widgets/error_retry_overlay.dart';
import 'package:mi_iptv/core/widgets/mi_overlay_panel.dart';
import 'package:mi_iptv/core/widgets/player_controls_overlay.dart';
import 'package:mi_iptv/core/widgets/sync_conflict_toast.dart';

void main() {
  Future<void> pumpOverlay(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: Scaffold(
          backgroundColor: AppColors.ink,
          body: SizedBox(width: 1280, height: 720, child: child),
        ),
      ),
    );
  }

  testWidgets('ChannelInfoOverlay auto-hides after 4 seconds', (tester) async {
    final key = GlobalKey<ChannelInfoOverlayState>();
    await pumpOverlay(
      tester,
      OverlayStage(
        primaryAction: const Icon(Icons.play_arrow, key: ValueKey('play')),
        topOverlay: ChannelInfoOverlay(
          key: key,
          channelNumber: '12',
          channelTitle: 'Signal News',
          nowPlaying: 'Headlines',
        ),
        child: const ColoredBox(color: Colors.black),
      ),
    );

    expect(find.text('Signal News'), findsOneWidget);
    expect(key.currentState!.isShowing, isTrue);
    expect(
      find.byKey(const ValueKey('overlay-primary-action')),
      findsOneWidget,
    );

    await tester.pump(AppMotion.channelInfoAutoHide);
    await tester.pump(AppMotion.normal);
    expect(key.currentState!.isShowing, isFalse);
  });

  testWidgets('PlayerControlsOverlay paints transport chrome in bottom band', (
    tester,
  ) async {
    await pumpOverlay(
      tester,
      const OverlayStage(
        primaryAction: Icon(Icons.play_circle, key: ValueKey('play')),
        bottomOverlay: PlayerControlsOverlay(
          positionLabel: '01:20',
          durationLabel: '45:00',
          progress: 0.25,
        ),
        child: ColoredBox(color: Colors.black),
      ),
    );

    expect(find.text('01:20'), findsOneWidget);
    expect(find.text('45:00'), findsOneWidget);
    expect(find.byIcon(Icons.replay_10), findsOneWidget);
    expect(
      find.byKey(const ValueKey('overlay-primary-action')),
      findsOneWidget,
    );
  });

  testWidgets('ErrorRetryOverlay shows error cue and invokes retry', (
    tester,
  ) async {
    var retried = false;
    await pumpOverlay(
      tester,
      OverlayStage(
        primaryAction: const Icon(Icons.refresh),
        bottomOverlay: ErrorRetryOverlay(
          message: 'Stream failed',
          onRetry: () => retried = true,
        ),
        child: const ColoredBox(color: Colors.black),
      ),
    );

    expect(find.text('Error'), findsWidgets);
    expect(find.text('Stream failed'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(retried, isTrue);
  });

  testWidgets('SyncConflictToast shows warning label and resolve action', (
    tester,
  ) async {
    var resolved = false;
    await pumpOverlay(
      tester,
      OverlayStage(
        primaryAction: const Icon(Icons.play_arrow),
        bottomOverlay: SyncConflictToast(
          message: 'Playback position differs on another device',
          onResolve: () => resolved = true,
        ),
        child: const ColoredBox(color: Colors.black),
      ),
    );

    expect(find.text('Sync Conflict'), findsOneWidget);
    await tester.tap(find.text('Resolve'));
    await tester.pumpAndSettle();
    expect(resolved, isTrue);
  });

  testWidgets('MiOverlayPanel uses semi-transparent scrim', (tester) async {
    late Color scrim;
    await pumpOverlay(
      tester,
      Builder(
        builder: (context) {
          scrim = MiOverlayPanel.scrimColor(context);
          return const MiOverlayPanel(child: Text('band'));
        },
      ),
    );
    expect(scrim.a, lessThan(1));
    expect(find.text('band'), findsOneWidget);
  });
}
