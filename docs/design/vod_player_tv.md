# TV VOD player controls (DSN-037)

Executable UI: [`TvVodPlayerPage`](../../lib/features/player/presentation/tv/tv_vod_player_page.dart) with [`VodPlayerControlsOverlay`](../../lib/core/widgets/vod_player_controls_overlay.dart).

## Layout

1. **Video stage** — full-bleed placeholder (no Media3 wiring in this shell).
2. **Temporary overlay** — title band, large center play/pause, bottom controls; auto-hides after [`AppMotion.playerControlsAutoHide`](../../lib/core/theme/app_motion.dart) (4 s). Any D-pad / tap re-shows chrome.
3. **Timeline** — position, Signal progress track, duration.
4. **Large controls** — seek −10 s / +10 s and volume down / mute / volume up with oversized focusable targets.
5. **Primary action** — play/pause stays in `OverlayStage.primaryAction` so the bottom band never covers it (DSN-015 rule).

## Notes

- Design shell only: seeks and volume callbacks do not drive a real player.
