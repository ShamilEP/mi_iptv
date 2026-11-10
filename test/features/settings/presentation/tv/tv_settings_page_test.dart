import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_copy.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_models.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvSettingsPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvSettingsPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('TV-080 shows hierarchical categories with current values', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(TvSettingsCopy.title), findsOneWidget);
    expect(find.text(TvSettingsCopy.account), findsWidgets);
    expect(find.text(TvSettingsCopy.sources), findsOneWidget);
    expect(find.text(TvSettingsCopy.network), findsOneWidget);
    expect(find.text(TvSettingsCopy.language), findsOneWidget);
    expect(find.text(TvSettingsCopy.playback), findsOneWidget);

    // Rail summaries + detail values are visible.
    expect(find.text('you@example.com'), findsWidgets);
    expect(find.text(TvSettingsCopy.currentValues), findsOneWidget);
    expect(find.text('Signed in as'), findsOneWidget);
    expect(find.text('Devices linked'), findsOneWidget);
  });

  testWidgets('selecting Playback shows stream quality value', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('settings-cat-playback')));
    await tester.pump();

    expect(find.text(TvSettingsCopy.playback), findsWidgets);
    expect(find.text('Stream quality'), findsOneWidget);
    expect(find.text('Auto'), findsWidgets);
    expect(find.text('Resume playback'), findsOneWidget);
  });

  testWidgets('selecting Sources shows priority values', (tester) async {
    await pump(
      tester,
      page: const TvSettingsPage(initialCategory: TvSettingsCategory.sources),
    );

    expect(find.text('Home Xtream'), findsOneWidget);
    expect(find.text('xtream · priority 1'), findsWidgets);
    expect(find.text('M3U Playlist'), findsOneWidget);
    expect(find.text('Mi Catalog'), findsOneWidget);
  });

  testWidgets('selecting Network and Language shows current values', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('settings-cat-network')));
    await tester.pump();
    expect(find.text('Connection'), findsOneWidget);
    expect(find.text('Wi‑Fi · Good'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('settings-cat-language')));
    await tester.pump();
    expect(find.text('App language'), findsOneWidget);
    expect(find.text('English'), findsWidgets);
    expect(find.text('Subtitles'), findsOneWidget);
  });
}
