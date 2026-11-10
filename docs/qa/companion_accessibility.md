# Companion accessibility pass (CMP-063)

**Refs:** NFR-007 · Depends on DSN-002 contrast tokens  
**Scope:** Flutter Companion surfaces in this repo (login / linked TVs, remote, Explore)

## Dynamic Type

- Companion scaffolds wrap with [`CompanionAccessibleScope`](../../lib/core/accessibility/companion_accessibility.dart).
- OS text scale is honored between **1.0× and 2.0×** (`CompanionAccessibility.maxTextScale`).
- Explore catalog rail heights scale with the clamped text scaler so cards stay usable.

## VoiceOver / TalkBack

| Surface | Labels |
|---|---|
| Login fields | `MiTextField` exposes `Semantics(textField)` with the visible label; password marked obscured |
| Form / keyboard errors | `liveRegion` announcements |
| Linked TVs | Row subtitle = Connected / Offline (not icon-only) |
| Remote keys | `Semantics(button)` + visible label on every control |
| Remote feedback | `liveRegion` for last command / typed text |
| Explore cards | Existing `ContentCard` semantics (title) |

## Contrast

Companion light pairs used by body text, muted copy, primary CTAs, remote keys, and Send-to-TV are asserted via `CompanionAccessibility.contrastChecks` (WCAG AA). Token authority remains DSN-002.

## Out of scope

- TV 2–3 m legibility → TV-123 / QA-037
- Subtitle style / player captions → DSN-021
