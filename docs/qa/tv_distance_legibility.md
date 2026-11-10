# TV distance legibility and accessibility (QA-037)

**Refs:** NFR-007 · SRS §22 · Depends on DSN-002 contrast  
**Executable checks:** [`TvDistanceLegibility`](../../lib/core/accessibility/tv_distance_legibility.dart) + [`tv_distance_legibility_test.dart`](../../test/core/accessibility/tv_distance_legibility_test.dart)

## Viewing band

Living-room TV UI is validated for **2–3 m** (about 6–10 ft).

## Checks

| Area | Floor |
| --- | --- |
| Legibility | TV body ≥ 20 sp, title ≥ 28 sp, label ≥ 16 sp ([`AppTypography`](../../lib/core/theme/app_typography.dart)) |
| Contrast | Cloud/Mist/Signal/Ember pairs on Ink/Surface + focus ring on Ink meet WCAG AA |
| Focus visibility | Cloud **4 px** ring + Signal glow + **1.05×** scale on Ink / Panel / Surface |

## Notes

- Companion Dynamic Type / TalkBack remain under CMP-063.
- Broader TV accessibility pass (TalkBack routes, full screen audit) → TV-123.
