# TV focus maps and navigation flows (DSN-040)

**Refs:** SRS §12  
**Executable catalog:** [`TvFocusMaps`](../../lib/core/focus/tv_focus_maps.dart)

Each MVP TV hi-fi screen locks:

1. **First focus** — node focused when the screen opens  
2. **D-pad targets** — up / down / left / right edges  
3. **Back** — exit, dismiss overlay, move focus, or none  
4. **Focus restoration** — node restored when returning to the screen  

## Screens

| Screen | First focus | Back | Restore |
|---|---|---|---|
| Splash | Brand lockup | none | — |
| Onboarding / Auth | Primary field / OSK | exit | Primary field |
| Home | Continue watching card 0 | exit | Continue watching card 0 |
| Live TV | Channel list | exit | Channel list |
| Live TV failure | Retry | dismiss overlay → channels | Retry |
| Search | OSK | exit | OSK |
| Settings | Account category | exit | Account category |
| VOD player | Play / Pause | exit | Play / Pause |

## Flows (summary)

```
Splash --hold--> Home | Onboarding
Home --Live TV--> Live TV --failure--> Retry / Switch / Back to channels
Home --Search--> Search
Home --Settings--> Settings
Home --Continue watching / VOD--> VOD player
```

Favorites is **out of catalog** until DSN-036.

## Rules

- Prefer explicit maps over implicit Flutter traversal for TV-critical paths.
- Overlay screens (stream failure) hide competing rails so focus cannot escape.
- Reduced-motion does not change focus order — only animation duration.
