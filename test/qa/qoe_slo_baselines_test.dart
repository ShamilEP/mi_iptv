import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/qoe/qoe_slo_evaluator.dart';
import 'package:mi_iptv/core/qoe/referential_qoe_slos.dart';

import 'qoe_lab_fixtures.dart';

/// QA-054 / FR-029 — lab fixtures vs interim PRD-006 referential SLOs.
void main() {
  group('QA-054 QoE SLO baselines', () {
    test('locks global referential budgets from PRD-006 interim decision', () {
      expect(ReferentialQoeSlos.maxStartup, const Duration(seconds: 3));
      expect(
        ReferentialQoeSlos.maxChannelChange,
        const Duration(milliseconds: 1500),
      );
      expect(ReferentialQoeSlos.maxRebufferRatio, 0.02);
    });

    test('passing lab fixtures meet all three SLOs', () {
      final results = QoeSloEvaluator.evaluateAll(QoeLabFixtures.passing);
      expect(results, isNotEmpty);
      for (final result in results) {
        expect(result.passes, isTrue, reason: result.sampleId);
        expect(result.startupOk, isTrue);
        expect(result.channelChangeOk, isTrue);
        expect(result.rebufferOk, isTrue);
      }
    });

    test('detects startup, zap, and rebuffer breaches', () {
      final startup = QoeSloEvaluator.evaluate(QoeLabFixtures.slowStartup);
      expect(startup.startupOk, isFalse);
      expect(startup.channelChangeOk, isTrue);
      expect(startup.rebufferOk, isTrue);
      expect(startup.passes, isFalse);

      final zap = QoeSloEvaluator.evaluate(QoeLabFixtures.slowZap);
      expect(zap.channelChangeOk, isFalse);
      expect(zap.startupOk, isTrue);
      expect(zap.passes, isFalse);

      final rebuffer = QoeSloEvaluator.evaluate(QoeLabFixtures.highRebuffer);
      expect(rebuffer.rebufferOk, isFalse);
      expect(rebuffer.startupOk, isTrue);
      expect(rebuffer.channelChangeOk, isTrue);
      expect(rebuffer.passes, isFalse);
      expect(QoeLabFixtures.highRebuffer.rebufferRatio, greaterThanOrEqualTo(0.02));
    });
  });
}
