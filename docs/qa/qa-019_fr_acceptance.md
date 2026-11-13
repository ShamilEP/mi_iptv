# QA-019 — MVP FR acceptance (FR-centric)

**Refs:** FR-012…016, FR-024, FR-026, FR-028 · Depends on **PRD-030**  
**Product Gherkin:** [user_stories_mvp.md](../product/user_stories_mvp.md)  
**Executable suite:** [`test/qa/fr_acceptance_mvp_test.dart`](../../test/qa/fr_acceptance_mvp_test.dart)

## Goal

Automate acceptance for MVP functional requirements called out for QA-019 — Settings, diagnostics, source management, VOD detail / resume — **keyed by FR id** (not by user-story title). Stories in PRD-030 remain the Gherkin source of truth.

## Coverage matrix

| FR | Story | Area | Automated gate | Status |
|---|---|---|---|---|
| **FR-012** | US-12 | VOD / channel detail sheet | `tv_content_detail_page_test` + FR suite smoke | Automated (shell) |
| **FR-013** | US-13 | Play from start / Resume (≥15%) | `showsResume` unit + detail widget | Automated (UI rule) |
| **FR-014** | US-14 | Player transport + exit | `tv_vod_player_page_test` | Automated (VOD shell) |
| **FR-015** | US-15 | Persist progress (10s / 15% / forceReset) | `PlaybackProgressPolicy` unit + sync conflict | Automated (policy) |
| **FR-016** | US-16 | Simple status + ABR default | error classifier + ABR policy tests | Automated (domain) |
| **FR-024** | US-02 | Source **add/validate** | Onboarding Add source + credential delete | Automated (partial) |
| **FR-024** | — | Source **edit / prioritize / disable / delete** | — | **Deferred → TV-081** ([settings_tv.md](../design/settings_tv.md)) |
| **FR-026** | US-17 | Essential Settings groups | `tv_settings_page_test` + FR suite | Automated (TV shell) |
| **FR-028** | US-19 | Diagnostics screen | — | **Deferred → TV-082** ([settings_tv.md](../design/settings_tv.md)) |

## Notes

- Settings Sources rail shows a **read-only** priority snapshot until TV-081.
- Diagnostics must never show tokens / passwords / Xtream·M3U credentials (SEC rules) when TV-082 lands.
- Companion essential-settings navigation beyond Language is out of this matrix’s automated rows (TV Settings is the MVP FR-026 surface).
