# Upgrades and migrations (QA-041)

**Refs:** FR-027 · US-18 · Depends on **TV-015**  
**Executable suite:** [`test/qa/upgrades_and_migrations_test.dart`](../../test/qa/upgrades_and_migrations_test.dart)  
**Architecture:** [tv-015-local-db-migrations.md](../architecture/tv-015-local-db-migrations.md)

## Goal

Prove that an **app binary update** preserves local durable DB rows and sync state (favorites, playback progress, sources, settings, sync outbox + `syncVersion`), and that a failed/corrupt schema path stays **recoverable** with a clear message — never a silent wipe.

## Coverage (US-18 / FR-027)

| Scenario | Automated check |
|---|---|
| **App binary update (schema bump)** | Seed schema v1 SQLite with favorites, progress (`syncVersion`), sources, settings, outbox → open with current `AppDatabase` → rows + sync metadata readable; watermark = current |
| **Same-schema reopen** | Write on current schema, close, reopen same file → durable + outbox state unchanged (store update without migration wipe) |
| **Recoverable failure** | Missing core table → `LocalMediaSchemaException` with recoverable guidance (no silent delete) |

## Mapping to acceptance

```gherkin
Given I have local favorites, progress, and configured sources
When an app binary update opens a prior on-disk DB
Then local durable data remains readable after the update
And sync with the backend can resume (outbox + syncVersion intact)
And a failure during update leaves the app in a recoverable state with a clear message
```

Catalog refresh and remote-config update paths are covered by sync / catalog feature suites; this QA gate focuses on the **local DB migration / binary update** slice of FR-027.

## Notes

- Uses Drift in-memory / temp-file executors only — no device farm, no real store sideload required for CI.
- Manual TV pass still recommended once: install build N with seeded favorites → sideload build N+1 → confirm Continue watching / Favorites / Sources.
- Secrets must never appear in fixtures or Logcat (HTTPS placeholder URLs only).
