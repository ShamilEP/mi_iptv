import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/core/theme/theme.dart';

/// Locks CMP-003 Companion light theme + type scale DoD against executable tokens.
void main() {
  test('companion light theme uses Cloud canvas and locked accents', () {
    final theme = AppTheme.companionLight();
    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, AppColors.cloud);
    expect(theme.colorScheme.primary, AppColors.companionPrimary);
    expect(theme.colorScheme.secondary, AppColors.companionLive);
    expect(theme.colorScheme.onSurface, AppColors.ink);
    expect(AppColors.companionPrimary, const Color(0xFF0A6F68));
    expect(AppColors.companionLive, const Color(0xFFB8431B));
    expect(theme.extension<MiBrandColors>()?.primary, AppColors.companionPrimary);
    expect(theme.extension<MiBrandColors>()?.live, AppColors.companionLive);
  });

  test('companion type scale locks Headline 28, Title 20, Body 16, Label 13', () {
    final theme = AppTheme.companionLight();
    expect(AppTypography.companionHeadlineSize, 28);
    expect(AppTypography.companionTitleSize, 20);
    expect(AppTypography.companionBodySize, 16);
    expect(AppTypography.companionLabelSize, 13);

    expect(theme.textTheme.headlineMedium?.fontSize, 28);
    expect(theme.textTheme.titleLarge?.fontSize, 20);
    expect(theme.textTheme.bodyLarge?.fontSize, 16);
    expect(theme.textTheme.labelLarge?.fontSize, 13);
  });

  testWidgets('Companion app shell mounts AppTheme.companionLight', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MiIptvApp(clientKind: ClientKind.companion));
    await tester.pumpAndSettle();

    final material = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(material.theme?.scaffoldBackgroundColor, AppColors.cloud);
    expect(material.theme?.brightness, Brightness.light);
    expect(material.theme?.colorScheme.primary, AppColors.companionPrimary);
    expect(material.theme?.textTheme.headlineMedium?.fontSize, 28);
    expect(material.theme?.textTheme.titleLarge?.fontSize, 20);
    expect(material.theme?.textTheme.bodyLarge?.fontSize, 16);
    expect(material.theme?.textTheme.labelLarge?.fontSize, 13);
  });
}
