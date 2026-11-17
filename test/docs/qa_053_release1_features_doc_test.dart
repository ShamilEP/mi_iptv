import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-053 doc maps Release 1 topics to provisional stories and suite', () {
    final file = File('docs/qa/release1_features.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-053'));
    expect(text, contains('PRD-032'));
    expect(text, contains('user_stories_release1.md'));
    expect(text, contains('release1_features_test.dart'));
    expect(text, contains('US-R1-01'));
    expect(text, contains('EPG'));
    expect(text, contains('XMLTV'));
    expect(text, contains('Multi-profile'));
    expect(text, contains('Parental'));
    expect(text, contains('Tolerant search'));
    expect(text, contains('Deep links'));
    expect(text, contains('Deferred'));
  });

  test('PRD-032 provisional stories cover US-R1-01 through US-R1-11', () {
    final file = File('docs/product/user_stories_release1.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('provisional'));
    expect(text, contains('PRD-032'));
    for (var i = 1; i <= 11; i++) {
      final id = 'US-R1-${i.toString().padLeft(2, '0')}';
      expect(text, contains(id), reason: id);
    }
  });
}
