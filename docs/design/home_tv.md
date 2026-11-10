# TV Home (DSN-032)

Executable UI: [`TvHomePage`](../../lib/features/home/presentation/tv/tv_home_page.dart).

## Layout

1. **Brand lockup** + **quick access**: Live TV (primary), Favorites, Search, Settings.  
2. **Continue watching** — first content rail (initial focus).  
3. **Featured** — basic poster row.  
4. **Live channels** — basic channel tiles.

## Rules (DoD)

- Continue Watching is first — not below a hero.
- No full-bleed hero that pushes Live TV out of the first viewport / focus path.
- Live TV stays in the header quick-access rail (primary emphasis).
- Predictable initial focus: first Continue Watching card after first frame.
- Focus map / Back / restore: [focus_maps.md](./focus_maps.md) (DSN-040).
