/// One lab / synthetic QoE session sample for SLO comparison (FR-029 MVP trio).
final class QoeSessionSample {
  const QoeSessionSample({
    required this.id,
    required this.startup,
    required this.channelChange,
    required this.rebufferDuration,
    required this.playDuration,
  });

  final String id;

  /// Time from tune/start until first playable frame.
  final Duration startup;

  /// Live zap latency for this sample (use [Duration.zero] for non-zap sessions).
  final Duration channelChange;

  /// Aggregate rebuffer / stall time within [playDuration].
  final Duration rebufferDuration;

  /// Wall play time used as the rebuffer ratio denominator.
  final Duration playDuration;

  /// Rebuffer ratio; `0` when [playDuration] is zero.
  double get rebufferRatio {
    final playMs = playDuration.inMilliseconds;
    if (playMs <= 0) return 0;
    return rebufferDuration.inMilliseconds / playMs;
  }
}
