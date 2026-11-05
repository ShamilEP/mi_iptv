import 'dart:ui';

/// Content card kinds from DSN-011 / SRS §13.
enum ContentCardKind {
  /// Portrait VOD / series poster (2:3).
  poster,

  /// Landscape hero / episode still (16:9).
  landscape,

  /// Live channel logo tile (1:1).
  channelTile,

  /// Continue Watching landscape with Signal progress.
  continueWatching,
}

/// Default TV sizes and aspect ratios for [ContentCardKind] (DSN-011).
abstract final class ContentCardMetrics {
  static const double posterAspect = 2 / 3;
  static const double landscapeAspect = 16 / 9;
  static const double channelTileAspect = 1;
  static const double continueWatchingAspect = landscapeAspect;

  /// Default widths at 1080p TV density.
  static const double posterWidth = 160;
  static const double landscapeWidth = 280;
  static const double channelTileWidth = 120;
  static const double continueWatchingWidth = 280;

  /// Signal progress track height on Continue Watching.
  static const double progressTrackHeight = 4;

  static double aspectOf(ContentCardKind kind) {
    switch (kind) {
      case ContentCardKind.poster:
        return posterAspect;
      case ContentCardKind.landscape:
        return landscapeAspect;
      case ContentCardKind.channelTile:
        return channelTileAspect;
      case ContentCardKind.continueWatching:
        return continueWatchingAspect;
    }
  }

  static double defaultWidthOf(ContentCardKind kind) {
    switch (kind) {
      case ContentCardKind.poster:
        return posterWidth;
      case ContentCardKind.landscape:
        return landscapeWidth;
      case ContentCardKind.channelTile:
        return channelTileWidth;
      case ContentCardKind.continueWatching:
        return continueWatchingWidth;
    }
  }

  static Size sizeOf(ContentCardKind kind, {double? width}) {
    final w = width ?? defaultWidthOf(kind);
    return Size(w, w / aspectOf(kind));
  }
}
