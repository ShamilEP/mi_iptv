# TV Live TV (DSN-033)

Executable UI: [`TvLiveTvPage`](../../lib/features/live_tv/presentation/tv/tv_live_tv_page.dart).

## Layout

1. **Video dominant** — full-bleed stage (player placeholder until Media3 adapter).
2. **Channel list / selector** — left rail (`TvLiveTvChannelList` / `MiListRow`); zap with ↑/↓.
3. **Info overlay** — [`ChannelInfoOverlay`](../../lib/core/widgets/channel_info_overlay.dart): number, name, logo, source, optional now-playing; auto-hides (DSN-015).
4. **Status indicators** — `StatusBadge.live` + `StatusBadge.activeSource` (source name) (DSN-018).

## Notes

- Select / Enter toggles the channel list without covering the video center permanently.
- No real stream playback in this Design shell.
