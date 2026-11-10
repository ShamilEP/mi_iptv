import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/focusable_surface.dart';
import '../../../../core/widgets/mi_button.dart';
import 'tv_home_personalized_models.dart';

/// Compact personalized hero band (DSN-070).
///
/// Sits **below** Brand + Live TV quick access. Constrained height so it does
/// not full-bleed displace Live TV from the first viewport.
class TvHomeHero extends StatelessWidget {
  const TvHomeHero({
    super.key,
    required this.content,
    this.onWatch,
    this.focusNode,
  });

  final TvHomeHeroContent content;
  final VoidCallback? onWatch;
  final FocusNode? focusNode;

  /// Max fraction of a 1080p stage — keeps header + Live TV visible.
  static const double maxHeightFactor = 0.22;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = (constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : 1080.0) *
            maxHeightFactor;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH.clamp(140.0, 240.0)),
          child: FocusableSurface(
            key: const ValueKey<String>('home-hero'),
            focusNode: focusNode,
            kind: FocusControlKind.card,
            fill: brand.surface,
            borderRadius: AppRadius.md,
            padding: const EdgeInsets.all(AppSpacing.lg),
            onPressed: onWatch,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: brand.panel,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: brand.border),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.movie_outlined,
                        size: AppSpacing.xxl,
                        color: brand.mist,
                        semanticLabel: content.title,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        content.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(
                          color: brand.cloud,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        content.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge?.copyWith(color: brand.mist),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        TvHomePersonalizedCopy.heroLiveTvRule,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(
                          color: brand.mist,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      MiButton(
                        key: const ValueKey<String>('home-hero-cta'),
                        label: content.ctaLabel,
                        emphasis: ControlEmphasis.primary,
                        onPressed: onWatch,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
