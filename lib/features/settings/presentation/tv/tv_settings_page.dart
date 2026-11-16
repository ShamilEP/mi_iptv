import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/app_locale_scope.dart';
import '../../../../core/l10n/app_string_key.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import 'tv_language_panel.dart';
import 'tv_settings_copy.dart';
import 'tv_settings_models.dart';
import 'tv_settings_panels.dart';

/// Android TV Settings shell (TV-080).
///
/// Hierarchical categories — Account, Sources, Network, Language, Playback —
/// each showing current values on the rail and in the detail panel.
class TvSettingsPage extends StatefulWidget {
  const TvSettingsPage({
    super.key,
    this.initialCategory = TvSettingsCategory.account,
    this.snapshot = demoSnapshot,
  });

  final TvSettingsCategory initialCategory;
  final TvSettingsSnapshot snapshot;

  static const TvSettingsSnapshot demoSnapshot = TvSettingsSnapshot(
    account: <TvSettingsValue>[
      TvSettingsValue(label: 'Signed in as', value: 'you@example.com'),
      TvSettingsValue(label: 'Devices linked', value: '2'),
      TvSettingsValue(label: 'Profile', value: 'Default'),
    ],
    sources: <TvSettingsValue>[
      TvSettingsValue(label: 'Home Xtream', value: 'xtream · priority 1'),
      TvSettingsValue(label: 'M3U Playlist', value: 'm3u · priority 2'),
      TvSettingsValue(label: 'Mi Catalog', value: 'proprietary · priority 3'),
    ],
    network: <TvSettingsValue>[
      TvSettingsValue(label: 'Connection', value: 'Wi‑Fi · Good'),
      TvSettingsValue(label: 'IP mode', value: 'DHCP'),
    ],
    language: <TvSettingsValue>[
      TvSettingsValue(label: 'App language', value: 'English'),
      TvSettingsValue(label: 'Audio preference', value: 'Original'),
      TvSettingsValue(label: 'Subtitles', value: 'Off'),
    ],
    playback: <TvSettingsValue>[
      TvSettingsValue(label: 'Stream quality', value: 'Auto'),
      TvSettingsValue(label: 'Start muted', value: 'Off'),
      TvSettingsValue(label: 'Resume playback', value: 'On'),
    ],
  );

  @override
  State<TvSettingsPage> createState() => _TvSettingsPageState();
}

class _TvSettingsPageState extends State<TvSettingsPage> {
  late TvSettingsCategory _category = widget.initialCategory;

  AppLocale _localeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    return scope?.notifier?.locale ?? AppLocale.en;
  }

  bool _hasLocaleScope(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLocaleScope>() != null;

  String _categoryLabel(BuildContext context, TvSettingsCategory category) {
    final locale = _localeOf(context);
    switch (category) {
      case TvSettingsCategory.account:
        return TvSettingsCopy.forLocale(locale, AppStringKey.settingsAccount);
      case TvSettingsCategory.sources:
        return TvSettingsCopy.forLocale(locale, AppStringKey.settingsSources);
      case TvSettingsCategory.network:
        return TvSettingsCopy.forLocale(locale, AppStringKey.settingsNetwork);
      case TvSettingsCategory.language:
        return TvSettingsCopy.forLocale(locale, AppStringKey.settingsLanguage);
      case TvSettingsCategory.playback:
        return TvSettingsCopy.forLocale(locale, AppStringKey.settingsPlayback);
    }
  }

  List<TvSettingsValue> _languageExtraValues() {
    final values = widget.snapshot.valuesFor(TvSettingsCategory.language);
    if (values.length <= 1) return const <TvSettingsValue>[];
    return values.sublist(1);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final locale = _localeOf(context);
    final showLanguagePanel =
        _category == TvSettingsCategory.language && _hasLocaleScope(context);

    return TvAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.ink,
        body: Padding(
          padding: AppOverscan.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandLockup(markHeight: AppSpacing.xxl),
              const SizedBox(height: AppSpacing.md),
              Text(
                TvSettingsCopy.forLocale(locale, AppStringKey.settingsTitle),
                style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 360,
                      child: TvSettingsCategoryList(
                        selected: _category,
                        snapshot: widget.snapshot,
                        onSelected: (category) =>
                            setState(() => _category = category),
                      ),
                    ),
                    const SizedBox(width: AppGrid.railGap),
                    Expanded(
                      child: SingleChildScrollView(
                        child: showLanguagePanel
                            ? TvLanguagePanel(
                                extraValues: _languageExtraValues(),
                              )
                            : TvSettingsValuesPanel(
                                categoryLabel:
                                    _categoryLabel(context, _category),
                                values: widget.snapshot.valuesFor(_category),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
