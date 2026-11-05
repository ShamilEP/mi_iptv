# Semantic color usage guide (DSN-007)

Executable catalog: [`SemanticColorUsage`](../../lib/core/theme/semantic_color_usage.dart).  
Contrast pairs: [`color_contrast_test.dart`](../../test/core/theme/color_contrast_test.dart) (DSN-002).  
Brand rule summary: [`.cursor/rules/brand-ui.mdc`](../../.cursor/rules/brand-ui.mdc).

## Status accents (DoD)

| Role | TV token | Companion token | Use for |
|---|---|---|---|
| Primary / actions / progress | `signal` | `companionPrimary` | CTAs, progress bars, focus glow accent |
| LIVE / alerts / send-to-TV | `ember` | `companionLive` | LIVE badge, send-to-TV, non-failure alerts |
| Synced / connected | `success` | `success` | Sync OK, connected device |
| Weak network | `warning` | `warning` | Degraded connectivity, sync-conflict caution |
| Stream failed | `error` | `error` | Playback / stream failure + retry |

## Rules of thumb

1. **State ≠ hue alone** — pair every status accent with icon, label, pattern, scale, or ring.
2. **Never** use status accents as body text on `cloud` (fails WCAG AA).
3. On Companion light fills, use `ink` or `cloud` as `on*` text for primary/LIVE CTAs.
4. Structural tokens (`ink`, `surface`, `panel`, `border`, `cloud`, `mist`) stay for surfaces and typography — not for LIVE/error meaning.
5. Prefer `SemanticColorUsage.resolve(role, companion: …)` or `context.brandColors.primary` / `.live` over raw hex.

## Forbidden swaps

- Signal for LIVE / send-to-TV → use Ember.  
- Ember for primary CTA → use Signal.  
- Warning for hard stream failure → use Error.  
- Success for weak network → use Warning.
