# TV History (DSN-063)

Executable UI: [`TvHistoryPage`](../../lib/features/history/presentation/tv/tv_history_page.dart) on `AppTheme.tvDark()`.

**Phase:** Release 1 design shell.

## Layout

1. **Brand lockup** + **History** title.
2. Body copy states History is **separate from Continue watching** on Home.
3. **Privacy** — Save watch history toggle + **Clear history**.
4. Chronological list with Open / Remove; empty pattern when cleared or vacant.

## Privacy rules (DoD)

- Pausing save shows a warning banner; Home Continue watching is called out as unchanged.
- Clear empties this screen only (shell — no Home rail mutation).
- Toggle + banner use icon/label cues (not hue alone).

## Notes

- Design shell only: no history API / sync.
- `TvAccessibleScope` wraps the page (TV-123).
