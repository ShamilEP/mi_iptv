# TV-004 — Implement the Design System TV

Depends on **DSN-001** (colors), **DSN-003** (type), **DSN-006** (focus), **DSN-010** (12 states), **TV-002** (scaffold).  
Handoff catalog: [design_system_handoff.md](../design/design_system_handoff.md).

## Goal

Make the Android TV / Google TV client the executable Brand Theme 2026–27 surface: dark theme, TV type ramp (Label ≥ 16 sp), color tokens, D-pad focus (4 px Cloud ring + 1.05× scale), and shared components that honor the 12 mandatory UI states.

## Wiring

| DoD item | Authority |
|---|---|
| Theme | [`AppTheme.tvDark()`](../../lib/core/theme/app_theme.dart) — selected by [`MiIptvApp`](../../lib/app/app.dart) when `ClientKind.tv` |
| Color tokens | [`AppColors`](../../lib/core/theme/app_colors.dart) + [`MiBrandColors.tv()`](../../lib/core/theme/mi_brand_colors.dart) |
| TV type scale | [`AppTypography`](../../lib/core/theme/app_typography.dart) — `tvLabelSize` / `tvLabelLine` = **16 / 24** (minimum Label) |
| Focus modifier | [`FocusStyles`](../../lib/core/theme/focus_styles.dart) + [`FocusableSurface`](../../lib/core/widgets/focusable_surface.dart) — `ringWidth` **4**, `scale` **1.05**, Cloud ring + Signal glow |
| 12 states | [`UiState`](../../lib/core/widgets/ui_state.dart) + [`UiStateCatalog`](../../lib/core/widgets/ui_state_catalog.dart); control paint via [`ControlChrome`](../../lib/core/widgets/control_chrome.dart) |

## Shared TV components (consume tokens)

Prefer `lib/core/widgets` atoms on TV screens: `FocusableSurface`, `MiButton`, `MiChip`, `MiListRow`, `ContentCard` / `ContentRow`, status patterns, player overlays, TV OSK. Feature `presentation/tv` pages compose these — they must not invent one-off hex, focus rings, or type sizes.

## Validation

Contract tests: `test/core/theme/tv_004_design_system_test.dart` and `test/docs/tv_004_design_system_doc_test.dart`.  
Related: typography / focus / UiStateCatalog unit suites under `test/core/`.
