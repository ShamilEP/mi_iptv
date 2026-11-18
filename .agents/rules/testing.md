---
trigger: glob
globs: "**/test/**/*.dart"
description: Testing expectations for Flutter clients
---

# Testing

- Prefer pure unit tests for domain entities and use cases (no Flutter binding when avoidable).
- Fake/mock adapters and repositories — never hit real network or secure storage in unit tests.
- Widget tests for shared `core/widgets` and focus/empty/error states.
- Mirror `lib/features/<name>/...` under `test/features/<name>/...`.
- Do not add `mockito` / `mocktail` / golden toolkits until approved; use hand-rolled fakes first when enough.
