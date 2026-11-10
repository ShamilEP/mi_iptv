import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_profile_edit_panel.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_profile_models.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_profile_picker_page.dart';
import 'package:mi_iptv/features/profiles/presentation/tv/tv_profile_tile.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvProfilePickerPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvProfilePickerPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-061 shows launch picker with profiles and Add tile', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(TvProfileCopy.pickerTitle), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Sam'), findsOneWidget);
    expect(find.text('Kids'), findsWidgets);
    expect(find.text(TvProfileCopy.kidsBadge), findsWidgets);
    expect(find.byType(TvProfileTile), findsNWidgets(3));
    expect(find.byType(TvAddProfileTile), findsOneWidget);
    expect(find.text(TvProfileCopy.manageLabel), findsOneWidget);
  });

  testWidgets('selecting a profile reports the selection', (tester) async {
    TvProfile? selected;
    await pump(
      tester,
      page: TvProfilePickerPage(
        onProfileSelected: (profile) => selected = profile,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('profile-tile-p-alex')));
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.name, 'Alex');
  });

  testWidgets('manage opens edit; kid badge remains visible', (tester) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey<String>('profile-manage')));
    await tester.pumpAndSettle();
    expect(find.text(TvProfileCopy.doneManageLabel), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('profile-tile-p-kids')));
    await tester.pumpAndSettle();

    expect(find.byType(TvProfileEditPanel), findsOneWidget);
    expect(find.text(TvProfileCopy.editTitle), findsOneWidget);
    expect(find.text(TvProfileCopy.kidToggleLabel), findsOneWidget);
    expect(find.text(TvProfileCopy.kidsBadge), findsWidgets);
  });

  testWidgets('add profile opens create form and saves a new tile', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.byKey(const ValueKey<String>('profile-tile-add')));
    await tester.pumpAndSettle();

    expect(find.text(TvProfileCopy.createTitle), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey<String>('profile-name-field')),
      'Jordan',
    );
    await tester.tap(find.byKey(const ValueKey<String>('profile-kid-toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('profile-save')));
    await tester.pumpAndSettle();

    expect(find.text(TvProfileCopy.pickerTitle), findsOneWidget);
    expect(find.text('Jordan'), findsOneWidget);
    expect(find.byType(TvProfileTile), findsNWidgets(4));
    expect(find.text(TvProfileCopy.kidsBadge), findsWidgets);
  });
}
