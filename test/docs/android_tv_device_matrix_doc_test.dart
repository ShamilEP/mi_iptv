import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks QA-002 Android TV device matrix deliverable.
void main() {
  test('QA-002 device matrix covers OEM, SoC, resolution, API, low-memory, mid-range', () {
    final file = File('docs/qa/android_tv_device_matrix.md');
    expect(file.existsSync(), isTrue);

    final text = file.readAsStringSync();
    final lower = text.toLowerCase();
    expect(text, contains('QA-002'));
    expect(text, contains('PRD-010'));
    expect(text, contains('API 34'));
    expect(lower, contains('manufacturer'));
    expect(lower, contains('soc'));
    expect(text, contains('1080p'));
    expect(lower, contains('low-memory'));
    expect(lower, contains('mid-range'));
    expect(lower, contains('google tv'));
    expect(text, contains('Must secure before MVP close'));
    expect(text, contains('Widevine L3'));
  });
}
