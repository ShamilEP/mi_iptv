import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_overlay_panel.dart';
import 'package:mi_iptv/core/widgets/vod_player_controls_overlay.dart';

void main() {
  testWidgets(
    'VodPlayerControlsOverlay exposes large volume and seek targets',
    (tester) async {
      var volumeUp = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.tvDark(),
          home: Scaffold(
            body: SizedBox(
              width: 1280,
              height: 720,
              child: OverlayStage(
                primaryAction: const Icon(Icons.play_circle),
                bottomOverlay: VodPlayerControlsOverlay(
                  positionLabel: '00:10',
                  durationLabel: '01:00',
                  progress: 0.2,
                  onVolumeUp: () => volumeUp = true,
                ),
                child: const ColoredBox(color: Colors.black),
              ),
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.replay_10));
      expect(icon.size, AppSpacing.xxl);
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              widget.semanticLabel == VodPlayerControlsOverlay.volumeUpLabel,
        ),
      );
      await tester.pump();
      expect(volumeUp, isTrue);
    },
  );
}
