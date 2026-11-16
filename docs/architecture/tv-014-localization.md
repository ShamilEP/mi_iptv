# TV-014 — Android TV localization

**Refs:** NFR-012 · PRD-012 · Depends on **CMP-008** shared `core/l10n`  
**Locales (locked):** EN, ES, zh-CN, FR  
**RTL:** not required in MVP

## Goal

Wire Android TV to the shared localization stack: externalized strings, persisted locale, and locale-aware date / number formats.

## Layout

| Piece | Location |
|---|---|
| Shared core | [`lib/core/l10n/`](../../lib/core/l10n/) (CMP-008) |
| TV app wiring | [`MiIptvApp`](../../lib/app/app.dart) — `AppLocaleScope`, `MaterialApp.locale`, hydrate |
| Settings copy | [`TvSettingsCopy`](../../lib/features/settings/presentation/tv/tv_settings_copy.dart) |
| Language UI | [`TvLanguagePanel`](../../lib/features/settings/presentation/tv/tv_language_panel.dart) in Settings → Language |

## Behavior

- TV `MaterialApp.locale` / `supportedLocales` follow `LocaleController` (same store as Companion).
- Settings shell category labels resolve through `AppStringCatalog`.
- Language category shows EN / ES / zh-CN / FR picker plus date / decimal format samples.
- Progressive migration: remaining TV screens keep English literals until their tasks externalize them.
- No new pubspec packages; hand-rolled catalogs (propose `flutter_localizations` / `intl` later if needed).
