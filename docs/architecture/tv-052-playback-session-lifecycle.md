# TV-052 — Playback session lifecycle

**Refs:** SRS §3 · Depends on **TV-050**  
**Related:** [tv-050-media3-player.md](./tv-050-media3-player.md), [tv-054-error-taxonomy-retry.md](./tv-054-error-taxonomy-retry.md)

## Goal

Keep TV playback resilient to **audio focus**, **screensaver / sleep**, **app
background/foreground**, and **HDMI disconnect** — owned outside player screens.

## Behavior

| Signal | Action |
|---|---|
| Player playing / buffering | `requestAudioFocus` + `FLAG_KEEP_SCREEN_ON` |
| Player paused / stopped / idle / ended / error | Abandon focus + clear keep-screen-on |
| Audio focus lost | Pause playback |
| App backgrounded (inactive / paused / hidden) | Pause playback |
| HDMI audio unplugged | Pause playback |
| Focus / HDMI / foreground regained | **No auto-resume** (user / UI restarts) |

## Layout

| Piece | Location |
|---|---|
| Signals | [`PlaybackSessionSignal`](../../lib/features/player/domain/entities/playback_session_signal.dart) |
| Host port | [`PlaybackSessionHost`](../../lib/features/player/domain/repositories/playback_session_host.dart) |
| Coordinator | [`PlaybackSessionCoordinator`](../../lib/features/player/domain/services/playback_session_coordinator.dart) |
| Android adapter | [`AndroidPlaybackSessionHost`](../../lib/features/player/data/adapters/android_playback_session_host.dart) |
| Native plugin | [`PlaybackSessionPlugin`](../../android/app/src/main/kotlin/com/example/mi_iptv/player/PlaybackSessionPlugin.kt) |
| App lifecycle | [`PlaybackSessionLifecycleBinder`](../../lib/features/player/presentation/playback_session_lifecycle_binder.dart) |
| DI | [`AppDependencies.playbackSession`](../../lib/app/di/app_dependencies.dart) |

## Packages

No new pubspec dependency. Native `AudioManager` + window flags + HDMI plug broadcast.

## Security

No stream URIs, credentials, or DRM payloads in session channel payloads — signal names only.
