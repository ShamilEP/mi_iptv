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

  testWidgets('DSN-038 shows categories with current values', (tester) async {
    await pump(tester);

    expect(find.text(TvSettingsCopy.title), findsOneWidget);
    expect(find.text(TvSettingsCopy.playback), findsOneWidget);
    expect(find.text(TvSettingsCopy.account), findsOneWidget);
    expect(find.text(TvSettingsCopy.sources), findsOneWidget);
    expect(find.text(TvSettingsCopy.diagnostics), findsOneWidget);
    expect(find.text(TvSettingsCopy.currentValues), findsOneWidget);
    expect(find.text('Stream quality'), findsOneWidget);
    expect(find.text('Auto'), findsOneWidget);
  });

  testWidgets('sources panel reorders priority', (tester) async {
    await pump(
      tester,
      page: const TvSettingsPage(initialCategory: TvSettingsCategory.sources),
    );

    expect(find.textContaining('priority 1'), findsOneWidget);
    expect(find.text('Home Xtream'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('settings-source-src-m3u')),
        matching: find.text(TvSettingsCopy.moveUp),
      ),
    );
    await tester.pump();

    expect(find.textContaining('M3U Playlist'), findsOneWidget);
    final m3u = find.descendant(
      of: find.byKey(const ValueKey('settings-source-src-m3u')),
      matching: find.textContaining('priority 1'),
    );
    expect(m3u, findsOneWidget);
  });

  testWidgets('diagnostics shows network source latency buffer version', (
    tester,
  ) async {
    await pump(
      tester,
      page: const TvSettingsPage(
        initialCategory: TvSettingsCategory.diagnostics,
      ),
    );

    expect(find.text(TvSettingsCopy.network), findsOneWidget);
    expect(find.text(TvSettingsCopy.activeSource), findsOneWidget);
    expect(find.text(TvSettingsCopy.latency), findsOneWidget);
    expect(find.text(TvSettingsCopy.buffer), findsOneWidget);
    expect(find.text(TvSettingsCopy.version), findsOneWidget);
    expect(find.text('42 ms'), findsOneWidget);
    expect(find.text('0.1.0+mvp'), findsOneWidget);
  });

  testWidgets('selecting account shows signed-in value', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey('settings-cat-account')));
    await tester.pump();

    expect(find.text('Signed in as'), findsOneWidget);
    expect(find.text('you@example.com'), findsOneWidget);
  });
}
