# Design system handoff (DSN-008)

Sprint 0 developer handoff for **TV + Companion**, without a separate Figma library.  
**Source of truth:** executable Brand Theme tokens and shared widgets in this repo — not invented mockups.

| Layer | Authority |
|---|---|
| Colors | [`AppColors`](../../lib/core/theme/app_colors.dart) (DSN-001) |
| Contrast pairs | [`color_contrast_test.dart`](../../test/core/theme/color_contrast_test.dart) (DSN-002) |
| Typography | [`AppTypography`](../../lib/core/theme/app_typography.dart) (DSN-003) |
| Spacing / grid / overscan / radius / elevation / motion | [`AppSpacing`](../../lib/core/theme/app_spacing.dart), [`AppGrid`](../../lib/core/theme/app_spacing.dart), [`AppOverscan`](../../lib/core/theme/app_overscan.dart), [`AppRadius`](../../lib/core/theme/app_radius.dart), [`AppElevation`](../../lib/core/theme/app_elevation.dart), [`AppMotion`](../../lib/core/theme/app_motion.dart) (DSN-004) |
| Logo kit | [`BrandAssets`](../../lib/core/theme/brand_assets.dart) + `BrandMark` / `BrandWordmark` / `BrandLockup` (DSN-005) |
| Focus | [`FocusStyles`](../../lib/core/theme/focus_styles.dart) (DSN-006) |
| Semantic accents | [`SemanticColorUsage`](../../lib/core/theme/semantic_color_usage.dart) · [semantic_color_usage.md](./semantic_color_usage.md) (DSN-007) |
| Machine export | [`brand_tokens.json`](./brand_tokens.json) (this task) |
| Agent / UI rules | [`.cursor/rules/brand-ui.mdc`](../../.cursor/rules/brand-ui.mdc) |

Theme barrel: [`lib/core/theme/theme.dart`](../../lib/core/theme/theme.dart).

## Naming conventions

### Dart / Flutter

| Kind | Pattern | Examples |
|---|---|---|
| Token holders | `App*` / feature abstract finals | `AppColors`, `AppSpacing`, `FocusStyles` |
| Token members | `lowerCamelCase` | `ink`, `insetPageTv`, `ringWidth` |
| Shared widgets | `Mi*` or descriptive noun | `MiButton`, `FocusableSurface`, `ContentCard` |
| Enum roles | `UpperCamelCase` type, `lowerCamelCase` values | `IconRole.live`, `FocusControlKind.card` |
| Files | `snake_case.dart` under `lib/core/theme` or `lib/core/widgets` | `app_colors.dart` |
| Screen docs | `docs/design/<flow>_<surface>.md` | `home_tv.md`, `companion_remote.md` |

### Token export JSON (`brand_tokens.json`)

- Top-level groups: `meta`, `color`, `typography`, `spacing`, `grid`, `overscan`, `radius`, `elevation`, `motion`, `focus`, `brand`, `contentCard`.
- Color values: `#RRGGBB` uppercase hex (same digits as Dart `0xFF…`).
- Durations: integer **milliseconds**.
- Dimensions: logical **px** at 1.0 density (TV assumes 1080p design canvas).

### Do / don’t

- **Do** import `package:mi_iptv/core/theme/theme.dart` (or the specific token file) and use named tokens.
- **Do** compose TV/Companion UI from `lib/core/widgets` before inventing new chrome.
- **Don’t** hardcode hex, raw padding, radius, shadow, or duration numbers in feature widgets.
- **Don’t** invent a parallel Figma token sheet that diverges from Dart — change code first, then refresh `brand_tokens.json`.

## Tokens as code (map)

| Domain | Dart API | Notes |
|---|---|---|
| Structural color | `AppColors.ink` … `border`, `cloud`, `mist` | Dark-first TV; Companion uses `cloud` canvas |
| Accents | `signal`, `ember`, `success`, `warning`, `error` | Pair with non-color cues (DSN-002 / DSN-010) |
| Companion accents | `companionPrimary`, `companionLive`, `companionMuted` | Light-surface CTAs / LIVE |
| Type families | `AppTypography.displayFamily` / `bodyFamily` / `dataFamily` | Bundled OFL under `assets/fonts/` |
| Type ramps | `tv*Size` / `companion*Size` + line heights | Wired via `AppTheme.tvDark()` / `companionLight()` |
| Spacing | `AppSpacing.xxs`…`xxxl` + semantic aliases | 4dp base, 8-forward for TV |
| Grid | `AppGrid.gutter` / `rowGap` / `railGap` | Home / catalog rhythm |
| Overscan | `AppOverscan.inset` = 48 | Actionable chrome inside; player/hero may full-bleed |
| Radius | `AppRadius.xs`…`full` | Default cards: `md` (16) |
| Elevation | `AppElevation.flat` / `raised` / `overlay` | Soft ambient on Ink — not Material ints |
| Motion | `AppMotion.fast` / `normal` / `slow` | Use `durationOf` / `curveOf` for reduced motion |
| Focus | `FocusStyles.ringWidth` 4, `scale` 1.05 | Cloud ring + Signal glow |

