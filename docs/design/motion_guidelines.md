# Motion guidelines (DSN-020)

Executable tokens: [`AppMotion`](../../lib/core/theme/app_motion.dart) (DSN-004 durations + DSN-020 reduced-motion helpers).  
Brand rule summary: [`.cursor/rules/brand-ui.mdc`](../../.cursor/rules/brand-ui.mdc).

## Principles

1. **Short** — stay on the brand ramp: `fast` 120ms (focus), `normal` 200ms (chrome / overlays), `slow` 320ms (rare emphasis). Do not invent longer decorative loops.
2. **Functional** — motion clarifies state (focus land, overlay appear, toggle thumb). Never animate for ornament alone.
3. **Respect reduced motion** — when `MediaQuery.disableAnimations` is true, decorative / transition durations resolve to **zero** via `AppMotion.durationOf`. Focus **visibility** (Cloud ring + Signal glow) must remain; only scale/opacity tweens may snap.
4. **Token-only** — use `AppMotion` durations/curves; no one-off `Duration(milliseconds: …)` in widgets.

## Token map

| Token | Duration | Typical use |
|---|---|---|
| `fast` | 120ms | Focus scale / press feedback (`FocusableSurface`, control shell) |
| `normal` | 200ms | Overlay fade, row scroll settle, toast enter |
| `slow` | 320ms | Rare larger layout emphasis (avoid on TV focus path) |
| `channelInfoAutoHide` | 4s | Functional dwell — keep even under reduced motion |
| `emphasized` | `easeOutCubic` | Enter / focus emphasis |
| `standard` | `easeInOut` | Symmetric settle |

## Reduced motion API

```dart
final d = AppMotion.durationOf(context, AppMotion.fast);
final c = AppMotion.curveOf(context, AppMotion.emphasized);
// AnimatedContainer(duration: d, curve: c, ...)
```

| Setting | Transitions | Focus ring / glow | Auto-hide timers |
|---|---|---|---|
| Animations on | Token durations | Visible + may scale | As specified |
| Reduced motion | `Duration.zero` / linear | **Still visible** (non-color cue) | Still fire (e.g. 4s channel info) |

## Do / don’t

**Do**

- Pair motion with non-color state cues (DSN-002 / DSN-010).
- Prefer opacity / short scale over large layout slides on 10-foot TV.
- Keep player scrubber / progress determinate without flashy loops.

**Don’t**

- Infinite decorative pulses on resting chrome (skeletons stay static; see loading patterns).
- Disable focus indication to “simplify” motion.
- Exceed `slow` without a documented product reason (ask — do not invent).

## Sprint check

When shipping animated chrome: call `durationOf` / `curveOf`, cover a widget test with `MediaQuery(data: … disableAnimations: true)`, and keep analyze/tests green.
