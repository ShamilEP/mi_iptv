import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
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

  String _categoryLabel(TvSettingsCategory category) {
    switch (category) {
      case TvSettingsCategory.account:
        return TvSettingsCopy.account;
      case TvSettingsCategory.sources:
        return TvSettingsCopy.sources;
      case TvSettingsCategory.network:
        return TvSettingsCopy.network;
      case TvSettingsCategory.language:
        return TvSettingsCopy.language;
      case TvSettingsCategory.playback:
        return TvSettingsCopy.playback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: brand.ink,
      body: Padding(
        padding: AppOverscan.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandLockup(markHeight: AppSpacing.xxl),
            const SizedBox(height: AppSpacing.md),
            Text(
              TvSettingsCopy.title,
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
                      child: TvSettingsValuesPanel(
                        categoryLabel: _categoryLabel(_category),
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
    );
  }
}
