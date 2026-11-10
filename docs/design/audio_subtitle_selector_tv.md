# TV audio & subtitle track selector (DSN-064)

Executable UI: [`TvTrackSelectorPanel`](../../lib/features/player/presentation/tv/tv_track_selector_panel.dart) hosted by [`TvVodPlayerPage`](../../lib/features/player/presentation/tv/tv_vod_player_page.dart).

**Phase:** Release 1 design shell (depends on DSN-037 player chrome).

## Layout

1. **Transport affordance** — closed-caption control on the VOD bottom overlay opens the picker.
2. **Right-side overlay** — **Audio & subtitles** with Audio and Subtitles sections.
3. **Selected cue** — checkmark + selected list state (not hue alone).
4. **Remembered preference** — chosen track IDs stay selected when the picker is closed and reopened (session memory in the shell).

## Caption coupling

- Subtitle **Off** hides [`MiSubtitleCaption`](../../lib/core/widgets/mi_subtitle_caption.dart).
- Any language track restores the demo caption (style still DSN-021).

## Notes

- Design shell only: no Media3 track enumeration or durable prefs storage.
- Auto-hide of transport chrome pauses while the picker is open.
