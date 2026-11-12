# TV Content detail (DSN-034)

Executable UI: [`TvContentDetailPage`](../../lib/features/catalog/presentation/tv/tv_content_detail_page.dart).  
**FR / stories:** FR-012 / US-12 (Play/Resume actions also cover FR-013 / US-13).  
**Product lock:** Series season/episode navigation is **deferred** (PRD-013).

## Layout

1. **Large art** — poster-aspect hero (280dp wide, 2:3) on the left.
2. **Title** — headline scale.
3. **Metadata** — year / rating / genres / type chips plus duration when provided.
4. **Synopsis** — body copy under metadata.
5. **Actions** — **Play** (primary), **Resume** when recoverable progress ≥15%, **Favorite** / **Favorited** toggle.
6. **Related** — horizontal poster rail of related titles (not episodes).

## Rules (DoD)

- Art, title, metadata, synopsis, and duration render when the catalog provides them.
- Primary actions always include Play and Favorite; Resume appears only with recoverable progress.
- Related content uses the shared [`ContentRow`](../../lib/core/widgets/content_row.dart) / [`ContentCard`](../../lib/core/widgets/content_card.dart) atoms (DSN-011 / TV-031).
- No season picker, episode list, or series stack in MVP (PRD-013).

## Notes

- Design shell: Play / Resume / Favorite / Related are local callbacks; no catalog API.
- Focus map: [focus_maps.md](./focus_maps.md) (Content detail entry added with DSN-034).
- Route: [`AppRoutes.tvContentDetail`](../../lib/app/navigation/app_routes.dart) (`/tv/content-detail`).
