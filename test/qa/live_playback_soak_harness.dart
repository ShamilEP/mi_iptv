import 'package:mi_iptv/core/images/image_pipeline_config.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_mode.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/entities/stream_protocol.dart';

/// Constants and helpers for QA-042 live playback soak (NFR-003).
///
/// Lab target is [labDuration]. CI uses [acceleratedCycles] of in-process
/// live hold / zap / interrupt work instead of wall-clock overnight runs.
abstract final class LivePlaybackSoak {
  /// Physical soak duration on a QA-002 TV / stick.
  static const Duration labDuration = Duration(hours: 24);

  /// Accelerated cycles for `flutter test` (≈ one simulated live minute each).
  ///
  /// Sized to stress session + cache churn without multi-minute CI runtime.
  static const int acceleratedCycles = 24 * 60; // 1440 ≈ 24h of minutes

  /// Channel-zap iterations nested inside the accelerated soak.
  static const int zapCycles = 240;

  /// Background / HDMI interrupt samples during the soak.
  static const int interruptSamples = 48;

  /// Fake live URIs (HTTPS only; no credentials).
  static const List<String> liveUris = <String>[
    'https://cdn.example/live/news.m3u8',
    'https://cdn.example/live/sports.m3u8',
    'https://cdn.example/live/movies.m3u8',
  ];

  static ImagePipelineConfig get lowMemoryBudget =>
      ImagePipelineConfig.tvLowMemory;

  static PlaybackRequest liveRequest(int channelIndex) {
    final uri = liveUris[channelIndex % liveUris.length];
    return PlaybackRequest(
      streamUri: Uri.parse(uri),
      protocolHint: StreamProtocol.hls,
      mode: PlaybackMode.live,
    );
  }
}
