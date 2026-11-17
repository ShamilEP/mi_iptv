import 'package:flutter/material.dart';

import '../../../../core/platform/companion_platform.dart';
import '../../../../core/platform/companion_platform_shell.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_text_field.dart';
import '../../../../core/widgets/status_pattern.dart';
import '../../../../core/widgets/status_pattern_copy.dart';
import '../shared/search_hit.dart';
import '../shared/tolerant_search.dart';
import 'companion_search_copy.dart';

/// Companion Search design shell (CMP-041).
///
/// System touch keyboard, local tolerant matching, results grouped by Channels
/// and VOD. No search API (`BE-052` deferred).
class CompanionSearchPage extends StatefulWidget {
  const CompanionSearchPage({
    super.key,
    this.catalog = demoCatalog,
    this.initialQuery = '',
    this.platform = CompanionPlatform.android,
    this.onBack,
    this.onResultSelected,
  });

  final List<SearchHit> catalog;
  final String initialQuery;
  final CompanionPlatform platform;
  final VoidCallback? onBack;
  final ValueChanged<SearchHit>? onResultSelected;

  static const List<SearchHit> demoCatalog = <SearchHit>[
    SearchHit(
      id: 'ch-12',
      title: 'Signal News',
      subtitle: '12',
      kind: SearchHitKind.channel,
    ),
    SearchHit(
      id: 'ch-24',
      title: 'Ember Sports',
      subtitle: '24',
      kind: SearchHitKind.channel,
    ),
    SearchHit(
      id: 'vod-1',
      title: 'Harbor Lights',
      subtitle: 'Movie',
      kind: SearchHitKind.vod,
    ),
    SearchHit(
      id: 'vod-2',
      title: 'Night Run',
      subtitle: 'Movie',
      kind: SearchHitKind.vod,
    ),
    SearchHit(
      id: 'vod-3',
      title: 'Cloud Series',
      subtitle: 'Series',
      kind: SearchHitKind.vod,
    ),
  ];

  @override
  State<CompanionSearchPage> createState() => _CompanionSearchPageState();
}

class _CompanionSearchPageState extends State<CompanionSearchPage> {
  late final TextEditingController _query = TextEditingController(
    text: widget.initialQuery,
  );

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  TolerantSearchOutcome get _outcome =>
      TolerantSearch.query(_query.text, widget.catalog);

  void _onChanged(String raw) {
    final sanitized = MiTextField.sanitize(raw);
    if (sanitized != _query.text) {
      _query.value = TextEditingValue(
        text: sanitized,
        selection: TextSelection.collapsed(offset: sanitized.length),
      );
    }
    setState(() {});
  }

  void _clear() {
    _query.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final outcome = _outcome;
    final channels = outcome.matches
        .where((item) => item.kind == SearchHitKind.channel)
        .toList(growable: false);
    final vod = outcome.matches
        .where((item) => item.kind == SearchHitKind.vod)
        .toList(growable: false);
    final empty = channels.isEmpty && vod.isEmpty;

    return CompanionPlatformShell(
      platform: widget.platform,
      onBack: widget.onBack,
      child: Scaffold(
        backgroundColor: brand.cloud,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.insetPageCompanion),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLockup(
                  markHeight: AppSpacing.xl,
                  tone: BrandMarkTone.companion,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  CompanionSearchCopy.title,
                  style: textTheme.headlineMedium?.copyWith(color: brand.ink),
                ),
                const SizedBox(height: AppSpacing.md),
                MiTextField(
                  key: const ValueKey<String>('companion-search-field'),
                  controller: _query,
                  label: CompanionSearchCopy.fieldLabel,
                  hint: CompanionSearchCopy.fieldHint,
                  keyboardType: TextInputType.text,
                  onChanged: _onChanged,
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: empty
                      ? EmptyPattern(
                          copy: const StatusPatternCopy(
                            title: CompanionSearchCopy.emptyTitle,
                            message: CompanionSearchCopy.emptyMessage,
                            actionLabel: CompanionSearchCopy.emptyAction,
                          ),
                          onAction: _clear,
                        )
                      : ListView(
                          children: [
                            if (channels.isNotEmpty) ...[
                              _GroupHeader(
                                title: CompanionSearchCopy.channelsGroup,
                              ),
                              ...channels.map(
                                (item) => _ResultTile(
                                  item: item,
                                  onTap: () =>
                                      widget.onResultSelected?.call(item),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                            if (vod.isNotEmpty) ...[
                              _GroupHeader(title: CompanionSearchCopy.vodGroup),
                              ...vod.map(
                                (item) => _ResultTile(
                                  item: item,
                                  onTap: () =>
                                      widget.onResultSelected?.call(item),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                if (_query.text.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  MiButton(
                    key: const ValueKey<String>('companion-search-clear'),
                    label: CompanionSearchCopy.emptyAction,
                    emphasis: ControlEmphasis.secondary,
                    onPressed: _clear,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: brand.ink,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.item, this.onTap});

  final SearchHit item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return ListTile(
      key: ValueKey<String>('companion-search-${item.id}'),
      contentPadding: EdgeInsets.zero,
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: brand.ink,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: brand.muted,
        ),
      ),
      onTap: onTap,
    );
  }
}
