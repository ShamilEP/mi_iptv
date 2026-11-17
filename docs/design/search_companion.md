# Companion Search (CMP-041)

Executable UI: [`CompanionSearchPage`](../../lib/features/search/presentation/companion/companion_search_page.dart).

**Phase:** MVP design shell (FR-018 / FR-037).  
**Depends:** `BE-052` deferred — local demo catalog until search API lands.  
**Unblocks:** CMP-061 touch automation coverage for search.

## Layout

1. **Brand lockup** under [`CompanionPlatformShell`](../../lib/core/platform/companion_platform_shell.dart).
2. **Search field** — [`MiTextField`](../../lib/core/widgets/mi_text_field.dart) with system touch keyboard; input sanitized at the boundary.
3. **Results** — grouped **Channels** and **VOD** list tiles from the local catalog.
4. **Empty** — Empty pattern + Clear when nothing matches.
5. **Clear** — secondary control when the query is non-empty.

## Matching

Uses shared [`TolerantSearch`](../../lib/features/search/presentation/shared/tolerant_search.dart) (contains / prefix / small edit-distance) — same matcher as TV Search.

## Notes

- Design shell only: no Backend search API.
- Complements TV Search ([search_tv.md](./search_tv.md)).
- MVP Companion does not play video; result selection is a shell callback (e.g. open detail / send-to-TV later).
