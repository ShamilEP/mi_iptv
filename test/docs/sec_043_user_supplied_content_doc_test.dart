import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SEC-043 draft ToS doc maps user sources and takedown placeholders', () {
    final file = File('docs/legal/user_supplied_content_tos_draft.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('DRAFT'));
    expect(text, contains('SEC-043'));
    expect(text, contains('PRD-040'));
    expect(text, contains('User-supplied'));
    expect(text, contains('Xtream'));
    expect(text, contains('Complaint / takedown'));
    expect(text, contains('UserSuppliedContentPolicy'));
    expect(text, contains('not legal advice'));
  });
}
