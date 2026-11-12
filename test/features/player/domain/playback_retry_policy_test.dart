import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_error.dart';
import 'package:mi_iptv/features/player/domain/services/playback_retry_policy.dart';

void main() {
  const policy = PlaybackRetryPolicy(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 500),
    multiplier: 2,
    maxDelay: Duration(seconds: 8),
  );

  PlaybackError error({required bool retryable}) {
    return PlaybackError(
      kind: retryable ? PlaybackErrorKind.network : PlaybackErrorKind.decoder,
      code: 'TEST',
      userMessage: 'msg',
      retryable: retryable,
    );
  }

  test('caps retries and refuses non-retryable errors', () {
    expect(
      policy.canRetry(failedAttempts: 1, error: error(retryable: true)),
      isTrue,
    );
    expect(
      policy.canRetry(failedAttempts: 3, error: error(retryable: true)),
      isTrue,
    );
    expect(
      policy.canRetry(failedAttempts: 4, error: error(retryable: true)),
      isFalse,
    );
    expect(
      policy.canRetry(failedAttempts: 1, error: error(retryable: false)),
      isFalse,
    );
  });

  test('exponential backoff clamps to maxDelay', () {
    expect(policy.delayBeforeRetry(1), const Duration(milliseconds: 500));
    expect(policy.delayBeforeRetry(2), const Duration(seconds: 1));
    expect(policy.delayBeforeRetry(3), const Duration(seconds: 2));
    expect(policy.delayBeforeRetry(10), const Duration(seconds: 8));
  });
}
