import 'qoe_session_sample.dart';
import 'referential_qoe_slos.dart';

/// Pass/fail of a [QoeSessionSample] against [ReferentialQoeSlos].
final class QoeSloResult {
  const QoeSloResult({
    required this.sampleId,
    required this.startupOk,
    required this.channelChangeOk,
    required this.rebufferOk,
  });

  final String sampleId;
  final bool startupOk;
  final bool channelChangeOk;
  final bool rebufferOk;

  bool get passes => startupOk && channelChangeOk && rebufferOk;
}

/// Compares lab/synthetic QoE samples to interim PRD-006 referential budgets.
abstract final class QoeSloEvaluator {
  static QoeSloResult evaluate(
    QoeSessionSample sample, {
    Duration maxStartup = ReferentialQoeSlos.maxStartup,
    Duration maxChannelChange = ReferentialQoeSlos.maxChannelChange,
    double maxRebufferRatio = ReferentialQoeSlos.maxRebufferRatio,
  }) {
    return QoeSloResult(
      sampleId: sample.id,
      startupOk: sample.startup < maxStartup,
      channelChangeOk: sample.channelChange < maxChannelChange,
      rebufferOk: sample.rebufferRatio < maxRebufferRatio,
    );
  }

  static List<QoeSloResult> evaluateAll(Iterable<QoeSessionSample> samples) =>
      samples.map(evaluate).toList(growable: false);
}
