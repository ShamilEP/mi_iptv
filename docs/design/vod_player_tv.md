# TV VOD player controls (DSN-037 / TV-062)

Executable UI: [`TvVodPlayerPage`](../../lib/features/player/presentation/tv/tv_vod_player_page.dart) with [`VodPlayerControlsOverlay`](../../lib/core/widgets/vod_player_controls_overlay.dart).  
Architecture: [tv-062-vod-player-ui.md](../architecture/tv-062-vod-player-ui.md).

## Layout

1. **Video stage** — full-bleed stage (Media3 surface wiring can attach later; transport uses [`MediaPlayerController`](../../lib/features/player/domain/repositories/media_player_controller.dart) when provided).
2. **Temporary overlay** — title band, large center play/pause, bottom controls; auto-hides after [`AppMotion.playerControlsAutoHide`](../../lib/core/theme/app_motion.dart) (4 s). Any D-pad / tap re-shows chrome.
3. **Timeline** — position, Signal progress track, duration.
4. **Large controls** — seek −10 s / +10 s and volume down / mute / volume up with oversized focusable targets.
5. **Primary action** — play/pause stays in `OverlayStage.primaryAction` so the bottom band never covers it (DSN-015 rule).
6. **Accelerated seek** — hold Left/Right while chrome is visible.
7. **Exit** — Back leaves the player (FR-014).

## Captions (DSN-021)

Optional lower-third [`MiSubtitleCaption`](../../lib/core/widgets/mi_subtitle_caption.dart) uses locked Cloud-on-Ink-scrim defaults. See [subtitle_style.md](./subtitle_style.md).
