import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/focus_styles.dart';
import 'package:mi_iptv/core/widgets/ui_state.dart';
import 'package:mi_iptv/core/widgets/ui_state_catalog.dart';

void main() {
  group('DSN-010 mandatory UI states', () {
    test('enum locks exactly the 12 SRS states', () {
      expect(UiState.values, hasLength(12));
      expect(UiStateCatalog.mandatoryLabels, hasLength(12));
      expect(
        UiStateCatalog.mandatoryLabels,
        <String>[
          'Default',
          'Focused',
          'Pressed',
          'Disabled',
          'Loading',
          'Empty',
          'Error',
          'Offline',
          'Playing',
          'Selected',
          'Syncing',
          'Sync Conflict',
        ],
      );
    });

    test('catalog covers every enum value with matching labels', () {
      final definitions = UiStateCatalog.all;
      expect(definitions, hasLength(UiState.values.length));
      expect(
        definitions.map((d) => d.label).toList(),
        UiStateCatalog.mandatoryLabels,
      );
      for (var i = 0; i < UiState.values.length; i++) {
        expect(definitions[i].state, UiState.values[i]);
        expect(definitions[i].label, UiStateCatalog.mandatoryLabels[i]);
      }
    });

    test('every state requires at least one non-color cue', () {
      for (final definition in UiStateCatalog.all) {
        expect(
          definition.nonColorCues,
          isNotEmpty,
          reason: '${definition.label} must not rely on hue alone',
        );
        for (final cue in definition.nonColorCues) {
          expect(cue.description.trim(), isNotEmpty);
        }
      }
    });

    test('Focused definition references DSN-006 FocusStyles tokens', () {
      final focused = UiStateCatalog.of(UiState.focused);
      expect(focused.label, 'Focused');
      final joined =
          focused.nonColorCues.map((c) => c.description).join(' | ');
      expect(joined, contains('${FocusStyles.ringWidth}px'));
      expect(joined, contains('${FocusStyles.scale}'));
      expect(joined, contains('Cloud'));
      expect(joined, contains('Signal'));
    });

    test('defaults maps to product label Default', () {
      expect(UiStateCatalog.of(UiState.defaults).label, 'Default');
    });

    test('syncConflict maps to Sync Conflict', () {
      expect(UiStateCatalog.of(UiState.syncConflict).label, 'Sync Conflict');
    });
  });
}
