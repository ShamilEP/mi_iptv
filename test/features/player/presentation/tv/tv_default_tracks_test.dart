import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_subtitle_caption.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_track_models.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_vod_player_page.dart';

void main() {
  test('TV-057 sourceDefaults prefer marked default tracks', () {
    final pref = TvTrackPreference.sourceDefaults();
    expect(pref.audioTrackId, demoDefaultAudioId);
    expect(pref.subtitleTrackId, demoDefaultSubtitleId);
  });

  testWidgets('TV-057 live cue renders with DSN-021 MiSubtitleCaption', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final player = MemoryMediaPlayerController();
    addTearDown(player.dispose);
    final request = PlaybackRequest(
      streamUri: Uri.parse('https://cdn.example/vod.mp4'),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: TvVodPlayerPage(
          autoHide: false,
          mediaPlayer: player,
          playbackRequest: request,
          subtitleText: 'Shell fallback',
        ),
      ),
    );
    await tester.pumpAndSettle();

    player.emitSubtitleCue('Harbor lights ahead');
    await tester.pumpAndSettle();

    expect(find.byType(MiSubtitleCaption), findsOneWidget);
    expect(find.text('Harbor lights ahead'), findsOneWidget);
    expect(find.text('Shell fallback'), findsNothing);

    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(MiSubtitleCaption),
        matching: find.byType(DecoratedBox),
      ),
    );
    expect(
      (box.decoration as BoxDecoration).color,
      AppSubtitleStyle.background,
    );
  });
}
