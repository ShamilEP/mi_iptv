import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks TV-002 app module scaffold deliverable.
void main() {
  test('TV-002 scaffold doc covers modules, DI, and env flavors', () {
    final file = File('docs/architecture/tv-002-app-module-scaffold.md');
    expect(file.existsSync(), isTrue);

    final text = file.readAsStringSync();
    final lower = text.toLowerCase();
    expect(text, contains('TV-002'));
    expect(text, contains('AppDependencies'));
    expect(text, contains('AppEnvironment'));
    expect(text, contains('AppRoutes'));
    expect(lower, contains('home'));
    expect(lower, contains('live'));
    expect(lower, contains('vod'));
    expect(lower, contains('search'));
    expect(lower, contains('favorites'));
    expect(lower, contains('settings'));
    expect(text, contains('MediaPlayerController'));
    expect(text, contains('tvDev'));
    expect(text, contains('APP_ENV'));
    expect(lower, contains('dev'));
    expect(lower, contains('qa'));
    expect(lower, contains('prod'));
  });

  test('Android Gradle declares client and env flavor dimensions', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('TV-002'));
    expect(gradle, contains('flavorDimensions += "client"'));
    expect(gradle, contains('flavorDimensions += "env"'));
    expect(gradle, contains('create("dev")'));
    expect(gradle, contains('create("qa")'));
    expect(gradle, contains('create("prod")'));
  });

  test('CI builds combined tvDev and companionDev flavors', () {
    final ci = File('.github/workflows/ci.yml').readAsStringSync();
    expect(ci, contains('--flavor tvDev'));
    expect(ci, contains('--flavor companionDev'));
    expect(ci, contains('APP_ENV=dev'));
  });
}
