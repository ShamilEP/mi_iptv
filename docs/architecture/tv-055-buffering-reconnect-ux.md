# TV-055 — Buffering and reconnect UX

Depends on **DSN-016** (loading spinner pattern) and **TV-054** (retry coordinator).  
Refs: **FR-016** / US-16 (simple status, no technical jargon).

## Goal

Show a **spinner** plus plain **Loading…** / **Reconnecting…** feedback while the
engine buffers or auto-retry is in flight — never raw Media3 codes or bitrate jargon.

## Wiring

| Concern | Authority |
|---|---|
| Feedback resolve | [`resolvePlaybackStatusFeedback`](../../lib/features/player/domain/entities/playback_status_feedback.dart) |
| Plain copy | [`PlaybackStatusFeedbackCopy`](../../lib/features/player/domain/entities/playback_status_feedback.dart) |
| Overlay | [`BufferingReconnectOverlay`](../../lib/core/widgets/buffering_reconnect_overlay.dart) (label-only; no feature imports) |
| Retry signal | [`PlaybackRetryCoordinator.isRetrying`](../../lib/features/player/domain/services/playback_retry_coordinator.dart) / `retrying` stream |
| Live shell | [`TvLiveTvPage.statusFeedback`](../../lib/features/live_tv/presentation/tv/tv_live_tv_page.dart) |
| VOD shell | [`TvVodPlayerPage`](../../lib/features/player/presentation/tv/tv_vod_player_page.dart) (`phase` + `isReconnecting`) |

## Behavior (DoD)

1. **Buffering** — `MediaPlayerPhase.buffering` → spinner + `Loading…`.
2. **Reconnecting** — `isReconnecting` / retry-in-flight → spinner + `Reconnecting…` (wins over buffering).
3. **No jargon** — overlay never displays `ERROR_CODE_*`, hosts with credentials, or ABR metrics.
4. **Failure UI wins** — Live `streamFailed` recovery overlay hides the spinner.

## Validation

- `test/features/player/domain/playback_status_feedback_test.dart`
- `test/core/widgets/buffering_reconnect_overlay_test.dart`
- `test/features/live_tv/presentation/tv/tv_live_tv_page_test.dart` (reconnect overlay)
- `test/docs/tv_055_buffering_reconnect_ux_doc_test.dart`
