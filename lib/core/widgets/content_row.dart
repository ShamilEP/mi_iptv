import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'content_card.dart';
import 'content_card_skeleton.dart';

/// Builds a focusable card for index `[0, itemCount)`.
///
/// Must attach [focusNode] to the returned [ContentCard] (or equivalent).
typedef ContentRowItemBuilder = Widget Function(
  BuildContext context,
  int index,
  FocusNode focusNode,
);

/// Horizontal catalog rail with title, position cue, and last-focus memory
/// (DSN-012 / SRS §12).
///
/// Spacing uses [AppGrid.gutter]. Lazy-load slots use [ContentCardSkeleton]
/// (DSN-016) so rail height stays stable.
class ContentRow extends StatefulWidget {
  const ContentRow({
    super.key,
    required this.title,
    required this.kind,
    required this.itemCount,
    required this.itemBuilder,
    this.placeholderCount = 0,
    this.showPositionCue = true,
    this.storageId,
    this.cardWidth,
  })  : assert(itemCount >= 0, 'itemCount must be >= 0'),
        assert(placeholderCount >= 0, 'placeholderCount must be >= 0');

  final String title;
  final ContentCardKind kind;
  final int itemCount;
  final ContentRowItemBuilder itemBuilder;

  /// Trailing lazy-load stubs after real items.
  final int placeholderCount;

  /// When a child is focused, show `i / n` beside the title.
  final bool showPositionCue;

  /// Stable id for [PageStorage] scroll + last-focus index. Defaults to [title].
  final String? storageId;

  final double? cardWidth;

  @override
  State<ContentRow> createState() => ContentRowState();
}

/// Public state so tests can drive focus memory without private accessors.
class ContentRowState extends State<ContentRow> {
  static const String focusStorageSuffix = '::focus';
  static const String scrollStorageSuffix = '::scroll';

  late List<FocusNode> _nodes;
  late List<VoidCallback> _listeners;
  final ScrollController _scrollController = ScrollController();

  int _lastFocusedIndex = 0;
  int? _activeIndex;
  bool _restoredStorage = false;

  Object get _storageId => widget.storageId ?? widget.title;

  int get lastFocusedIndex => _lastFocusedIndex;

  int? get activeIndex => _activeIndex;

  int get totalSlots => widget.itemCount + widget.placeholderCount;

  @override
  void initState() {
    super.initState();
    _allocateNodes(widget.itemCount);
  }

  @override
  void didUpdateWidget(covariant ContentRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount != widget.itemCount) {
      _disposeNodes();
      _allocateNodes(widget.itemCount);
      if (_lastFocusedIndex >= widget.itemCount) {
        _lastFocusedIndex =
            widget.itemCount == 0 ? 0 : widget.itemCount - 1;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_restoredStorage) return;
    _restoredStorage = true;
    final stored = PageStorage.maybeOf(context)?.readState(
      context,
      identifier: '$_storageId$focusStorageSuffix',
    );
    if (stored is int && widget.itemCount > 0) {
      _lastFocusedIndex = stored.clamp(0, widget.itemCount - 1);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _disposeNodes();
    super.dispose();
  }

  /// Restores focus to the remembered card (row re-entry).
  void restoreLastFocus() {
    if (widget.itemCount == 0) return;
    final index = _lastFocusedIndex.clamp(0, widget.itemCount - 1);
    _nodes[index].requestFocus();
  }

  void _allocateNodes(int count) {
    _nodes = List<FocusNode>.generate(
      count,
      (i) => FocusNode(debugLabel: 'ContentRow[$i]'),
      growable: false,
    );
    _listeners = List<VoidCallback>.generate(count, (i) {
      void listener() => _onNodeFocusChange(i);
      _nodes[i].addListener(listener);
      return listener;
    }, growable: false);
  }

  void _disposeNodes() {
    for (var i = 0; i < _nodes.length; i++) {
      _nodes[i].removeListener(_listeners[i]);
      _nodes[i].dispose();
    }
  }

  void _onNodeFocusChange(int index) {
    final focused = _nodes[index].hasFocus;
    if (focused) {
      setState(() {
        _lastFocusedIndex = index;
        _activeIndex = index;
      });
      PageStorage.maybeOf(context)?.writeState(
        context,
        index,
        identifier: '$_storageId$focusStorageSuffix',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _ensureVisible(index);
      });
    } else if (_activeIndex == index) {
      setState(() => _activeIndex = null);
    }
  }

  void _ensureVisible(int index) {
    final ctx = _nodes[index].context;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      duration: AppMotion.normal,
      curve: AppMotion.standard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final cardSize = ContentCardMetrics.sizeOf(
      widget.kind,
      width: widget.cardWidth,
    );
    final railHeight = cardSize.height * FocusStyles.scale +
        FocusStyles.glowSpread +
        AppSpacing.xs;

    final showCue = widget.showPositionCue &&
        _activeIndex != null &&
        widget.itemCount > 0;
    final cueText = showCue
        ? '${_activeIndex! + 1} / ${widget.itemCount}'
        : null;

    return FocusTraversalGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
                ),
              ),
              if (cueText != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  cueText,
                  key: const ValueKey<String>('content-row-position-cue'),
                  style: textTheme.labelSmall?.copyWith(color: brand.mist),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.stackTight),
          SizedBox(
            height: railHeight,
            child: totalSlots == 0
                ? const SizedBox.shrink()
                : ListView.separated(
                    key: PageStorageKey<String>(
                      '$_storageId$scrollStorageSuffix',
                    ),
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: totalSlots,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppGrid.gutter),
                    itemBuilder: (context, index) {
                      if (index >= widget.itemCount) {
                        return ContentCardSkeleton(
                          kind: widget.kind,
                          width: widget.cardWidth,
                        );
                      }
                      return widget.itemBuilder(
                        context,
                        index,
                        _nodes[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
