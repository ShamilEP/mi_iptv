# TV accessibility pass (TV-123)

**Refs:** NFR-007 · Depends on DSN-002 contrast tokens  
**Scope:** Flutter Android TV / Google TV surfaces in this repo (Home, Live TV, Search, Settings, Favorites, onboarding, VOD player)  
**Executable checks:** [`TvAccessibility`](../../lib/core/accessibility/tv_accessibility.dart) + [`tv_accessibility_pass_test.dart`](../../test/core/accessibility/tv_accessibility_pass_test.dart)

## Text sizes (2–3 m)

- TV scaffolds wrap with [`TvAccessibleScope`](../../lib/core/accessibility/tv_accessibility.dart).
- OS text scale is honored between **1.0× and 1.5×** (`TvAccessibility.maxTextScale`).
- Type floors: body ≥ 20 sp, title ≥ 28 sp, label ≥ 16 sp ([`TvDistanceLegibility`](./tv_distance_legibility.md) / QA-037).

## Focus visibility

Cloud **4 px** ring + Signal glow + **1.05×** scale on Ink / Panel / Surface ([`FocusStyles`](../../lib/core/theme/focus_styles.dart)). Asserted via `TvAccessibility.focusVisibleAtDistance()`.

## Subtitles

[`AppSubtitleStyle`](../../lib/core/theme/app_subtitle_style.dart) (DSN-021): standard ≥ body floor, large ≥ standard, Cloud on Ink meets large-text AA. VOD player hosts captions under `TvAccessibleScope`.

## Contrast

TV dark pairs from [`TvDistanceLegibility.contrastChecks`](../../lib/core/accessibility/tv_distance_legibility.dart) meet WCAG AA. Token authority remains DSN-002.

## TalkBack / semantics (MVP surfaces)

| Surface | Labels |
|---|---|
| Content cards / rails | `ContentCard` exposes title semantics |
| Quick access / controls | Visible labels with icons (DSN-019) — not hue alone |
| Live badges | `StatusBadge` icon + label |
| Search OSK | Key labels via `TvOnScreenKeyboard` |
| Stream failure | Recovery actions labeled Retry / Switch source / Back |
| Settings rows | List row titles |

## Out of scope

- Companion Dynamic Type / TalkBack → [CMP-063](companion_accessibility.md)
- Optical 2–3 m measurement beyond design floors → QA-037 distance suite (delegated)
