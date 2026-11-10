import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_subtitle_caption.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_track_models.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_track_selector_panel.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_vod_player_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvVodPlayerPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvVodPlayerPage(autoHide: false),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-064 opens audio & subtitle picker from overlay', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byKey(const ValueKey<String>('vod-track-selector')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('vod-track-selector')));
    await tester.pumpAndSettle();

    expect(find.byType(TvTrackSelectorPanel), findsOneWidget);
    expect(find.text(TvTrackSelectorCopy.title), findsOneWidget);
    expect(find.text(TvTrackSelectorCopy.audioSection), findsOneWidget);
    expect(find.text(TvTrackSelectorCopy.subtitleSection), findsOneWidget);
    expect(find.text('English'), findsWidgets);
    expect(find.text(TvTrackSelectorCopy.offLabel), findsOneWidget);
  });

  testWidgets('selection is remembered after close and reopen', (tester) async {
    TvTrackPreference? remembered;
    await pump(
      tester,
      page: TvVodPlayerPage(
        autoHide: false,
        onPreferenceChanged: (pref) => remembered = pref,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('vod-track-selector')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('track-aud-es')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('track-sub-fr')));
    await tester.pumpAndSettle();

    expect(remembered?.audioTrackId, 'aud-es');
    expect(remembered?.subtitleTrackId, 'sub-fr');

    await tester.tap(find.byKey(const ValueKey<String>('track-selector-close')));
    await tester.pumpAndSettle();
    expect(find.byType(TvTrackSelectorPanel), findsNothing);

    await tester.tap(find.byKey(const ValueKey<String>('vod-track-selector')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('track-aud-es')),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('track-sub-fr')),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
  });

  testWidgets('subtitle Off hides caption; language restores it', (tester) async {
    await pump(tester);

    expect(find.byType(MiSubtitleCaption), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('vod-track-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('track-sub-off')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('track-selector-close')));
    await tester.pumpAndSettle();

    expect(find.byType(MiSubtitleCaption), findsNothing);

    await tester.tap(find.byKey(const ValueKey<String>('vod-track-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('track-sub-en')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('track-selector-close')));
    await tester.pumpAndSettle();

    expect(find.byType(MiSubtitleCaption), findsOneWidget);
  });
}
