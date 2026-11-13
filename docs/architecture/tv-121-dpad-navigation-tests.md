# TV-121 — Automate D-pad navigation tests

**Refs:** SRS §12, §22 · Depends on **TV-004**, **QA-025**  
**Suite:** [`test/qa/tv_dpad_navigation_test.dart`](../../test/qa/tv_dpad_navigation_test.dart)  
**Helpers:** [`test/qa/tv_dpad_harness.dart`](../../test/qa/tv_dpad_harness.dart)  
**QA matrix:** [`docs/qa/tv_dpad_navigation.md`](../qa/tv_dpad_navigation.md)

## Goal

Lock Android TV D-pad behavior in CI so regressions fail before device farm:

1. **First focus** — highest-priority control on screen open  
2. **Determinism** — same arrow sequence → same focused control  
3. **Back stack** — Escape / pop leaves child routes; prior screen remains usable  
4. **No focus traps** — failure overlays keep focus on recovery CTAs (no channel zap)  
5. **Last-focus memory** — leaving a `ContentRow` keeps `lastFocusedIndex`; `restoreLastFocus()` returns to that card  

## Approach

Widget tests simulate remote keys (`LogicalKeyboardKey` arrows / Escape) via `TvDpadHarness`. No new packages. Physical OEM remotes stay a manual gate in the test strategy.

## Out of scope (MVP)

Series / EPG grids, Companion D-pad, and device-farm remote farms.
