# Live playback soak (QA-042)

**Refs:** NFR-003 · Depends on **QA-002** (device matrix)  
**Executable suite:** [`test/qa/live_playback_soak_test.dart`](../../test/qa/live_playback_soak_test.dart)  
**Harness:** [`test/qa/live_playback_soak_harness.dart`](../../test/qa/live_playback_soak_harness.dart)  
**Related:** [android_tv_device_matrix.md](./android_tv_device_matrix.md), image budgets [tv-012-image-pipeline.md](../architecture/tv-012-image-pipeline.md), session lifecycle TV-052 / retry TV-054

## Goal

Detect **leaks and stability issues** under continuous live playback: session resource holds, zap/reconnect churn, and image-cache pressure on the low-memory stick tier (NFR-003).

## Coverage

| Concern | Automated (accelerated) | Lab (24 h wall-clock) |
|---|---|---|
| Session hold | `PlaybackSessionCoordinator` stays holding audio focus + keep-screen-on across many live ticks; releases on dispose | Confirm no thermal / wake-lock stuck after overnight live |
| Channel zap | Hundreds of play→stop→play cycles leave host resources released and controllers disposable | Zap across ≥ 3 live channels every few hours |
| Interrupt / reconnect | Background + HDMI-loss pauses without auto-resume; retry policy stays capped (`maxAttempts`) | OEM audio-focus / HDMI unplug during overnight soak |
| Image cache | `tvLowMemory` ceilings; repeated fill + `releaseOffscreenImages` never grow past budget | Stick-class (tier **L**) overnight with catalog art |

## Accelerated suite

CI / local `flutter test` runs an **accelerated soak** (`LivePlaybackSoak.acceleratedCycles`) that exercises the same leak classes without a 24-hour wait. It uses `MemoryMediaPlayerController` + `MemoryPlaybackSessionHost` + `MemoryImageCacheController` — no real network, credentials, or device farm.

Mapping: each accelerated cycle ≈ one simulated minute of continuous live hold (zap / interrupt subsets documented in the harness).

## Lab procedure (24 hours)

1. Device: QA-002 tier **L** (≤ 2 GB) or **M** stick/TV on API 34+; install TV `dev`/`staging` build over HTTPS staging only.
2. Tune a stable live HLS/DASH channel (test account — **never** commit stream credentials).
3. Leave Live TV playing for **24 hours**; log start/end UTC, build SHA, device model/RAM.
4. During soak: ≥ 3 intentional zaps; ≥ 1 app-background and restore (must **not** auto-resume); optional HDMI unplug if available.
5. Pass: no crash/ANR, no sustained memory climb past OEM comfort (compare start vs end RSS if available), playback recoverable after zap/interrupt, image cache not pinned after leaving Live.
6. Fail: process kill / freeze, unbounded memory growth, wake-lock stuck after exit Live, secrets in Logcat.

Record results in the defect tracker ([defect_tracking.md](./defect_tracking.md)); scrub any URLs that embed tokens.

## Notes

- Automated suite gates client leak hygiene; the wall-clock soak remains the physical NFR-003 confirmation on lab hardware.
- Out of MVP: Companion video soak (no Companion playback), EPG-grid overnight, DRM license thrash beyond ClearKey smoke.
