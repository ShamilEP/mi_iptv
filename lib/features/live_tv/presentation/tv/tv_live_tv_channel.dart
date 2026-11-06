/// Demo channel model for Live TV hi-fi (DSN-033).
class TvLiveTvChannel {
  const TvLiveTvChannel({
    required this.number,
    required this.name,
    required this.sourceLabel,
    this.nowPlaying,
  });

  final String number;
  final String name;
  final String sourceLabel;
  final String? nowPlaying;
}
