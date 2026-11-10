# TV EPG grid (DSN-060)

Executable UI: [`TvEpgGridPage`](../../lib/features/live_tv/presentation/tv/tv_epg_grid_page.dart) on `AppTheme.tvDark()`.

**Phase:** Release 1 design shell (not MVP ship scope).

## Layout

1. **Brand lockup** + **TV guide** title.
2. **Time axis** — marks across the evening window (e.g. 20:00 → 22:30).
3. **Channel × time grid** — each row is a channel; programme blocks sized by duration.
4. **Current event** — Signal fill plus a visible **Now** label (not hue alone).
5. **Event detail** — strip under the grid for the focused / selected programme.

## Navigation

- D-pad moves **block to block** (each programme is a `FocusableSurface`).
- Focus nodes are retained so the last programme stays focusable after rebuilds (**persistent focus**).
- Initial focus prefers the first **Now** programme.

## Notes

- Design shell only: no EPG / schedule API.
- `TvAccessibleScope` wraps the page (TV-123).
