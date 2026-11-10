import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import 'tv_history_models.dart';
import 'tv_history_panels.dart';

/// TV History screen design shell (DSN-063).
///
/// Full watch history with privacy controls. Explicitly separate from Home
/// Continue watching — pausing or clearing History does not change that rail.
class TvHistoryPage extends StatefulWidget {
  const TvHistoryPage({
    super.key,
    this.items = demoHistoryItems,
    this.saveHistory = true,
    this.onOpen,
    this.onRemove,
    this.onClearHistory,
    this.onSaveHistoryChanged,
    this.onBrowseCatalog,
  });

  final List<TvHistoryItem> items;
  final bool saveHistory;
  final ValueChanged<TvHistoryItem>? onOpen;
  final ValueChanged<TvHistoryItem>? onRemove;
  final VoidCallback? onClearHistory;
  final ValueChanged<bool>? onSaveHistoryChanged;
  final VoidCallback? onBrowseCatalog;

  @override
  State<TvHistoryPage> createState() => _TvHistoryPageState();
}

class _TvHistoryPageState extends State<TvHistoryPage> {
  late List<TvHistoryItem> _items = List<TvHistoryItem>.of(widget.items);
  late bool _saveHistory = widget.saveHistory;
  bool _justCleared = false;

  void _open(TvHistoryItem item) => widget.onOpen?.call(item);

  void _remove(TvHistoryItem item) {
    setState(() {
      _items = _items.where((entry) => entry.id != item.id).toList();
      _justCleared = false;
    });
    widget.onRemove?.call(item);
  }

  void _clear() {
    setState(() {
      _items = <TvHistoryItem>[];
      _justCleared = true;
    });
    widget.onClearHistory?.call();
  }

  void _setSaveHistory(bool value) {
    setState(() => _saveHistory = value);
    widget.onSaveHistoryChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

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
                TvHistoryCopy.title,
                style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                TvHistoryCopy.body,
                style: textTheme.bodyLarge?.copyWith(color: brand.mist),
              ),
              const SizedBox(height: AppSpacing.lg),
              TvHistoryPrivacyPanel(
                saveHistory: _saveHistory,
                onSaveHistoryChanged: _setSaveHistory,
                onClearHistory: _clear,
                canClear: _items.isNotEmpty,
              ),
              if (!_saveHistory) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Icon(
                      Icons.pause_circle_outline,
                      color: brand.warning,
                      size: AppSpacing.lg,
                      semanticLabel: TvHistoryCopy.pausedBanner,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        TvHistoryCopy.pausedBanner,
                        style: textTheme.bodyMedium?.copyWith(
                          color: brand.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_justCleared && _items.isEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  TvHistoryCopy.clearDoneLabel,
                  style: textTheme.labelLarge?.copyWith(color: brand.success),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: TvHistoryCatalog(
                    items: _items,
                    onOpen: _open,
                    onRemove: _remove,
                    onBrowseCatalog: widget.onBrowseCatalog,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
