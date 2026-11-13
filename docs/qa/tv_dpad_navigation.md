# TV D-pad navigation automation (QA-025 / TV-121)

**Refs:** SRS §12 (focus maps), SRS §22 (client QA) · Depends on **TV-004**  
**Client task:** **TV-121** (extends QA-025 with Back stack + last-focus memory)  
**Executable suite:** [`test/qa/tv_dpad_navigation_test.dart`](../../test/qa/tv_dpad_navigation_test.dart)  
**Helpers:** [`test/qa/tv_dpad_harness.dart`](../../test/qa/tv_dpad_harness.dart)  
**Focus catalog:** [`TvFocusMaps`](../../lib/core/focus/tv_focus_maps.dart)  
**Architecture:** [`tv-121-dpad-navigation-tests.md`](../architecture/tv-121-dpad-navigation-tests.md)

## Coverage

| Rule | Automated check |
|---|---|
| **First focus** | Home → Continue watching card 0 (`Evening news`); Settings → Account; Live stream failure → Retry |
| **Determinism** | Home: Right then Left restores the same focused labels; remount repeats first focus |
| **Focus trap** | Live failure hides the channel list; D-pad stays on Retry / Switch source / Back to channels and does not zap channels |
| **Back** | VOD player Escape exits the route; failure overlay **Back to channels** fires dismiss callback |
| **Back stack** | Home → push Settings → pop returns to Home with Continue watching first focus |
| **Last-focus memory** | Home Continue watching: Right to card 1, Down leaves the row (`lastFocusedIndex` held), `restoreLastFocus()` returns to card 1 |

## Notes

- Widget-level D-pad simulation via `LogicalKeyboardKey` (arrow / Escape) — no device farm required for this gate.
- Manual TV pass in [test_strategy.md](./test_strategy.md) still covers physical remotes and OEM quirks.
- Series / EPG focus paths remain out of MVP scope.
