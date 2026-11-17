import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-054 doc maps interim PRD-006 SLOs to lab fixture suite', () {
    final file = File('docs/qa/qoe_slo_baselines.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-054'));
    expect(text, contains('PRD-006'));
    expect(text, contains('FR-029'));
    expect(text, contains('qoe_slo_baselines_test.dart'));
    expect(text, contains('3 s'));
    expect(text, contains('1.5 s'));
    expect(text, contains('2%'));
    expect(text, contains('lab'));
  });

  test('PRD-006 interim product lock records referential global budgets', () {
    final file = File('docs/product/prd_006_qoe_slo_baselines.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('PRD-006'));
    expect(text, contains('NFR-QOE-01'));
    expect(text, contains('NFR-QOE-02'));
    expect(text, contains('NFR-QOE-03'));
    expect(text, contains('Global'));
    expect(text, contains('MVP three'));
    expect(text, contains('synthetic'));
  });
}
