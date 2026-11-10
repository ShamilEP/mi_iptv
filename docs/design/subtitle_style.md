# TV subtitle style and accessible text sizing (DSN-021)

**Refs:** NFR-007 · Depends on DSN-002 contrast  
**Executable UI:** [`MiSubtitleCaption`](../../lib/core/widgets/mi_subtitle_caption.dart) · demo on [`TvVodPlayerPage`](../../lib/features/player/presentation/tv/tv_vod_player_page.dart)

## Defaults

| Token | Value |
|---|---|
| Standard size | 32 sp / 40 lh ([`AppSubtitleStyle.standardFontSize`](../../lib/core/theme/app_subtitle_style.dart)) |
| Large (accessible) | 40 sp / 48 lh |
| Foreground | Cloud `#F0EEE9` |
| Background | Ink `#0A0D14` @ 72% opacity, `AppRadius.sm` |
| Typeface | Figtree / body family, weight 600 |

Contrast is audited as Cloud on solid Ink (large text AA). Track selection UI is **DSN-064** — see [audio_subtitle_selector_tv.md](./audio_subtitle_selector_tv.md).

## OS text-size handling

TV scaffolds that show captions wrap with [`TvAccessibleScope`](../../lib/core/accessibility/tv_accessibility.dart):

- Honor system font scale from **1.0× to 1.5×** (tighter than Companion’s 2.0×).
- Captions scale through Flutter `TextScaler` inside that clamp.

## Placement

Lower-third, above the VOD transport band when controls are present. Captions stay visible even when transport chrome auto-hides (shell demo).
