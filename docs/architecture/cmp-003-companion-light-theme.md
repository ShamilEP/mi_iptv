# CMP-003 — Companion light theme and type scale

Depends on **DSN-001** (colors), **DSN-003** (typography), **CMP-002** (scaffold).  
Handoff catalog: [design_system_handoff.md](../design/design_system_handoff.md).  
TV counterpart: [tv-004-design-system-tv.md](./tv-004-design-system-tv.md).

## Goal

Make the Companion client the executable **light** Brand Theme surface: Cloud canvas,
companion accents (**primary `#0A6F68`**, **live `#B8431B`**), and the companion type
ramp (Headline **28**, Title **20**, Body **16**, Label **13**). A Companion **dark**
theme remains optional and out of MVP.

## Wiring

| DoD item | Authority |
|---|---|
| Theme | [`AppTheme.companionLight()`](../../lib/core/theme/app_theme.dart) — selected by [`MiIptvApp`](../../lib/app/app.dart) when `ClientKind.companion` |
| Color tokens | [`AppColors.companionPrimary`](../../lib/core/theme/app_colors.dart) `0xFF0A6F68` · [`companionLive`](../../lib/core/theme/app_colors.dart) `0xFFB8431B` · canvas [`cloud`](../../lib/core/theme/app_colors.dart) |
| Brand extension | [`MiBrandColors.companion()`](../../lib/core/theme/mi_brand_colors.dart) |
| Type scale | [`AppTypography`](../../lib/core/theme/app_typography.dart) companion ramp + [`companionTextTheme`](../../lib/core/theme/app_typography.dart) |

## Companion type scale (locked)

| Role | Material slot | Size / line |
|---|---|---|
| Display | `displayLarge` | 36 / 44 |
| Headline | `headlineMedium` | **28** / 36 |
| Title | `titleLarge` | **20** / 28 |
| Body | `bodyLarge` | **16** / 24 |
| Label | `labelLarge` | **13** / 20 |
| Data | `labelSmall` | 13 / 20 |

## Validation

Contract tests: `test/core/theme/cmp_003_companion_theme_test.dart` and
`test/docs/cmp_003_companion_theme_doc_test.dart`.
