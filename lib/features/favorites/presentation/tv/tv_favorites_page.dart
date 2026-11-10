import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import 'tv_favorites_copy.dart';
import 'tv_favorites_item.dart';
import 'tv_favorites_panels.dart';

/// TV Favorites hi-fi shell (DSN-036).
///
/// Channels and VOD stay in separate groups with a stable [TvFavoritesItem.order].
/// Each row exposes Open and Remove quick actions.
class TvFavoritesPage extends StatefulWidget {
  const TvFavoritesPage({
    super.key,
    this.items = demoItems,
    this.onOpen,
    this.onRemove,
    this.onBrowseCatalog,
  });

  final List<TvFavoritesItem> items;
  final ValueChanged<TvFavoritesItem>? onOpen;
  final ValueChanged<TvFavoritesItem>? onRemove;
  final VoidCallback? onBrowseCatalog;

  static const List<TvFavoritesItem> demoItems = <TvFavoritesItem>[
    TvFavoritesItem(
      id: 'ch-12',
      title: '12 Signal News',
      subtitle: 'Live',
      kind: TvFavoritesKind.channel,
      order: 1,
    ),
    TvFavoritesItem(
      id: 'ch-24',
      title: '24 Ember Sports',
      subtitle: 'Live',
      kind: TvFavoritesKind.channel,
      order: 2,
    ),
    TvFavoritesItem(
      id: 'vod-1',
      title: 'Harbor Lights',
      subtitle: 'Movie',
      kind: TvFavoritesKind.vod,
      order: 1,
    ),
    TvFavoritesItem(
      id: 'vod-2',
      title: 'Night Run',
      subtitle: 'Movie',
      kind: TvFavoritesKind.vod,
      order: 2,
    ),
  ];

  @override
  State<TvFavoritesPage> createState() => _TvFavoritesPageState();
}

class _TvFavoritesPageState extends State<TvFavoritesPage> {
  late List<TvFavoritesItem> _items = List<TvFavoritesItem>.of(widget.items);

  List<TvFavoritesItem> get _channels => _items
      .where((item) => item.kind == TvFavoritesKind.channel)
      .toList(growable: false);

  List<TvFavoritesItem> get _vod => _items
      .where((item) => item.kind == TvFavoritesKind.vod)
      .toList(growable: false);

  void _open(TvFavoritesItem item) {
    widget.onOpen?.call(item);
  }

  void _remove(TvFavoritesItem item) {
    setState(() {
      _items = _items.where((entry) => entry.id != item.id).toList(growable: false);
    });
    widget.onRemove?.call(item);
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
                TvFavoritesCopy.title,
                style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                TvFavoritesCopy.body,
                style: textTheme.bodyLarge?.copyWith(color: brand.mist),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: TvFavoritesCatalog(
                    channels: _channels,
                    vod: _vod,
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
