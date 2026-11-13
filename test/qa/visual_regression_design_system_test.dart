import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/focusable_surface.dart';
import 'package:mi_iptv/core/widgets/mi_button.dart';
import 'package:mi_iptv/core/widgets/ui_state.dart';
import 'package:mi_iptv/core/widgets/ui_state_catalog.dart';

import 'visual_regression_harness.dart';

/// QA-029 — Design System visual regression baselines (focus + 12 states).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QA-029 focus baselines', () {
    testWidgets('resting FocusableSurface (no ring / scale)', (tester) async {
      await VisualRegressionHarness.pumpTvCanvas(
        tester,
        child: FocusableSurface(
          kind: FocusControlKind.button,
          applySpecPadding: true,
          onPressed: () {},
          child: Text(
            'Focus sample',
            style: TextStyle(
              color: AppColors.cloud,
              fontSize: AppTypography.tvLabelSize,
              fontFamily: AppTypography.bodyFamily,
            ),
          ),
        ),
      );

      await VisualRegressionHarness.expectGolden(
        tester,
        'design_system_focus_resting',
      );
    });

    testWidgets('focused FocusableSurface (Cloud ring + Signal glow + scale)', (
      tester,
    ) async {
      final focusNode = FocusNode(debugLabel: 'golden-focus');
      addTearDown(focusNode.dispose);

      await VisualRegressionHarness.pumpTvCanvas(
        tester,
        child: FocusableSurface(
          kind: FocusControlKind.button,
          focusNode: focusNode,
          applySpecPadding: true,
          onPressed: () {},
          child: Text(
            'Focus sample',
            style: TextStyle(
              color: AppColors.cloud,
              fontSize: AppTypography.tvLabelSize,
              fontFamily: AppTypography.bodyFamily,
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      // Also exercise D-pad path used in TV QA.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);

      await VisualRegressionHarness.expectGolden(
        tester,
        'design_system_focus_focused',
      );
    });
  });

  group('QA-029 twelve UiState baselines', () {
    testWidgets('MiButton catalog locks all 12 mandatory states', (tester) async {
      expect(UiState.values, hasLength(UiStateCatalog.mandatoryLabels.length));

      await VisualRegressionHarness.pumpTvCanvas(
        tester,
        size: const Size(960, 900),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final state in UiState.values) ...[
                MiButton(
                  label: UiStateCatalog.of(state).label,
                  state: state,
                  onPressed: state == UiState.disabled ||
                          state == UiState.loading ||
                          state == UiState.empty ||
                          state == UiState.syncing
                      ? null
                      : () {},
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
      );

      for (final state in UiState.values) {
        expect(
          find.text(UiStateCatalog.of(state).label),
          findsWidgets,
          reason: 'catalog must paint ${state.name}',
        );
      }

      await VisualRegressionHarness.expectGolden(
        tester,
        'design_system_ui_states_12',
      );
    });
  });
}
