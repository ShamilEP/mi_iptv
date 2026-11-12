import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks TV-001 / PRD-010 ADR deliverable.
void main() {
  test('ADR-002 documents Flutter TV toolkit and API 34 minSdk', () {
    final file = File('docs/architecture/adr-002-tv-toolkit-sdk.md');
    expect(file.existsSync(), isTrue);

    final text = file.readAsStringSync();
    final lower = text.toLowerCase();
    expect(text, contains('ADR-002'));
    expect(text, contains('TV-001'));
    expect(text, contains('PRD-010'));
    expect(text, contains('Flutter'));
    expect(text, contains('API 34'));
    expect(lower, contains('minsdk'));
    expect(lower, contains('target'));
    expect(text, contains('build.gradle.kts'));
    expect(text, contains('Accepted'));
    expect(lower, contains('not'));
    expect(lower, contains('compose'));
  });

  test('TV flavor pins minSdk 34 in Android Gradle', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('TV-001'));
    expect(gradle, contains('create("tv")'));
    expect(gradle, contains('minSdk = 34'));
    expect(gradle, contains('targetSdk = flutter.targetSdkVersion'));
    expect(gradle, contains('compileSdk = flutter.compileSdkVersion'));
  });
}
