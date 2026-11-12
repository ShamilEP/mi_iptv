# TV-062 — Build the VOD player UI

Depends on **DSN-037** (VOD controls design) and **TV-050** (Media3 controller).  
Refs: **FR-014**; Frontend §2.3.

## Goal

Ship the Android TV VOD player chrome: timeline, play/pause, ±10 s seek,
**accelerated hold-seek**, volume/mute, **exit**, and a temporary large-control overlay.

## Wiring

| Concern | Authority |
|---|---|
| Screen | [`TvVodPlayerPage`](../../lib/features/player/presentation/tv/tv_vod_player_page.dart) |
| Overlay | [`VodPlayerControlsOverlay`](../../lib/core/widgets/vod_player_controls_overlay.dart) |
| Transport state | [`VodTransportSession`](../../lib/features/player/presentation/tv/vod_transport_session.dart) |
| Accelerated seek steps | [`AcceleratedSeek`](../../lib/features/player/domain/services/accelerated_seek.dart) |
| Clock labels | [`formatVodClock`](../../lib/features/player/presentation/tv/vod_playback_clock.dart) |
| Media3 | Optional `mediaPlayer` / `playbackRequest` (from [`AppDependencies`](../../lib/app/di/app_dependencies.dart) via navigator) |

## Behavior (DoD)

1. **Timeline** — position / Signal progress / duration from transport session.
2. **Play/pause** — center primary action + media play/pause key.
3. **±10 s** — large seek buttons (`AcceleratedSeek.tapStep`).
4. **Accelerated seek** — hold Left/Right: tick every 350 ms with steps 10s → 30s → 60s → 5m.
5. **Volume/mute** — local level + mute chrome (system volume plugin deferred).
6. **Exit** — Back / Escape closes track picker first, else `Navigator.maybePop` + `onExit`.
7. **Temporary overlay** — auto-hide after `AppMotion.playerControlsAutoHide`; D-pad re-shows.

## Validation

- `test/features/player/domain/accelerated_seek_test.dart`
- `test/features/player/presentation/tv/vod_transport_session_test.dart`
- `test/features/player/presentation/tv/tv_vod_player_page_test.dart`
- `test/docs/tv_062_vod_player_ui_doc_test.dart`
