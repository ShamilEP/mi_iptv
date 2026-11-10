# TV Search (DSN-035 / DSN-065)

Executable UI: [`TvSearchPage`](../../lib/features/search/presentation/tv/tv_search_page.dart).

## Layout

1. **Large query** — headline-scale preview of the current search string above the field.
2. **TV keyboard** — [`TvOnScreenKeyboard`](../../lib/core/widgets/tv_on_screen_keyboard.dart) with Search field + Type from phone (DSN-014).
3. **Suggestions** (DSN-065) — chip row for completions / near spellings from the local catalog.
4. **Did you mean** (DSN-065) — recovery banner when the query looks like a typo; applying replaces the query.
5. **Results** — grouped **Channels** (channel tiles) and **VOD** (posters). Cards use `FocusableSurface` for visible focus.
6. **Empty** — Empty pattern with Clear when nothing matches (still shown under did-you-mean when useful).

## Notes

- Design shell only: no backend search API.
- Matching uses [`TolerantSearch`](../../lib/features/search/presentation/tv/tv_search_tolerance.dart): contains, prefix, and small edit-distance recovery.
