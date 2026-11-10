import 'package:flutter/foundation.dart';

/// Watched item for the History design shell (DSN-063).
@immutable
class TvHistoryItem {
  const TvHistoryItem({
    required this.id,
    required this.title,
    required this.watchedLabel,
    this.subtitle = '',
    this.progress = 0,
  }) : assert(progress >= 0 && progress <= 1, 'progress must be in [0, 1]');

  final String id;
  final String title;
  final String subtitle;

  /// Relative / clock label (e.g. "Today · 20:14") — shell copy only.
  final String watchedLabel;

  /// Playback fraction when resumed; informational on History (not CW rail).
  final double progress;
}

/// Locked copy for TV History (DSN-063).
abstract final class TvHistoryCopy {
  static const String title = 'History';
  static const String body =
      'Full watch history — separate from Continue watching on Home.';
  static const String privacySection = 'Privacy';
  static const String saveHistoryLabel = 'Save watch history';
  static const String saveHistoryHint =
      'When off, new plays are not added. Existing items stay until cleared.';
  static const String clearLabel = 'Clear history';
  static const String clearDoneLabel = 'History cleared';
  static const String openLabel = 'Open';
  static const String removeLabel = 'Remove';
  static const String emptyTitle = 'No watch history';
  static const String emptyMessage =
      'Titles you finish or pause will appear here. Continue watching stays on Home.';
  static const String emptyAction = 'Browse catalog';
  static const String pausedBanner =
      'History saving is paused. Continue watching on Home is unchanged.';
}

/// Demo history rows (newest first).
const List<TvHistoryItem> demoHistoryItems = <TvHistoryItem>[
  TvHistoryItem(
    id: 'h-1',
    title: 'Harbor Lights',
    subtitle: 'Movie',
    watchedLabel: 'Today · 21:05',
    progress: 0.82,
  ),
  TvHistoryItem(
    id: 'h-2',
    title: 'Signal News',
    subtitle: 'Live catch-up',
    watchedLabel: 'Today · 19:40',
    progress: 1,
  ),
  TvHistoryItem(
    id: 'h-3',
    title: 'Series night',
    subtitle: 'S1 E4',
    watchedLabel: 'Yesterday · 22:10',
    progress: 0.55,
  ),
];
