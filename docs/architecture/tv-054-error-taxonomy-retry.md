# TV-054 — Error taxonomy and retry policy

Depends on **TV-050** (Media3 controller).  
Refs: **NFR-QOE-05**, **FR-016** (simple status, reconnect when possible).

## Goal

Classify playback failures as **network**, **source**, or **decoder**, then apply a
**capped exponential backoff** retry policy that preserves playback context and
**never loops forever**.

## Wiring

| Concern | Authority |
|---|---|
| Taxonomy | [`PlaybackError`](../../lib/features/player/domain/entities/playback_error.dart) / [`PlaybackErrorKind`](../../lib/features/player/domain/entities/playback_error.dart) |
| Classifier | [`PlaybackErrorClassifier`](../../lib/features/player/domain/services/playback_error_classifier.dart) — maps Media3 `errorCodeName` → kind + user copy |
| Retry policy | [`PlaybackRetryPolicy`](../../lib/features/player/domain/services/playback_retry_policy.dart) — `maxAttempts=3`, `500ms` ×2 up to `8s` |
| Coordinator | [`PlaybackRetryCoordinator`](../../lib/features/player/domain/services/playback_retry_coordinator.dart) — owns auto-retry; mounted on [`AppDependencies.playbackRetry`](../../lib/app/di/app_dependencies.dart) |
| Native signal | Media3 `PlaybackException.errorCodeName` via status `message` (no credentials) |

## Classification (viewer copy)

| Kind | Retryable | User message |
|---|---|---|
| network | yes | Connection lost. Reconnecting… |
| source | yes | This stream isn't available right now. |
| decoder | **no** | This device couldn't play this stream. |
| unknown | yes | Playback failed. Retrying… |

Raw Media3 codes stay machine-side; UI should prefer [PlaybackError.userMessage] (FR-016).

## Retry rules

1. Count failures after the initial `play` (attempt 0).
2. Retry only while `failedAttempts <= maxAttempts` **and** `error.retryable`.
3. Delay = exponential from `initialDelay` with `multiplier`, capped by `maxDelay`.
4. Preserve [`PlaybackRequest`](../../lib/features/player/domain/entities/playback_request.dart) + last `position` (seek after re-`play` when position &gt; 0).
5. Successful `playing` / `paused` resets the failure counter.
6. Exhausted / non-retryable errors emit on `PlaybackRetryCoordinator.errors`.

## Validation

- `test/features/player/domain/playback_error_classifier_test.dart`
- `test/features/player/domain/playback_retry_policy_test.dart`
- `test/features/player/domain/playback_retry_coordinator_test.dart`
- `test/docs/tv_054_error_taxonomy_retry_doc_test.dart`
