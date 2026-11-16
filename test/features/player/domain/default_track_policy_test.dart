import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_track.dart';
import 'package:mi_iptv/features/player/domain/services/default_track_policy.dart';

void main() {
  group('TV-057 DefaultTrackPolicy', () {
    test('picks source-default audio and subtitle', () {
      final resolved = DefaultTrackPolicy.resolve(
        audioTracks: const [
          PlaybackTrack(
            id: 'aud-es',
            kind: PlaybackTrackKind.audio,
            label: 'Español',
            languageCode: 'es',
          ),
          PlaybackTrack(
            id: 'aud-en',
            kind: PlaybackTrackKind.audio,
            label: 'English',
            languageCode: 'en',
            isDefault: true,
          ),
        ],
        subtitleTracks: const [
          PlaybackTrack(
            id: 'sub-off',
            kind: PlaybackTrackKind.subtitle,
            label: 'Off',
            isOff: true,
          ),
          PlaybackTrack(
            id: 'sub-en',
            kind: PlaybackTrackKind.subtitle,
            label: 'English',
            languageCode: 'en',
            isDefault: true,
          ),
        ],
      );

      expect(resolved.audioTrackId, 'aud-en');
      expect(resolved.subtitleTrackId, 'sub-en');
    });

    test('falls back to Off when no default subtitle', () {
      final resolved = DefaultTrackPolicy.resolve(
        audioTracks: const [
          PlaybackTrack(
            id: 'aud-en',
            kind: PlaybackTrackKind.audio,
            label: 'English',
            isDefault: true,
          ),
        ],
        subtitleTracks: const [
          PlaybackTrack(
            id: 'sub-off',
            kind: PlaybackTrackKind.subtitle,
            label: 'Off',
            isOff: true,
          ),
          PlaybackTrack(
            id: 'sub-en',
            kind: PlaybackTrackKind.subtitle,
            label: 'English',
          ),
        ],
      );

      expect(resolved.audioTrackId, 'aud-en');
      expect(resolved.subtitleTrackId, 'sub-off');
    });

    test('falls back to first audio when no default flag', () {
      final resolved = DefaultTrackPolicy.resolve(
        audioTracks: const [
          PlaybackTrack(
            id: 'aud-a',
            kind: PlaybackTrackKind.audio,
            label: 'A',
          ),
          PlaybackTrack(
            id: 'aud-b',
            kind: PlaybackTrackKind.audio,
            label: 'B',
          ),
        ],
        subtitleTracks: const [],
      );

      expect(resolved.audioTrackId, 'aud-a');
      expect(resolved.subtitleTrackId, DefaultTrackPolicy.subtitleOffId);
    });
  });
}
