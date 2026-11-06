# Iconography set (DSN-019)

Executable catalog: [`Iconography`](../../lib/core/theme/iconography.dart).  
Labeled renderer: [`MiIcon`](../../lib/core/widgets/mi_icon.dart).  
Status badges reuse the same glyphs via [`StatusBadge`](../../lib/core/widgets/status_badge.dart).

## Rule

**Consistent icons** — pick glyphs from `Iconography` / `IconRole`, do not invent one-off Material icons for MVP chrome.

**Text labels when ambiguous** — if `IconographyEntry.labelRequired` is `true`, show a visible text label (not color or icon alone). Clear metaphors (play, search, settings, …) may stay icon-only but still expose `label` to semantics.

## MVP roles (summary)

| Group | Roles |
|---|---|
| Destinations | home, liveTv, search, favorites, settings, sources*, devices* |
| Playback | play, pause, seekBack, seekForward, info, favorite, retry |
| Companion | phoneCompanion* |
| Status | live*, activeSource*, synced*, connected*, weakNetwork*, empty*, error, offline*, warning*, disabled, selected |
| Content | movie, series, channel, continueWatching |

\* = `labelRequired: true`

## Prefer

```dart
MiIcon(role: IconRole.live);           // shows LIVE text
Iconography.of(IconRole.play).icon;    // glyph from catalog
```
