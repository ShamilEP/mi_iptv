import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/catalog/presentation/tv/tv_content_detail_copy.dart';
import 'package:mi_iptv/features/catalog/presentation/tv/tv_content_detail_models.dart';
import 'package:mi_iptv/features/catalog/presentation/tv/tv_content_detail_page.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_mode.dart';
import 'package:mi_iptv/features/player/domain/services/abr_buffer_policy.dart';
import 'package:mi_iptv/features/player/domain/services/playback_error_classifier.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_copy.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_models.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_page.dart';
import 'package:mi_iptv/features/sync/domain/services/playback_progress_policy.dart';

void main() {
  group('QA-019 FR acceptance', () {
    testWidgets('FR-012 / FR-013 detail shows Play and Resume when eligible', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final detail = TvContentDetail(
        id: 'vod-1',
        title: 'Harbor Lights',
        synopsis: 'A night on the pier.',
        metadata: const <String>['2024', 'Drama'],
        durationLabel: '1h 40m',
        progress: 0.35,
      );
      expect(detail.showsResume, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.tvDark(),
          home: TvContentDetailPage(detail: detail),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Harbor Lights'), findsWidgets);
      expect(find.text(TvContentDetailCopy.playLabel), findsOneWidget);
      expect(find.text(TvContentDetailCopy.resumeLabel), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('detail-play')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('detail-resume')), findsOneWidget);
    });

    testWidgets('FR-026 Settings exposes Account Sources Network Language Playback',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.tvDark(),
          home: const TvSettingsPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(TvSettingsCopy.account), findsWidgets);
      expect(find.text(TvSettingsCopy.sources), findsOneWidget);
      expect(find.text(TvSettingsCopy.network), findsOneWidget);
      expect(find.text(TvSettingsCopy.language), findsOneWidget);
      expect(find.text(TvSettingsCopy.playback), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('settings-cat-network')));
      await tester.pumpAndSettle();
      expect(find.text('Connection'), findsOneWidget);
      expect(find.textContaining('Wi'), findsWidgets);
    });

    testWidgets('FR-024 Sources snapshot shows priority labels (read-only shell)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.tvDark(),
          home: const TvSettingsPage(
            initialCategory: TvSettingsCategory.sources,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('priority'), findsWidgets);
      expect(find.text('Home Xtream'), findsOneWidget);
    });

    test('FR-015 progress policy constants match PRD-030', () {
      expect(PlaybackProgressPolicy.saveInterval.inSeconds, 10);
      expect(PlaybackProgressPolicy.continueWatchingThreshold, 0.15);
    });

    test('FR-016 user messages stay simple (no raw Media3 codes)', () {
      final error = PlaybackErrorClassifier.classify(
        'ERROR_CODE_IO_NETWORK_CONNECTION_FAILED',
      );
      expect(error.userMessage.toLowerCase(), contains('connection'));
      expect(error.userMessage, isNot(contains('ERROR_CODE')));
      expect(error.code, contains('ERROR_CODE'));
    });

    test('FR-016 ABR defaults resolve for live and VOD', () {
      final live = AbrBufferPolicy.defaults.resolve(PlaybackMode.live);
      final vod = AbrBufferPolicy.defaults.resolve(PlaybackMode.vod);
      expect(live.maxBufferMs, lessThan(vod.maxBufferMs));
      expect(live.bandwidthFraction, greaterThan(0));
    });
  });
}
