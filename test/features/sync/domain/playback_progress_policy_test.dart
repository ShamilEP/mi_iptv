import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/sync/domain/entities/playback_progress.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';
import 'package:mi_iptv/features/sync/domain/services/playback_progress_policy.dart';

void main() {
  group('QA-019 / FR-015 PlaybackProgressPolicy', () {
    test('locks 10s save interval and 15% Continue watching threshold', () {
      expect(PlaybackProgressPolicy.saveInterval, const Duration(seconds: 10));
      expect(PlaybackProgressPolicy.continueWatchingThreshold, 0.15);
    });

    test('qualifies only for recoverable mid-title progress', () {
      final sync = SyncMetadata(
        syncVersion: 1,
        updatedAtServer: DateTime.utc(2026, 11, 1),
      );
      const duration = Duration(minutes: 100);

      expect(
        PlaybackProgressPolicy.qualifiesForContinueWatching(
          PlaybackProgress(
            contentId: 'a',
            position: const Duration(minutes: 14),
            duration: duration,
            sync: sync,
          ),
        ),
        isFalse,
      );
      expect(
        PlaybackProgressPolicy.qualifiesForContinueWatching(
          PlaybackProgress(
            contentId: 'a',
            position: const Duration(minutes: 15),
            duration: duration,
            sync: sync,
          ),
        ),
        isTrue,
      );
      expect(
        PlaybackProgressPolicy.qualifiesForContinueWatching(
          PlaybackProgress(
            contentId: 'a',
            position: duration,
            duration: duration,
            sync: sync,
          ),
        ),
        isFalse,
      );
      expect(
        PlaybackProgressPolicy.qualifiesForContinueWatching(
          PlaybackProgress(
            contentId: 'a',
            position: const Duration(minutes: 50),
            duration: duration,
            sync: sync,
            forceReset: true,
          ),
        ),
        isFalse,
      );
    });

    test('Play starts at zero; Resume uses saved position when eligible', () {
      final sync = SyncMetadata(
        syncVersion: 1,
        updatedAtServer: DateTime.utc(2026, 11, 1),
      );
      final progress = PlaybackProgress(
        contentId: 'a',
        position: const Duration(minutes: 20),
        duration: const Duration(minutes: 100),
        sync: sync,
      );
      expect(PlaybackProgressPolicy.playFromStartPosition(), Duration.zero);
      expect(
        PlaybackProgressPolicy.resumePosition(progress),
        const Duration(minutes: 20),
      );
    });
  });
}
