# Companion touch automation (QA-026)

**Refs:** SRS §22 · Depends on **CMP-002**  
**Executable suite:** [`test/qa/companion_touch_test.dart`](../../test/qa/companion_touch_test.dart)  
**Helpers:** [`test/qa/companion_touch_harness.dart`](../../test/qa/companion_touch_harness.dart)

## Coverage

Each flow is exercised under **Android** and **iOS** (`debugDefaultTargetPlatformOverride`).

| Flow | Automated check |
|---|---|
| **Pairing** | Enter email/password → Log in → linked TVs with connection labels |
| **Remote** | Tap D-pad **Up** → command callback + feedback label |
| **Send-to-TV** | Open Explore title → tap **Reproducir en TV** → sent callback; no in-companion video player |

## Notes

- Widget-level touch via `WidgetTester.tap` / `enterText` — phone canvas `390×1600`.
- Theme: `AppTheme.companionLight()` (CMP-003).
- Manual Companion pass in [test_strategy.md](./test_strategy.md) still covers physical devices and offline messaging.
- No Companion video playback in MVP (catalog detail shows the no-player note only).
