# MVP user stories (PRD-030)

**Source of truth:** `Mi_IPTV_Media_Center_SRS_v2.0_MVP.docx` (SRS §10 / §10.1).  
**Locked Product decisions** applied here: PRD-012…014, PRD-002, PRD-013, PRD-021…027, PRD-003 (ClearKey + Widevine L3), GDPR retention (PRD-004).

SRS §10 requires every **MVP** FR to have at least one story with Gherkin acceptance criteria.  
**US-01…US-08** already exist in the SRS (summarized below). **US-09…US-24** close the previously uncovered MVP FRs listed in PRD-030.

Language of this handoff: **English** (repo harness). Criteria use Given / When / Then.

### Open follow-up (does not block story shape)

- **MVP country list values** for FR-002 / US-09: Product chose a **country list** model; the concrete ISO country set is still to be enumerated (ask Product before shipping onboarding copy).

---

## Already in SRS (§10.1)

| ID | Covers (primary) | Title |
|---|---|---|
| US-01 | FR-001, FR-031 | Register and first sign-in |
| US-02 | FR-024 (add/validate) | Add IPTV source (M3U/Xtream) |
| US-03 | FR-006, FR-007, FR-008 | Live TV playback and channel change |
| US-04 | FR-009 | Recover from stream failure |
| US-05 | FR-003 | Continue watching from Home |
| US-06 | FR-020 | Favorite / unfavorite |
| US-07 | FR-018 | Basic search |
| US-08 | FR-035, FR-036 | Pair companion and use as remote (&lt;1s) |

Full Gherkin for US-01…08 remains in the SRS document.

---

## US-09 — Onboarding language, region, playback prefs, initial profile

**FR:** FR-002  
**As a** newly signed-in user, **I want** to choose language, country, basic playback defaults, and my initial profile **so that** the TV experience matches my household from the first session.

### Acceptance

```gherkin
Given I completed account creation and landed in onboarding
When I select a UI language from EN, ES, zh-CN, FR
And I select a country from the MVP country list
And I set playback defaults: default audio language, subtitles Off, autoplay next Off
And I confirm my initial profile name
Then the choices are stored for the account/profile
And subsequent TV screens use the selected language
And subtitles stay Off and autoplay-next stays Off until I change them later in Settings
```

**Notes:** MVP is one profile per account; “initial profile” is that single profile. Country list **values** TBD (see open follow-up).

---

## US-10 — Home basic content rows

**FR:** FR-004  
**As a** viewer on Home, **I want** basic content rows/carousels by type, source, or genre **so that** I can browse without Release-2 personalization.

### Acceptance

```gherkin
Given I am on TV Home with a populated catalog
When the Home finishes loading
Then I see at least one horizontal content row beyond Continue watching
And rows are grouped by a basic rule (content type, source, or genre)
And I can move focus along a row and between rows with the D-pad
And advanced editorial/personalized ranking is not required in MVP
```

---

## US-11 — Home quick access

**FR:** FR-005  
**As a** viewer, **I want** quick access to Live TV, Favorites, Search, and Settings from Home **so that** primary destinations are one focus path away.

### Acceptance

```gherkin
Given I am on TV Home
When I move focus to the quick-access controls
Then I can open Live TV, Favorites, Search, and Settings
And Guide/EPG is not required in the MVP quick-access set (Release 1)
And Live TV remains reachable without being displaced by a full-bleed hero
```

---

## US-12 — Content detail sheet

**FR:** FR-012 (series UI deferred — PRD-013)  
**As a** viewer, **I want** a content detail sheet with title, synopsis, art, metadata, duration, and actions **so that** I can decide what to play.

### Acceptance

```gherkin
Given I open a VOD (or channel) detail from Home, Search, or Favorites
When the detail screen loads
Then I see title, synopsis, art, metadata, and duration when the catalog provides them
And I see primary actions including Play and Favorite (and Resume when progress exists)
And season/episode navigation is not shown in MVP (series UI deferred)
```

---

## US-13 — Play from start or resume

**FR:** FR-013  
**As a** viewer on a detail sheet, **I want** to play from the beginning or resume from the saved position **so that** I control how playback starts.

### Acceptance

```gherkin
Given a title has no saved progress
When I choose Play
Then playback starts at position 0

Given a title has recoverable progress (≥15% and not force-reset)
When I choose Resume
Then playback starts near the saved position
And I can still choose Play to start from the beginning
```

---

## US-14 — Player transport controls

**FR:** FR-014  
**As a** viewer in the player, **I want** pause, play, seek, skip forward/back, volume/mute, and exit **so that** I can control playback with the remote.

### Acceptance

```gherkin
Given I am watching Live TV or VOD on the TV client
When I use transport controls (or companion remote equivalents)
Then I can pause, play, seek where the stream type allows, skip forward/back on VOD, change volume or mute, and exit playback
And exiting does not lose the selected channel or title context unexpectedly
```

---

## US-15 — Persist and sync playback progress

**FR:** FR-015  
**As a** multi-device user, **I want** progress saved on fixed product rules and synced to the backend **so that** Continue watching stays accurate.

### Acceptance

```gherkin
Given I am playing VOD
When playback advances
Then the client persists progress on a fixed 10s save interval (not user-editable in MVP)
And progress syncs to the backend with clientEventId when online
And a title appears in Continue watching only after progress reaches 15% of duration
And forceReset removes the title from Continue watching and resets position to 0
And save interval / CW threshold are product constants, not Settings toggles, in MVP
```

---

## US-16 — Buffering, reconnect, and quality

**FR:** FR-016  
**As a** viewer, **I want** buffering and reconnect handled simply, with automatic ABR by default and an optional manual quality picker **so that** I am not exposed to technical complexity.

### Acceptance

