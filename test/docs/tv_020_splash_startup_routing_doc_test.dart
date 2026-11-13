import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-020 doc locks splash, JWT inspect, warm, and Home/Onboarding', () {
    final file = File('docs/architecture/tv-020-splash-startup-routing.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-020'));
    expect(text, contains('Frontend §2.3'));
    expect(text, contains('TvStartupGate'));
    expect(text, contains('SessionJwtInspector'));
    expect(text, contains('WarmLocalMedia'));
    expect(text, contains('onboarding'));
    expect(text, contains('Home'));
    expect(text, contains('TV-007'));
    expect(text, contains('TV-008'));
  });
}