Full numeric dump: [brand_tokens.json](./brand_tokens.json).

## Shared component library

Prefer these atoms for MVP chrome (TV Leanback + Companion). Feature screens should orchestrate, not re-skin.

| Component | Path | Role |
|---|---|---|
| `FocusableSurface` | `lib/core/widgets/focusable_surface.dart` | D-pad focus shell (ring / glow / scale) |
| `MiButton` | `lib/core/widgets/mi_button.dart` | Primary / secondary actions |
| `MiChip` | `lib/core/widgets/mi_chip.dart` | Filters, LIVE pills |
| `MiListRow` | `lib/core/widgets/mi_list_row.dart` | Settings / channel rows |
| `MiToggle` | `lib/core/widgets/mi_toggle.dart` | Boolean settings |
| `MiTextField` | `lib/core/widgets/mi_text_field.dart` | Companion / form input |
| `MiIcon` | `lib/core/widgets/mi_icon.dart` | Catalog glyphs + required labels |
| `ContentCard` | `lib/core/widgets/content_card.dart` | Poster / landscape / channel / CW |
| `ContentRow` / `ContentRowList` | `lib/core/widgets/content_row*.dart` | Horizontal rails |
| `StatusBadge` | `lib/core/widgets/status_badge.dart` | LIVE / sync / warning chips |
| `BrandMark` / `BrandWordmark` / `BrandLockup` | `lib/core/widgets/brand_*.dart` | Logo kit only |
| Skeletons | `*_skeleton.dart`, `list_skeleton.dart` | Loading placeholders |
| State patterns | `loading_pattern`, `status_pattern`, `error_retry_overlay`, … | Mandatory UI states (DSN-010) |
| Player chrome | `player_controls_overlay`, `channel_info_overlay`, … | Playback overlays |
| TV OSK | `tv_on_screen_keyboard`, `tv_osk_key` | Search / PIN entry |

Mandatory interaction states: see `UiStateCatalog` / `ui_state.dart` — Default, Focused, Pressed, Disabled, Loading, Empty, Error, Offline, Playing, Selected, Syncing, Sync Conflict.

Related guides: [iconography.md](./iconography.md), [motion_guidelines.md](./motion_guidelines.md), [focus_maps.md](./focus_maps.md).

## Redlines (canonical measurements)

Use these when reviewing layouts or writing screen specs. Values match token code.

### Canvas & safe area

| Spec | Value |
|---|---|
| TV design canvas | 1920×1080 logical |
| TV overscan inset | **48 px** all sides (`AppOverscan.inset`) |
| Companion page inset | **16 px** (`AppSpacing.insetPageCompanion`) + system `SafeArea` |

### Focus chrome

| Spec | Value |
|---|---|
| Focus ring | **4 px** Cloud |
| Outer glow | Signal, spread **10**, alpha **0.45** |
| Focus scale | **1.05×** |
| Default card radius | **16** (`AppRadius.md`) |

### Content cards (1080p defaults)

| Kind | Aspect | Default width |
|---|---|---|
| Poster | 2:3 | 160 |
| Landscape / Continue Watching | 16:9 | 280 |
| Channel tile | 1:1 | 120 |
| CW progress track | — | height **4** (Signal) |

### Grid rhythm

| Token | px |
|---|---|
| `AppGrid.gutter` | 16 |
| `AppGrid.rowGap` | 24 |
| `AppGrid.railGap` | 32 |

### Type (quick redline)

| Role | TV size/line | Companion size/line |
|---|---|---|
| Display | 56/64 | 36/44 |
| Headline | 40/48 | 28/36 |
| Title | 28/36 | 20/28 |
| Body | 20/28 | 16/24 |
| Label | 16/24 | 13/20 |
| Data | 16/24 | 13/20 |

### Brand mark

| Spec | Value |
|---|---|
| viewBox | 72×64 |
| Stroke | 7 |
| Live-dot radius | 5.5 → clear space **11** |
| Min mark size | **24 px** |
| Wordmark | lowercase `iptv`, tracking **−3%** |

## Workflow (no Figma)

1. Change tokens only in `lib/core/theme` (+ contract tests under `test/core/theme`).
2. Mirror numbers into `docs/design/brand_tokens.json`.
3. Document screen-specific layout in `docs/design/<screen>.md` using token names, not one-off px where a token exists.
4. Prefer shared widgets; if a new atom is needed, add it under `lib/core/widgets` and list it here.

## DoD checklist (DSN-008)

- [x] Shared TV + Companion component inventory documented
- [x] Tokens as code remain the authority (`lib/core/theme`)
- [x] Machine-readable token export (`brand_tokens.json`)
- [x] Naming conventions for Dart + export JSON
- [x] Redlines for overscan, focus, cards, grid, type, brand mark
- [x] Explicit “no divergent Figma sheet” rule — graphical line = existing Brand Theme 2026–27