```gherkin
Given a stream is buffering or briefly disconnects
When the player recovers
Then I see a simple status (not raw error codes) and playback resumes when possible

Given I open the quality control
When I leave quality on Automatic
Then the player uses ABR

When I pick a manual quality rung
Then the player uses that rung until I return to Automatic or leave playback
And DRM-protected streams use ClearKey and/or Widevine L3 as applicable (PRD-003)
```

---

## US-17 — Essential settings

**FR:** FR-026  
**As an** account owner, **I want** essential settings for account, sources, network, language, and playback **so that** I can manage the MVP without Release-1 advanced UI/privacy screens.

### Acceptance

```gherkin
Given I open Settings on TV or Companion
When I browse settings groups
Then I can reach Account, Sources, Network, Language, and Playback
And Network shows connection status with a Wi-Fi or Ethernet label and a bandwidth-limit control
And advanced interface/privacy expansions are not required in MVP (Release 1)
```

---

## US-18 — Safe updates of config, catalogs, and components

**FR:** FR-027  
**As a** user, **I want** configuration, catalogs, and components to update without corrupting local or sync data **so that** I do not lose favorites, progress, or sources.

### Acceptance

```gherkin
Given I have local favorites, progress, and configured sources
When any of the following occur: catalog/source refresh, remote config/feature-flag update, or app binary update from the store
Then local durable data remains readable after the update
And sync with the backend can resume without silent data loss
And a failure during update leaves the app in a recoverable state with a clear message
```

---

## US-19 — Basic diagnostics

**FR:** FR-028  
**As a** user or supporter, **I want** a basic diagnostics screen **so that** I can see network, source, latency/buffer, and app version.

### Acceptance

```gherkin
Given I open Diagnostics from Settings
When the screen loads
Then I see network status, active source status, latency/buffer indicators, and app version
And the screen does not display secrets (tokens, passwords, Xtream/M3U credentials)
```

---

## US-20 — Minimal QoE telemetry

**FR:** FR-029 (MVP basic)  
**As** the product operator, **I want** minimal anonymous QoE metrics for startup, channel change, and buffering **so that** we can monitor experience under GDPR retention.

### Acceptance

```gherkin
Given QoE collection is enabled for the build
When the user starts playback, changes channel, or experiences buffering
Then the client emits the corresponding minimal QoE events without email or other PII
And retained QoE data follows the 15-day retention policy (PRD-004)
And expanded QoE detail remains Release 1
```

---

## US-21 — Sign out and password recovery

**FR:** FR-032  
**As an** account owner, **I want** to sign out and recover my password **so that** I can secure the account and regain access.

### Acceptance

```gherkin
Given I am signed in
When I choose Sign out
Then local session tokens are cleared from secure storage and I return to the auth entry screen

Given I am on the auth entry screen
When I start password recovery with a registered email
Then the system accepts the reset request and lets me set a new password via the confirm flow
And after reset I can sign in with the new password
```

---

## US-22 — Deterministic sync conflict resolution

**FR:** FR-034 (SRS §7)  
**As a** multi-device user, **I want** sync conflicts resolved with deterministic rules **so that** data is never dropped silently.

### Acceptance

```gherkin
Given two devices update the same sync entity before converging
When sync runs
Then conflicts resolve with last-write-wins using server time and syncVersion (not device clock)
And for playback progress in a short window, the higher position wins unless forceReset was applied
And the user can be informed via the Sync Conflict UI state without losing the kept value silently
```

---

## US-23 — Companion search and send-to-TV

**FR:** FR-037  
**As a** companion user, **I want** to search and send a title to the TV **so that** video always plays on the TV client in MVP.

### Acceptance

```gherkin
Given the companion is signed in and a TV is connected
When I search and choose Send to TV on a result
Then the command identifies the companion as sender (path device id) and the TV as targetDeviceId
And the TV begins (or queues) playback of that title
And if a second TV session is attempted without a paid multi-device entitlement, it is blocked
And the companion does not play video locally in MVP
```

---

## US-24 — Hybrid sources normalized to one catalog model

**FR:** FR-038  
**As a** user, **I want** M3U/Xtream sources and the proprietary catalog to work independently but appear in one content model **so that** Home, Search, and Player behave consistently.

### Acceptance

```gherkin
Given I have an M3U or Xtream source and/or the proprietary catalog enabled
When catalogs are ingested
Then each source type is handled by its own adapter
And items are normalized to the shared domain content model
And Live TV, VOD rows, Search, and Favorites can present items regardless of origin
And if the live proprietary API is unavailable, the frozen mock contract may be used in development (PRD-002)
```

---

## Coverage matrix (PRD-030 scope)

| MVP FR (previously uncovered) | Story |
|---|---|
| FR-002 | US-09 |
| FR-004 | US-10 |
| FR-005 | US-11 |
| FR-012 | US-12 |
| FR-013 | US-13 |
| FR-014 | US-14 |
| FR-015 | US-15 |
| FR-016 | US-16 |
| FR-026 | US-17 |
| FR-027 | US-18 |
| FR-028 | US-19 |
| FR-029 | US-20 |
| FR-032 | US-21 |
| FR-034 | US-22 |
| FR-037 | US-23 |
| FR-038 | US-24 |

---

## Clarifications applied (human, 2026-11-11)

| Topic | Decision |
|---|---|
| Region model | Country list (concrete countries TBD) |
| Onboarding playback defaults | Default audio language; subtitles **Off**; autoplay next **Off** |
| Progress rules | Fixed product constants (10s / 15% / forceReset→0) — not user-editable in MVP |
| Quality | Automatic ABR default **and** manual quality picker |
| Network settings | Connection status + Wi-Fi/Ethernet label + bandwidth limit |
| FR-027 updates | Catalog refresh **and** remote config/flags **and** app binary update |
