# CMP-008 — Companion localization

**Refs:** NFR-012 · PRD-012 · Depends on **CMP-002**  
**Locales (locked):** EN, ES, zh-CN, FR

## Goal

Externalize Companion UI strings and apply locale-aware date / number formats. Shared core is reusable by **TV-014**.

## Layout

| Piece | Location |
|---|---|
| Locale enum | [`AppLocale`](../../lib/core/l10n/app_locale.dart) |
| String keys | [`AppStringKey`](../../lib/core/l10n/app_string_key.dart) |
| Catalog | [`AppStringCatalog`](../../lib/core/l10n/app_string_catalog.dart) + `translations/` |
| Formats | [`LocaleFormats`](../../lib/core/l10n/locale_formats.dart) |
| Controller | [`LocaleController`](../../lib/core/l10n/locale_controller.dart) (persists via `LocalMediaStore`) |
| Scope | [`AppLocaleScope`](../../lib/core/l10n/app_locale_scope.dart) on Companion `MiIptvApp` |
| Language UI | [`CompanionLanguagePage`](../../lib/features/settings/presentation/companion/companion_language_page.dart) → `/companion/language` |

## Packages

No new pubspec dependency for MVP setup. Hand-rolled catalogs avoid silent `flutter_localizations` / `intl` installs.

**Proposed later (needs approval):** `flutter_localizations` (SDK) + `intl` + `generate: true` / ARB codegen for Material chrome and ICU formatting.

## Behavior

- Companion `MaterialApp.locale` follows `LocaleController`.
- Explore copy resolves through the catalog when `AppLocaleScope` is present.
- Language page previews date + decimal formats per locale.
