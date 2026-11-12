/// Hold-to-scrub step sizes for TV VOD (TV-062 / FR-014).
///
/// Longer hold → larger jumps. Base skip remains ±10 s for a tap.
abstract final class AcceleratedSeek {
  static const Duration tapStep = Duration(seconds: 10);

  /// Step applied on each accelerated tick after [holdElapsed].
  static Duration stepForHoldElapsed(Duration holdElapsed) {
    final ms = holdElapsed.inMilliseconds;
    if (ms < 1000) return tapStep;
    if (ms < 3000) return const Duration(seconds: 30);
    if (ms < 6000) return const Duration(seconds: 60);
    return const Duration(minutes: 5);
  }
}
