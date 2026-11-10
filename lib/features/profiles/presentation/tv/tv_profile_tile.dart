import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/focusable_surface.dart';
import 'tv_profile_models.dart';

/// Focusable avatar tile for the profile picker (DSN-061).
///
/// Kid profiles always show a non-color cue: [TvProfileCopy.kidsBadge] plus
/// a child icon — never hue alone.
class TvProfileTile extends StatelessWidget {
  const TvProfileTile({
    super.key,
    required this.profile,
    required this.onPressed,
    this.managing = false,
    this.focusNode,
  });

  final TvProfile profile;
  final VoidCallback onPressed;
  final bool managing;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final avatarFill = profile.isKid ? brand.warning.withValues(alpha: 0.22) : brand.surface;
    final avatarBorder = profile.isKid ? brand.warning : brand.border;

    return SizedBox(
      width: 160,
      child: FocusableSurface(
        key: ValueKey<String>('profile-tile-${profile.id}'),
        focusNode: focusNode,
        kind: FocusControlKind.card,
        fill: brand.panel,
        borderRadius: AppRadius.md,
        padding: const EdgeInsets.all(AppSpacing.md),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: avatarFill,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: avatarBorder, width: 2),
              ),
              child: Text(
                profile.initials,
                style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(color: brand.cloud),
            ),
            if (profile.isKid) ...[
              const SizedBox(height: AppSpacing.xxs),
              _KidsBadge(brand: brand, textTheme: textTheme),
            ] else if (managing) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                TvProfileCopy.editTitle,
                style: textTheme.labelMedium?.copyWith(color: brand.mist),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// “Add profile” tile for create entry.
class TvAddProfileTile extends StatelessWidget {
  const TvAddProfileTile({
    super.key,
    required this.onPressed,
    this.focusNode,
  });

  final VoidCallback onPressed;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 160,
      child: FocusableSurface(
        key: const ValueKey<String>('profile-tile-add'),
        focusNode: focusNode,
        kind: FocusControlKind.card,
        fill: brand.panel,
        borderRadius: AppRadius.md,
        padding: const EdgeInsets.all(AppSpacing.md),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: brand.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: brand.border, width: 2),
              ),
              child: Icon(
                Icons.add,
                size: AppSpacing.xxl,
                color: brand.primary,
                semanticLabel: TvProfileCopy.addLabel,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              TvProfileCopy.addLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(color: brand.cloud),
            ),
          ],
        ),
      ),
    );
  }
}

class _KidsBadge extends StatelessWidget {
  const _KidsBadge({required this.brand, required this.textTheme});

  final MiBrandColors brand;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: TvProfileCopy.kidsBadge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.child_care,
            size: AppSpacing.md,
            color: brand.warning,
            semanticLabel: TvProfileCopy.kidsBadge,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            TvProfileCopy.kidsBadge,
            style: textTheme.labelMedium?.copyWith(color: brand.warning),
          ),
        ],
      ),
    );
  }
}
