import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'content_card_metrics.dart';
import 'focusable_surface.dart';

export 'content_card_metrics.dart';

/// Shared catalog content card (DSN-011).
///
/// Variants: poster, landscape, channel tile, Continue Watching (Signal bar).
class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.kind,
    required this.title,
    this.subtitle,
    this.progress,
    this.width,
    this.onPressed,
    this.artwork,
  }) : assert(
          progress == null || (progress >= 0 && progress <= 1),
          'progress must be in [0, 1]',
        );

  final ContentCardKind kind;
  final String title;
  final String? subtitle;

  /// Continue Watching playback fraction in \[0, 1\]. Ignored for other kinds.
  final double? progress;

  final double? width;
  final VoidCallback? onPressed;

  /// Optional artwork; falls back to a brand panel placeholder.
  final Widget? artwork;

  @override
  Widget build(BuildContext context) {
    final size = ContentCardMetrics.sizeOf(kind, width: width);
    final brand = context.brandColors;
    final showProgress =
        kind == ContentCardKind.continueWatching && progress != null;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: FocusableSurface(
        kind: FocusControlKind.card,
        fill: brand.surface,
        borderRadius: AppRadius.md,
        onPressed: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Stack(
            fit: StackFit.expand,
            children: [
              artwork ?? _ArtworkPlaceholder(kind: kind, title: title),
              if (kind != ContentCardKind.channelTile)
                const _BottomScrim(),
              if (kind != ContentCardKind.channelTile)
                _TitleBlock(title: title, subtitle: subtitle),
              if (kind == ContentCardKind.channelTile)
                _ChannelLabel(title: title),
              if (showProgress)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _SignalProgressBar(
                    key: const ValueKey<String>('content-card-signal-progress'),
                    value: progress!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtworkPlaceholder extends StatelessWidget {
  const _ArtworkPlaceholder({required this.kind, required this.title});

  final ContentCardKind kind;
  final String title;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final IconData icon;
    switch (kind) {
      case ContentCardKind.poster:
        icon = Icons.movie_outlined;
      case ContentCardKind.landscape:
        icon = Icons.slideshow_outlined;
      case ContentCardKind.channelTile:
        icon = Icons.live_tv_outlined;
      case ContentCardKind.continueWatching:
        icon = Icons.play_circle_outline;
    }

    return ColoredBox(
      color: brand.panel,
      child: Center(
        child: Icon(
          icon,
          size: AppSpacing.xl,
          color: brand.mist,
          semanticLabel: title,
        ),
      ),
    );
  }
}

class _BottomScrim extends StatelessWidget {
  const _BottomScrim();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.ink.withValues(alpha: 0),
              AppColors.ink.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: const SizedBox(height: AppSpacing.xxxl + AppSpacing.xs, width: double.infinity),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.insetCard),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleLarge?.copyWith(color: brand.cloud),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge?.copyWith(color: brand.mist),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChannelLabel extends StatelessWidget {
  const _ChannelLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: brand.cloud,
              ),
        ),
      ),
    );
  }
}

class _SignalProgressBar extends StatelessWidget {
  const _SignalProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final percent = (value.clamp(0.0, 1.0) * 100).round();
    return Semantics(
      label: 'Watched $percent percent',
      value: '$percent%',
      child: SizedBox(
        height: ContentCardMetrics.progressTrackHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: brand.border),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: value.clamp(0.0, 1.0),
                heightFactor: 1,
                child: const ColoredBox(color: AppColors.signal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
