# TV Favorites (DSN-036)

Executable UI: [`TvFavoritesPage`](../../lib/features/favorites/presentation/tv/tv_favorites_page.dart).

## Layout

1. **Brand lockup** + **Favorites** title / body.
2. **Channels** group — live channel favorites only.
3. **VOD** group — movies / series favorites only.
4. **Stable order** — each item shows `Order N`; groups sort by ascending `order`.
5. **Quick actions** — **Open** (primary) and **Remove** (secondary) on every row.
6. **Empty** — [`EmptyPattern.favorites`](../../lib/core/widgets/status_pattern.dart) (`No hay favoritos` / Browse catalog).

## Rules (DoD)

- Channels and VOD never mix in one rail.
- Order is stable (explicit `order` field; remove does not reshuffle remaining ranks in the shell).
- Quick actions stay on the row for D-pad reach.

## Notes

- Design shell: Open / Remove are local callbacks; no favorites API.
- Focus map: [focus_maps.md](./focus_maps.md) (Favorites entry added with DSN-036).
