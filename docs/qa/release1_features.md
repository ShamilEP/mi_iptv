# Release 1 features (QA-053)

**Refs:** SRS §23 · Depends on **PRD-032** (provisional AC)  
**Stories:** [`docs/product/user_stories_release1.md`](../product/user_stories_release1.md) (US-R1-01…11)  
**Executable suite:** [`test/qa/release1_features_test.dart`](../../test/qa/release1_features_test.dart)

## Goal

Gate Release 1 client surfaces called out for QA-053 against provisional PRD-032 acceptance criteria. Automated checks cover **shipped shells / local helpers** only; API-backed behaviors stay manual/deferred until adapters land.

## Coverage map

| QA-053 / story | Automated now | Deferred / manual |
|---|---|---|
| **EPG matching** (US-R1-01) | `TvEpgGridPage` mounts channel × time grid + Now highlight | Real schedule matching / catalog id map |
| **Time zones / DST** (US-R1-02) | — (documented only) | TZ/DST conversion + DST boundary lab |
| **Large XMLTV** (US-R1-03) | — (documented only) | Large-file ingest / chunked parse lab |
| **Multi-profile** (US-R1-04) | Profile picker shell mounts Who’s watching + add/edit affordances | Profile API / sync / durable store |
| **Parental** (US-R1-05) | Wrong PIN errors; demo correct PIN unlocks session | Durable PIN hash / Backend gate |
| **Tolerant search** (US-R1-07) | `TolerantSearch` contains + typo recovery | Backend search API |
| **Audio / subtitle tracks** (US-R1-08) | Track picker opens; session preference remembered; MVP `DefaultTrackPolicy` still selects source defaults | Media3 track enumeration / durable prefs |
| **History** (US-R1-06) | History separate from Continue watching; privacy toggle + clear | History API / sync |
| **Deep links** (US-R1-09) | — (documented only) | OS URI / `app_links` integration |
| **Extended QoE** (US-R1-10) | — (documented only; security bar = anonymous IDs) | Extended event catalog vs field data |
| **Settings sync** (US-R1-11) | — (documented only) | Sync allow-list + multi-device lab |

## Notes

- Provisional AC is Product draft pending SRS §18 / §23 lock — do not invent Backend contracts in this suite.
- Design-shell fixtures (e.g. parental demo PIN) must never appear in logs or production auth.
- When adapters ship, promote deferred rows into automated checks and keep this matrix current.
