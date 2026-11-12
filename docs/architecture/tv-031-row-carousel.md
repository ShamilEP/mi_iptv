# TV-031 — Build the row / carousel component

Depends on **DSN-012** (rows/carousels design) and **TV-004** (Design System TV).  
Skeletons: **DSN-016**. Home composition consumers: **TV-030** / **DSN-032**.

## Goal

Ship the shared Android TV horizontal rail used by Home & discovery: lazy paging,
skeleton placeholders, position cues, last-focus memory, and a **finite** vertical
stack of rows — no unanchored infinite scroll.

## Wiring

| DoD item | Authority |
|---|---|
| Horizontal rail | [`ContentRow`](../../lib/core/widgets/content_row.dart) |
| Anchored vertical stack | [`ContentRowList`](../../lib/core/widgets/content_row_list.dart) — requires finite `rowCount` |
| Lazy loading | Viewport `ListView` + trailing `placeholderCount` + `onNearEnd` / `nearEndThreshold` |
| Skeletons | [`ContentCardSkeleton`](../../lib/core/widgets/content_card_skeleton.dart) (in-rail stubs) · [`ContentRowSkeleton`](../../lib/core/widgets/content_row_skeleton.dart) (full-rail loading) |
| Position cue | `i / n` beside the row title while a real card is focused |
| Last-focus memory | Per-row `FocusNode`s + `PageStorage` (`storageId`) + `restoreLastFocus()` / `requestFocusAt` |
| No unanchored infinite scroll | Explicit `rowCount` / `itemCount`; never an unbounded generator |

## TV usage rules

- Feature `presentation/tv` screens compose `ContentRow` / `ContentRowList`; do not invent one-off carousels.
- While a catalog page is in flight, show `ContentRowSkeleton` or raise `placeholderCount` — keep rail height stable (DSN-016).
- Request the next page from `onNearEnd`; append items and clear placeholders when data arrives.
- Persist focus with a stable `storageId` per rail (e.g. `home-continue-watching`).

## Validation

Contract tests: `test/core/widgets/tv_031_row_carousel_test.dart` and
`test/docs/tv_031_row_carousel_doc_test.dart`.  
Related: `test/core/widgets/content_row_test.dart`, `skeleton_loading_test.dart`.
