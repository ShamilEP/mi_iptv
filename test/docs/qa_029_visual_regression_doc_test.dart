import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-029 doc maps focus and 12-state visual regression baselines', () {
    final file = File('docs/qa/visual_regression_design_system.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-029'));
    expect(text, contains('SRS §22'));
    expect(text, contains('TV-004'));
    expect(text, contains('matchesGoldenFile'));
    expect(text, contains('design_system_focus_resting'));
    expect(text, contains('design_system_focus_focused'));
    expect(text, contains('design_system_ui_states_12'));
    expect(text, contains('FocusableSurface'));
    expect(text, contains('UiState'));
    expect(text, contains('UPDATE_GOLDENS'));
  });
}
