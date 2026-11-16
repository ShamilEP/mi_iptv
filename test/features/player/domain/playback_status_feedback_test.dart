import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_status_feedback.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';

void main() {
  group('TV-055 playback status feedback', () {
    test('buffering phase maps to Loading feedback', () {
      expect(
        resolvePlaybackStatusFeedback(
          phase: MediaPlayerPhase.buffering,
          isReconnecting: false,
        ),
        PlaybackStatusFeedback.buffering,
      );
      expect(
        PlaybackStatusFeedbackCopy.labelFor(PlaybackStatusFeedback.buffering),
        'Loading…',
      );
    });

    test('reconnecting wins over buffering and uses plain copy', () {
      expect(
        resolvePlaybackStatusFeedback(
          phase: MediaPlayerPhase.buffering,
          isReconnecting: true,
        ),
        PlaybackStatusFeedback.reconnecting,
      );
      expect(
        PlaybackStatusFeedbackCopy.labelFor(
          PlaybackStatusFeedback.reconnecting,
        ),
        'Reconnecting…',
      );
    });

    test('playing / error / idle hide the spinner', () {
      for (final phase in <MediaPlayerPhase>[
        MediaPlayerPhase.idle,
        MediaPlayerPhase.playing,
        MediaPlayerPhase.paused,
        MediaPlayerPhase.ended,
        MediaPlayerPhase.error,
      ]) {
        expect(
          resolvePlaybackStatusFeedback(
            phase: phase,
            isReconnecting: false,
          ),
          PlaybackStatusFeedback.none,
        );
      }
    });

    test('labels never include technical jargon tokens', () {
      for (final feedback in PlaybackStatusFeedback.values) {
        final label = PlaybackStatusFeedbackCopy.labelFor(feedback);
        expect(label.toUpperCase(), isNot(contains('ERROR_CODE')));
        expect(label.toLowerCase(), isNot(contains('bitrate')));
        expect(label.toLowerCase(), isNot(contains('media3')));
        expect(label.toLowerCase(), isNot(contains('exoplayer')));
      }
    });
  });
}
