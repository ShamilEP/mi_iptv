import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_icon.dart';
import '../../../../core/widgets/mi_list_row.dart';
import '../../../../core/widgets/status_pattern.dart';
import 'tv_favorites_copy.dart';
import 'tv_favorites_item.dart';

/// Favorites list with Channels / VOD separation and quick actions (DSN-036).
class TvFavoritesCatalog extends StatelessWidget {
  const TvFavoritesCatalog({
    super.key,
    required this.channels,
    required this.vod,
    this.onOpen,
    this.onRemove,
    this.onBrowseCatalog,
  });

  final List<TvFavoritesItem> channels;
  final List<TvFavoritesItem> vod;
  final ValueChanged<TvFavoritesItem>? onOpen;
  final ValueChanged<TvFavoritesItem>? onRemove;
  final VoidCallback? onBrowseCatalog;

  bool get isEmpty => channels.isEmpty && vod.isEmpty;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return EmptyPattern.favorites(onAction: onBrowseCatalog);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (channels.isNotEmpty) ...[
          _Group(
            title: TvFavoritesCopy.channelsGroup,
            items: channels,
            iconRole: IconRole.channel,
            onOpen: onOpen,
            onRemove: onRemove,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (vod.isNotEmpty)
          _Group(
            title: TvFavoritesCopy.vodGroup,
            items: vod,
            iconRole: IconRole.movie,
            onOpen: onOpen,
            onRemove: onRemove,
          ),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.items,
    required this.iconRole,
    this.onOpen,
    this.onRemove,
  });

  final String title;
  final List<TvFavoritesItem> items;
  final IconRole iconRole;
  final ValueChanged<TvFavoritesItem>? onOpen;
  final ValueChanged<TvFavoritesItem>? onRemove;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final ordered = [...items]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleLarge?.copyWith(color: brand.cloud)),
        const SizedBox(height: AppSpacing.sm),
        for (final item in ordered) ...[
          MiListRow(
            key: ValueKey<String>('fav-${item.id}'),
            title: item.title,
            subtitle:
                '${item.subtitle} · ${TvFavoritesCopy.orderHintPrefix} ${item.order}',
            leading: MiIcon(
              role: iconRole,
              color: brand.cloud,
              size: AppSpacing.lg,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MiButton(
                  label: TvFavoritesCopy.openLabel,
                  emphasis: ControlEmphasis.primary,
                  onPressed: onOpen == null ? null : () => onOpen!(item),
                ),
                const SizedBox(width: AppSpacing.xs),
                MiButton(
                  label: TvFavoritesCopy.removeLabel,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: onRemove == null ? null : () => onRemove!(item),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
