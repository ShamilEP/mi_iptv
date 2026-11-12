import '../entities/playback_error.dart';

/// Capped exponential backoff for playback reconnect (TV-054 / NFR-QOE-05).
///
/// Guarantees **no infinite loops**: [maxAttempts] is a hard ceiling on
/// automatic retries after the initial [play] (attempt 0).
final class PlaybackRetryPolicy {
  const PlaybackRetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.multiplier = 2.0,
    this.maxDelay = const Duration(seconds: 8),
  })  : assert(maxAttempts >= 0, 'maxAttempts must be >= 0'),
        assert(multiplier >= 1.0, 'multiplier must be >= 1');

  static const PlaybackRetryPolicy defaults = PlaybackRetryPolicy();

  /// Automatic retries after the first failure (not counting the original play).
  final int maxAttempts;

  final Duration initialDelay;
  final double multiplier;
  final Duration maxDelay;

  /// Whether another automatic attempt is allowed after [failedAttempts] failures.
  bool canRetry({
    required int failedAttempts,
    required PlaybackError error,
  }) {
    if (!error.retryable) return false;
    if (failedAttempts < 1) return false;
    return failedAttempts <= maxAttempts;
  }

  /// Backoff before retry number [failedAttempts] (1 → initial, then exponential).
  Duration delayBeforeRetry(int failedAttempts) {
    if (failedAttempts <= 1) return initialDelay;
    var ms = initialDelay.inMilliseconds.toDouble();
    for (var i = 1; i < failedAttempts; i++) {
      ms *= multiplier;
      if (ms >= maxDelay.inMilliseconds) {
        return maxDelay;
      }
    }
    final clamped = ms.round().clamp(0, maxDelay.inMilliseconds);
    return Duration(milliseconds: clamped);
  }
}
