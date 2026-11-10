# TV Search (DSN-035)

Executable UI: [`TvSearchPage`](../../lib/features/search/presentation/tv/tv_search_page.dart).

## Layout

1. **Large query** — headline-scale preview of the current search string above the field.
2. **TV keyboard** — [`TvOnScreenKeyboard`](../../lib/core/widgets/tv_on_screen_keyboard.dart) with Search field + Type from phone (DSN-014).
3. **Results** — grouped **Channels** (channel tiles) and **VOD** (posters). Cards use `FocusableSurface` for visible focus.
4. **Empty** — Empty pattern with Clear when nothing matches.

## Notes

- Design shell only: no backend search API.
- Filtering is local contains-match on title/subtitle.
