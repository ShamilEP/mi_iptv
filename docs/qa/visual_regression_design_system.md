# Design System visual regression (QA-029)

**Refs:** SRS §22 (client QA) · Depends on **TV-004**  
**Executable suite:** [`test/qa/visual_regression_design_system_test.dart`](../../test/qa/visual_regression_design_system_test.dart)  
**Harness:** [`test/qa/visual_regression_harness.dart`](../../test/qa/visual_regression_harness.dart)  
**Baselines:** [`test/qa/goldens/`](../../test/qa/goldens/)

## Goal

Lock pixel baselines for TV Design System **focus** (DSN-006) and the **12 mandatory UI states** (DSN-010) so chrome regressions fail in CI without approving golden toolkits (`golden_toolkit` / Alchemist remain unapproved — use Flutter `matchesGoldenFile` only).

## Coverage

| Baseline | Golden file | What it locks |
|---|---|---|
| Focus resting | `design_system_focus_resting.png` | `FocusableSurface` button kind, no ring / glow / scale |
| Focus focused | `design_system_focus_focused.png` | Cloud 4px ring + Signal glow + 1.05× scale |
| 12 states | `design_system_ui_states_12.png` | `MiButton` × every `UiState` / `UiStateCatalog` label |

Theme: `AppTheme.tvDark()` on Ink canvas. Animations frozen (`MediaQuery.disableAnimations` + `TickerMode(enabled: false)`) so Loading / Syncing progress does not flicker pixels.

## When goldens run

| Environment | Pixel compare |
|---|---|
| CI Linux (`ubuntu-latest`) | **On** — asserts against checked-in PNGs |
| Local Windows / macOS | **Off** by default (layout still pumps; avoids cross-OS font raster false fails) |
| Force anywhere | Set `UPDATE_GOLDENS=1` |

## Regenerate baselines (Linux / CI parity)

Baselines are authored on Linux so `ubuntu-latest` CI matches pixels. Helper script:

[`tool/qa/update_design_system_goldens.sh`](../../tool/qa/update_design_system_goldens.sh)

```powershell
docker run --rm -v "${PWD}:/app" -w /app ubuntu:24.04 `
  bash -lc "sed -i 's/\r$//' tool/qa/update_design_system_goldens.sh && bash tool/qa/update_design_system_goldens.sh"
```

On a Linux host with a matching Flutter stable SDK:

```bash
UPDATE_GOLDENS=1 flutter test --update-goldens test/qa/visual_regression_design_system_test.dart
```

Commit updated PNGs under `test/qa/goldens/` with the task branch. Never commit secrets or store screenshots outside this folder.
