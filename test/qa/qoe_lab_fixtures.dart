import 'package:mi_iptv/core/qoe/qoe_session_sample.dart';

/// Synthetic lab QoE sessions for QA-054 (no beta CSV / no credentials).
abstract final class QoeLabFixtures {
  /// Sessions expected to pass all interim referential SLOs.
  static const List<QoeSessionSample> passing = <QoeSessionSample>[
    QoeSessionSample(
      id: 'lab-pass-live-zap',
      startup: Duration(milliseconds: 2200),
      channelChange: Duration(milliseconds: 900),
      rebufferDuration: Duration(seconds: 1),
      playDuration: Duration(minutes: 2),
    ),
    QoeSessionSample(
      id: 'lab-pass-vod-start',
      startup: Duration(milliseconds: 2800),
      channelChange: Duration.zero,
      rebufferDuration: Duration(milliseconds: 500),
      playDuration: Duration(minutes: 5),
    ),
  ];

  static const QoeSessionSample slowStartup = QoeSessionSample(
    id: 'lab-fail-startup',
    startup: Duration(milliseconds: 3200),
    channelChange: Duration(milliseconds: 800),
    rebufferDuration: Duration(milliseconds: 200),
    playDuration: Duration(minutes: 1),
  );

  static const QoeSessionSample slowZap = QoeSessionSample(
    id: 'lab-fail-zap',
    startup: Duration(milliseconds: 1500),
    channelChange: Duration(milliseconds: 1600),
    rebufferDuration: Duration(milliseconds: 100),
    playDuration: Duration(minutes: 1),
  );

  static const QoeSessionSample highRebuffer = QoeSessionSample(
    id: 'lab-fail-rebuffer',
    startup: Duration(milliseconds: 1000),
    channelChange: Duration(milliseconds: 500),
    rebufferDuration: Duration(seconds: 3),
    playDuration: Duration(seconds: 100),
  );
}
