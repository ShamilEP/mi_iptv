# TV-050 — Implement MediaPlayerController on Media3

Depends on **PRD-003** (Media3/ExoPlayer + ClearKey/Widevine L3) and **TV-002** (app scaffold).  
Approved wiring: **Option A** — custom MethodChannel adapter + Android `androidx.media3` (no pub.dev player package).

## Goal

Provide a UI-independent playback port with a Media3/ExoPlayer implementation whose
**lifecycle is owned outside screens** (composition root + Flutter engine plugin).

## Wiring

| Concern | Authority |
|---|---|
| Domain port | [`MediaPlayerController`](../../lib/features/player/domain/repositories/media_player_controller.dart) |
| TV adapter | [`Media3PlayerAdapter`](../../lib/features/player/data/adapters/media3_player_adapter.dart) |
| Test / Companion stub | [`MemoryMediaPlayerController`](../../lib/features/player/data/adapters/memory_media_player_controller.dart) |
| Composition root | [`AppDependencies.mediaPlayer`](../../lib/app/di/app_dependencies.dart) · TV injects Media3 in [`bootstrap`](../../lib/app/bootstrap.dart) |
| Native host | [`Media3PlayerPlugin`](../../android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerPlugin.kt) + [`Media3PlayerEngine`](../../android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerEngine.kt) |
| Gradle | `androidx.media3` BOM in [`android/app/build.gradle.kts`](../../android/app/build.gradle.kts) |

## Lifecycle rules

1. Create / retain `MediaPlayerController` in `AppDependencies` (not in `StatefulWidget` state of player pages).
2. Native `ExoPlayer` is created when the plugin attaches to the Flutter engine and released on detach.
3. Screens call `play` / `pause` / `seek` / `stop` and listen to `status` only — they do not construct engines.
4. Do not log stream URIs with credentials, license keys, or DRM payloads (SEC client rules).

## DRM note (PRD-003)

MVP schemes are **ClearKey + Widevine L3**. This task lands the Media3 host and controller
adapter; license session wiring is deferred to dedicated playback/DRM follow-ups.

## Follow-up

Stream formats (HLS / DASH / progressive), sniffing, headers, and redirects: [tv-051-stream-formats.md](./tv-051-stream-formats.md).

## Validation

- `test/features/player/data/media3_player_adapter_test.dart`
- `test/features/player/data/memory_media_player_controller_test.dart`
- `test/docs/tv_050_media3_player_doc_test.dart`
