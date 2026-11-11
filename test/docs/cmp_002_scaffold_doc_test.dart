import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-002 scaffold doc and CI workflow exist', () {
    expect(File('docs/architecture/cmp-002-android-ios-scaffold.md').existsSync(), isTrue);
    expect(File('.github/workflows/ci.yml').existsSync(), isTrue);
    expect(File('ios/Flutter/tv.xcconfig').existsSync(), isTrue);
    expect(File('ios/Flutter/companion.xcconfig').existsSync(), isTrue);
    expect(File('android/app/src/tv/res/values/strings.xml').existsSync(), isTrue);
    expect(
      File('android/app/src/companion/res/values/strings.xml').existsSync(),
      isTrue,
    );

    final doc = File('docs/architecture/cmp-002-android-ios-scaffold.md').readAsStringSync();
    expect(doc, contains('CMP-002'));
    expect(doc, contains('AppDependencies'));
    expect(doc, contains('AppRoutes'));
    expect(doc, contains('--flavor'));
    expect(doc, contains('get_it'));
  });
}
