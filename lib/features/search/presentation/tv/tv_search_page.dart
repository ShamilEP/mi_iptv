import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/tv_on_screen_keyboard.dart';
import 'tv_search_copy.dart';
import 'tv_search_result.dart';
import 'tv_search_results.dart';

/// TV Search hi-fi shell (DSN-035).
///
/// Large query field with TV OSK, results grouped by Channels and VOD, and
/// focusable result cards.
class TvSearchPage extends StatefulWidget {
  const TvSearchPage({
    super.key,
    this.catalog = demoCatalog,
    this.initialQuery = '',
    this.onResultSelected,
  });

  final List<TvSearchResult> catalog;
  final String initialQuery;
  final ValueChanged<TvSearchResult>? onResultSelected;

  static const List<TvSearchResult> demoCatalog = <TvSearchResult>[
    TvSearchResult(
      id: 'ch-12',
      title: 'Signal News',
      subtitle: '12',
      kind: TvSearchResultKind.channel,
    ),
    TvSearchResult(
      id: 'ch-24',
      title: 'Ember Sports',
      subtitle: '24',
      kind: TvSearchResultKind.channel,
    ),
    TvSearchResult(
      id: 'vod-1',
      title: 'Harbor Lights',
      subtitle: 'Movie',
      kind: TvSearchResultKind.vod,
    ),
    TvSearchResult(
      id: 'vod-2',
      title: 'Night Run',
      subtitle: 'Movie',
      kind: TvSearchResultKind.vod,
    ),
    TvSearchResult(
      id: 'vod-3',
      title: 'Cloud Series',
      subtitle: 'Series',
      kind: TvSearchResultKind.vod,
    ),
  ];

  @override
  State<TvSearchPage> createState() => _TvSearchPageState();
}

class _TvSearchPageState extends State<TvSearchPage> {
  late final TextEditingController _query = TextEditingController(
    text: widget.initialQuery,
  );

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<TvSearchResult> get _matches {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return widget.catalog;
    return widget.catalog
        .where(
          (item) =>
              item.title.toLowerCase().contains(q) ||
              item.subtitle.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  void _clear() {
    _query.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final matches = _matches;
    final channels = matches
        .where((item) => item.kind == TvSearchResultKind.channel)
        .toList(growable: false);
    final vod = matches
        .where((item) => item.kind == TvSearchResultKind.vod)
        .toList(growable: false);
    final queryText = _query.text.trim().isEmpty
        ? TvSearchCopy.fieldHint
        : _query.text.trim();

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
              TvSearchCopy.title,
              style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              queryText,
              key: const ValueKey<String>('search-large-query'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.displayLarge?.copyWith(color: brand.cloud),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: TvOnScreenKeyboard(
                        controller: _query,
                        fieldLabel: TvSearchCopy.fieldLabel,
                        hint: TvSearchCopy.fieldHint,
                        showTypeFromPhoneHint: true,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppGrid.railGap),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: TvSearchResults(
                        channels: channels,
                        vod: vod,
                        onClear: _clear,
                        onSelected: widget.onResultSelected,
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
