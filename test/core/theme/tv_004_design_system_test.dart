import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/focusable_surface.dart';
import 'package:mi_iptv/core/widgets/ui_state.dart';
import 'package:mi_iptv/core/widgets/ui_state_catalog.dart';

/// Locks TV-004 Design System TV DoD against executable tokens.
void main() {
  test('TV theme uses dark Ink canvas and brand color scheme', () {
    final theme = AppTheme.tvDark();
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, AppColors.ink);
    expect(theme.colorScheme.primary, AppColors.signal);
    expect(theme.colorScheme.secondary, AppColors.ember);
    expect(theme.colorScheme.onSurface, AppColors.cloud);
    expect(theme.extension<MiBrandColors>()?.primary, AppColors.signal);
  });

  test('TV type scale Label is at least 16 sp', () {
    final theme = AppTheme.tvDark();
    expect(AppTypography.tvLabelSize, greaterThanOrEqualTo(16));
    expect(theme.textTheme.labelLarge?.fontSize, AppTypography.tvLabelSize);
    expect(theme.textTheme.labelLarge?.fontSize, greaterThanOrEqualTo(16));
  });

  test('focus modifier is 4 px Cloud ring and 1.05× scale', () {
    expect(FocusStyles.ringWidth, 4);
    expect(FocusStyles.scale, closeTo(1.05, 0.001));
    expect(FocusStyles.ringColor, AppColors.cloud);
    expect(FocusStyles.glowColor, AppColors.signal);

    final glow = FocusStyles.focusGlow();
    expect(glow, hasLength(2));
    expect(glow.first.spreadRadius, FocusStyles.ringWidth);
  });

  test('catalog locks exactly the 12 mandatory UI states', () {
    expect(UiState.values, hasLength(12));
    expect(UiStateCatalog.mandatoryLabels, hasLength(12));
    expect(UiStateCatalog.all, hasLength(12));
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

  testWidgets('TV app shell mounts AppTheme.tvDark', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MiIptvApp(clientKind: ClientKind.tv));
    await tester.pumpAndSettle();

    final material = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(material.theme?.scaffoldBackgroundColor, AppColors.ink);
    expect(
      material.theme?.textTheme.labelLarge?.fontSize,
      greaterThanOrEqualTo(16),
    );
  });

  testWidgets('FocusableSurface is the shared TV focus component', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: FocusableSurface(
          onPressed: () {},
          child: const SizedBox(width: 80, height: 80),
        ),
      ),
    );
    expect(find.byType(FocusableSurface), findsOneWidget);
  });
}
