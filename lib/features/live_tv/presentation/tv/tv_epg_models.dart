/// One EPG programme block on the channel × time grid (DSN-060).
class TvEpgEvent {
  const TvEpgEvent({
    required this.id,
    required this.title,
    required this.startMinute,
    required this.durationMinutes,
    this.subtitle = '',
    this.isCurrent = false,
  });

  final String id;
  final String title;

  /// Minutes from the grid window start.
  final int startMinute;

  final int durationMinutes;
  final String subtitle;

  /// True when this block is the live / now-playing programme.
  final bool isCurrent;

  int get endMinute => startMinute + durationMinutes;
}

/// One channel row on the EPG grid.
class TvEpgChannel {
  const TvEpgChannel({
    required this.number,
    required this.name,
    required this.events,
  });

  final String number;
  final String name;
  final List<TvEpgEvent> events;
}

/// Locked copy for the EPG design shell (DSN-060).
abstract final class TvEpgCopy {
  static const String title = 'TV guide';
  static const String detailHeading = 'Programme';
  static const String nowLabel = 'Now';
  static const String emptyDetail =
      'Move focus onto a programme block to see details.';
  static const String windowLabel = 'Tonight';
}
