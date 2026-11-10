# TV Home (DSN-032 / TV-033)

Executable UI: [`TvHomePage`](../../lib/features/home/presentation/tv/tv_home_page.dart).

## Layout

1. **Brand lockup** + **quick access**: Live TV (primary), Favorites, Search, Settings.  
2. **Continue watching** — first content rail (initial focus).  
3. **Featured** — basic poster row.  
4. **Live channels** — basic channel tiles.

## Empty / offline (TV-033)

Brand + quick access stay visible. The rail stack is replaced by a DSN-017 pattern:

| `TvHomeSurfaceState` | Pattern | Action |
| --- | --- | --- |
| `noSources` | Empty — “No sources” | Add source |
| `emptyCatalog` | Empty — “Catalog is empty” | Refresh |
| `offline` | Offline — “You are offline” | Try again |

## Rules (DoD)

- Continue Watching is first — not below a hero.
- No full-bleed hero that pushes Live TV out of the first viewport / focus path.
- Live TV stays in the header quick-access rail (primary emphasis).
- Predictable initial focus: first Continue Watching card after first frame (ready only).
- Focus map / Back / restore: [focus_maps.md](./focus_maps.md) (DSN-040).

## Release 2

Personalized recommendation rows + compact hero (Live TV still header-bound): [home_personalized_tv.md](./home_personalized_tv.md) (DSN-070).
