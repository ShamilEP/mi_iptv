import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import 'tv_settings_copy.dart';
import 'tv_settings_models.dart';
import 'tv_settings_panels.dart';

/// TV Settings, Sources, and Diagnostics hi-fi shell (DSN-038).
///
/// Hierarchical categories show current values. Sources support priority
/// reordering. Diagnostics surfaces network, source, latency, buffer, version.
class TvSettingsPage extends StatefulWidget {
  const TvSettingsPage({
    super.key,
    this.initialCategory = TvSettingsCategory.playback,
    this.playbackValues = demoPlaybackValues,
    this.accountValues = demoAccountValues,
    this.sources = demoSources,
    this.diagnostics = demoDiagnostics,
  });

  final TvSettingsCategory initialCategory;
  final List<TvSettingsValue> playbackValues;
  final List<TvSettingsValue> accountValues;
  final List<TvSettingsSource> sources;
  final TvSettingsDiagnostics diagnostics;

  static const List<TvSettingsValue> demoPlaybackValues = <TvSettingsValue>[
    TvSettingsValue(label: 'Stream quality', value: 'Auto'),
    TvSettingsValue(label: 'Audio language', value: 'Original'),
    TvSettingsValue(label: 'Subtitles', value: 'Off'),
  ];

  static const List<TvSettingsValue> demoAccountValues = <TvSettingsValue>[
    TvSettingsValue(label: 'Signed in as', value: 'you@example.com'),
    TvSettingsValue(label: 'Devices linked', value: '2'),
  ];

  static const List<TvSettingsSource> demoSources = <TvSettingsSource>[
    TvSettingsSource(
      id: 'src-xtream',
      name: 'Home Xtream',
      kind: 'xtream',
      priority: 1,
    ),
    TvSettingsSource(
      id: 'src-m3u',
      name: 'M3U Playlist',
      kind: 'm3u',
      priority: 2,
    ),
    TvSettingsSource(
      id: 'src-catalog',
      name: 'Mi Catalog',
      kind: 'proprietary',
      priority: 3,
    ),
  ];

  static const TvSettingsDiagnostics demoDiagnostics = TvSettingsDiagnostics(
    network: 'Wi‑Fi · Good',
    source: 'Home Xtream',
    latency: '42 ms',
    buffer: '3.2 s',
    version: '0.1.0+mvp',
  );

  @override
  State<TvSettingsPage> createState() => _TvSettingsPageState();
}

class _TvSettingsPageState extends State<TvSettingsPage> {
  late TvSettingsCategory _category = widget.initialCategory;
  late List<TvSettingsSource> _sources = List<TvSettingsSource>.of(
    widget.sources,
  );

  void _moveUp(int index) {
    if (index <= 0) return;
    setState(() {
      final ordered = [..._sources]
        ..sort((a, b) => a.priority.compareTo(b.priority));
      final current = ordered[index];
      final above = ordered[index - 1];
      _sources = _sources
          .map((source) {
            if (source.id == current.id) {
              return source.copyWith(priority: above.priority);
            }
            if (source.id == above.id) {
              return source.copyWith(priority: current.priority);
            }
            return source;
          })
          .toList(growable: false);
    });
  }

  void _moveDown(int index) {
    setState(() {
      final ordered = [..._sources]
        ..sort((a, b) => a.priority.compareTo(b.priority));
      if (index < 0 || index >= ordered.length - 1) return;
      final current = ordered[index];
      final below = ordered[index + 1];
      _sources = _sources
          .map((source) {
            if (source.id == current.id) {
              return source.copyWith(priority: below.priority);
            }
            if (source.id == below.id) {
              return source.copyWith(priority: current.priority);
            }
            return source;
          })
          .toList(growable: false);
    });
  }

  Widget _detail() {
    switch (_category) {
      case TvSettingsCategory.playback:
        return TvSettingsValuesPanel(values: widget.playbackValues);
      case TvSettingsCategory.account:
        return TvSettingsValuesPanel(values: widget.accountValues);
      case TvSettingsCategory.sources:
        return TvSettingsSourcesPanel(
          sources: _sources,
          onMoveUp: _moveUp,
          onMoveDown: _moveDown,
        );
      case TvSettingsCategory.diagnostics:
        return TvSettingsDiagnosticsPanel(diagnostics: widget.diagnostics);
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
                    width: 320,
                    child: TvSettingsCategoryList(
                      selected: _category,
                      onSelected: (category) =>
                          setState(() => _category = category),
                    ),
                  ),
                  const SizedBox(width: AppGrid.railGap),
                  Expanded(child: SingleChildScrollView(child: _detail())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
