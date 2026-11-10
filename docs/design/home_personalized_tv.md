# Personalized TV Home (DSN-070)

Executable UI: [`TvPersonalizedHomePage`](../../lib/features/home/presentation/tv/tv_personalized_home_page.dart).

**Phase:** Release 2 design shell (extends DSN-032 Home).

## Layout

1. **Brand lockup** + **quick access** — Live TV remains primary in the header.
2. **Compact hero** — [`TvHomeHero`](../../lib/features/home/presentation/tv/tv_home_hero.dart) under the header (height-capped; not full-bleed).
3. **Continue watching** — first content rail (initial focus).
4. **Recommendation rows** — e.g. Because you watched…, Recommended for you.
5. **Live channels** — trailing channel tiles.

## Hero rules (DoD)

- Hero **must not** displace Live TV access — Live TV stays in the header rail.
- Hero is compact / inset (surface card), not a full-bleed stage that pushes Live TV out of the first viewport.
- Copy reminds: Live TV stays in the header.

## Notes

- Design shell only: no recommendation API / personalization backend.
- MVP Home without personalization remains [`TvHomePage`](../../lib/features/home/presentation/tv/tv_home_page.dart) (DSN-032).
