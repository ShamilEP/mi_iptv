# Localization (QA-040)

**Refs:** NFR-012 · PRD-012 · Depends on **TV-014** (shared stack from **CMP-008**)  
**Executable suite:** [`test/qa/localization_test.dart`](../../test/qa/localization_test.dart)  
**Architecture:** [tv-014-localization.md](../architecture/tv-014-localization.md), [cmp-008-companion-localization.md](../architecture/cmp-008-companion-localization.md)

## Goal

Prove MVP localization does not break layouts when strings grow (translations / long titles), and that date / number **locale formats** stay correct for the locked locales.

## Locked locales

EN · ES · zh-CN · FR (RTL not in MVP).

## Coverage

| Scenario | Automated check |
|---|---|
| **Catalog completeness** | Every `AppStringKey` resolves to a non-empty string for all four locales (no bare key-name fallback) |
| **Locale formats** | `LocaleFormats` date + decimal samples match regional separators for EN / ES / zh-CN / FR |
| **Format surfaces** | TV Language panel + Companion Language page show matching date / number samples per locale |
| **String overflow** | Long catalog / adversarial titles in constrained `ContentCard` + `MiButton` use ellipsis and produce **no** RenderFlex / layout overflow |

## Notes

- Widget / unit level — no device farm or screenshot farm required for this gate.
- Progressive migration: screens still on English literals are out of scope until their feature tasks externalize copy; this suite gates the shared catalog + chrome that already bind to `AppStringCatalog` / `LocaleFormats`.
- Manual TV pass still recommended once: switch Language in Settings across EN → FR → zh-CN and spot-check Home rails for clipped titles (see [test_strategy.md](./test_strategy.md)).
