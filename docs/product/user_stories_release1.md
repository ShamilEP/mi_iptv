# Release 1 user stories (PRD-032) — provisional

**Status:** **Product draft pending lock** against external SRS §18 / §23.  
**Tracker:** PRD-032 (Done as planning deferral; this handoff completes the deferred AC writing without reopening that row).  
**Scope list (PRD-032):** EPG, multi-profile, parental PIN, history, tolerant search, audio/subtitle selection, deep links, extended QoE, settings sync.

This document is **not** a substitute for the locked SRS. Criteria below are provisional so client Design shells and QA-053 can map automated vs deferred checks. Where only a design shell exists today, Notes call that out. Do **not** treat shell fixtures (e.g. demo PIN `1234`) as production security.

Language: **English**. Criteria use Given / When / Then. Story IDs **US-R1-01…** continue after MVP **US-01…US-24** ([user_stories_mvp.md](./user_stories_mvp.md)).

MVP remains **one profile per account** until multi-profile (US-R1-04) ships.

---

## US-R1-01 — EPG browse and channel matching

**Design:** [epg_grid_tv.md](../design/epg_grid_tv.md)  
**As a** viewer on Android TV, **I want** a channel × time guide that matches programmes to my live channels **so that** I can see what’s on now and next.

### Acceptance

```gherkin
Given I have live channels in my catalog with EPG data available
When I open the TV Guide / EPG
Then I see a channel × time grid with a visible Now indicator on the current programme
And programme blocks align to channels that match my catalog (id / name mapping)
And D-pad moves focus block-to-block and restores last programme focus after rebuild
And opening a focused programme shows title and time detail
```

**Notes:** Shell today (`TvEpgGridPage`); no EPG / schedule API. Matching accuracy becomes testable when a schedule adapter lands.

---

## US-R1-02 — EPG time zones and DST

**As a** viewer who travels or whose provider uses another offset, **I want** guide times shown in a consistent local zone with correct DST transitions **so that** “Now” stays accurate.

### Acceptance

```gherkin
Given EPG events are stored with unambiguous UTC (or offset) timestamps
When I view the guide in my selected local time zone
Then programme start/end labels convert to local wall time
And across a DST spring-forward or fall-back boundary, “Now” still highlights the correct current event
And channel rows do not shift programmes by an hour erroneously
```

**Notes:** No client TZ/DST EPG logic yet — provisional AC for Product lock + future adapter tests.

---

## US-R1-03 — Large XMLTV ingest resilience

**As** the system, **I want** large XMLTV payloads to import without freezing the TV UI **so that** households with big guides remain usable.

### Acceptance

```gherkin
Given an XMLTV source larger than a typical small guide (multi-day, many channels)
When the client ingests or refreshes the guide
Then parsing / apply happens off the UI isolate or in bounded chunks
And the Guide remains interactive (focus moves) during refresh
And a failure surfaces a recoverable error without wiping the last good guide cache
```

**Notes:** No XMLTV parser in this repo yet — provisional AC; Backend/catalog contract TBD at Product lock.

---

## US-R1-04 — Multi-profile picker and management

**Design:** [profiles_tv.md](../design/profiles_tv.md)  
**As a** household, **I want** multiple profiles on one account **so that** each person gets their own Continue watching and kids restrictions.

### Acceptance

```gherkin
Given I am signed in on Android TV
When I open the profile picker
Then I see existing profiles and can select one to continue
And I can add a profile with a name and optional kid-profile flag
And I can edit or remove a non-primary profile
And kid profiles show a Kids badge (not hue alone)
And after selection, Home and playback preferences follow the active profile
```

**Notes:** Shell today (`TvProfilePickerPage`); no profile API / multi-profile sync. MVP one-profile rule lifts when this ships.

---

## US-R1-05 — Parental PIN gate

**Design:** [parental_pin.md](../design/parental_pin.md)  
**As a** parent, **I want** a PIN gate on restricted / kids content **so that** children cannot play locked titles without approval.

### Acceptance

```gherkin
Given the active profile requires a parental PIN for restricted content
When I try to play or open restricted content
Then I see a lock explanation with Enter PIN (and Ask a parent where offered)
And entering the correct PIN unlocks for the session
And a wrong PIN shows an error, clears the entry, and does not unlock
And the PIN is never logged or shown in plain telemetry
```

**Notes:** Shell today (demo PIN fixture only). Durable hashing / storage / Backend verification are Release 1 product + security follow-ups — not this shell.

---

## US-R1-06 — Watch history separate from Continue watching

**Design:** [history_tv.md](../design/history_tv.md)  
**As a** viewer, **I want** a History list I can pause or clear **so that** I control privacy without wiping Home Continue watching mid-session rules.

### Acceptance

```gherkin
Given I have watched titles on this profile
When I open History
Then I see a chronological list separate from Home Continue watching
And I can toggle Save watch history Off and see a warning that Home Continue watching is unchanged
And Clear history empties History without deleting Continue watching progress
And I can open or remove an individual History row
```

**Notes:** Shell today (`TvHistoryPage`); no history API / sync.

---

## US-R1-07 — Tolerant search

**Design:** [search_tv.md](../design/search_tv.md)  
**As a** viewer typing on the TV OSK, **I want** prefix / near-miss suggestions and Did you mean recovery **so that** typos still find titles.

### Acceptance

```gherkin
Given a local catalog of channels and VOD titles
When I type a partial query
Then I see suggestion chips for completions and near spellings
When my query looks like a typo with no exact hits
Then I see a Did you mean recovery I can apply
And results group Channels and VOD when matches exist
```

**Notes:** Local `TolerantSearch` (contains / prefix / small edit distance) — no backend search API in the shell.

---

## US-R1-08 — Manual audio and subtitle track selection

**Design:** [audio_subtitle_selector_tv.md](../design/audio_subtitle_selector_tv.md)  
**MVP baseline:** Auto default tracks remain [TV-057](../architecture/tv-057-default-audio-subtitle.md) / `DefaultTrackPolicy`.  
**As a** viewer, **I want** to pick audio and subtitle tracks during playback **so that** I can override the source default for this session (and later durable prefs).

### Acceptance

```gherkin
Given I am in the VOD (or Live) player with multiple audio/subtitle tracks
When I open Audio & subtitles from transport chrome
Then I see Audio and Subtitles lists with a clear selected cue
And choosing a track applies it for the current session
And Subtitles Off hides captions; choosing a language shows captions with DSN-021 styling
And MVP source-default selection still applies when I have not opened the picker
```

**Notes:** Shell today (`TvTrackSelectorPanel`) — session memory only; no Media3 enumeration / durable prefs yet.

---

## US-R1-09 — Deep links to content and channels

**As a** user, **I want** shared links to open the right title or live channel in the app **so that** I land in detail or playback without hunting.

### Acceptance

```gherkin
Given the app is installed and I am signed in
When I open a supported https deep link for a VOD title or live channel
Then the client routes to the matching detail or Live tune target
And if the content is missing or restricted, I see a clear error or parental gate instead of a blank screen
And unsigned users are prompted to sign in then continue to the target
```

**Notes:** No `app_links` / URI handler in the client yet — provisional AC; OS manifest + routing TBD at Product lock.

---

## US-R1-10 — Extended QoE telemetry

**MVP baseline:** US-20 / FR-029 minimal anonymous QoE.  
**As** the product operator, **I want** extended QoE detail beyond MVP minima **so that** Release 1 field quality can be diagnosed without PII.

### Acceptance

```gherkin
Given QoE collection is enabled for the build
When playback starts, buffers, recovers, or fails
Then the client emits extended QoE events agreed for Release 1 (beyond MVP startup / channel-change / buffer minima)
And payloads use anonymous IDs only — no email, tokens, or source passwords
And retention follows the locked GDPR policy (PRD-004)
```

**Notes:** Product lock 2026-11-17 — **MVP three events only** (startup / channel change / buffering) until Release 2; see [prd_006_qoe_slo_baselines.md](./prd_006_qoe_slo_baselines.md). Security bar stays SEC-C09.

---

## US-R1-11 — Settings sync across devices

**As a** signed-in user with TV and Companion, **I want** selected settings to sync **so that** language and playback prefs follow me across devices.

### Acceptance

```gherkin
Given I change a sync-eligible setting on one device (e.g. UI language or subtitle default)
When sync completes on a second signed-in device for the same account/profile
Then the setting matches within the sync conflict rules (LWW / syncVersion)
And non-sync-eligible or device-local settings are unchanged
And a sync failure leaves the last good local value and a recoverable message
```

**Notes:** Builds on MVP sync; which Settings keys are sync-eligible is a Product lock item.

---

## Coverage matrix (PRD-032 scope)

| Topic | Story |
|---|---|
| EPG matching / browse | US-R1-01 |
| EPG time zones / DST | US-R1-02 |
| Large XMLTV | US-R1-03 |
| Multi-profile | US-R1-04 |
| Parental PIN | US-R1-05 |
| History | US-R1-06 |
| Tolerant search | US-R1-07 |
| Audio / subtitle selection | US-R1-08 |
| Deep links | US-R1-09 |
| Extended QoE | US-R1-10 |
| Settings sync | US-R1-11 |

---

## Open follow-ups (block Product lock, not story shape)

- Concrete EPG matching keys (channel id vs display-name fallback).
- XMLTV size budgets and Backend vs on-device parse split.
- Profile caps, kid rating model, PIN storage/hashing (Security).
- Deep link URL scheme and auth resume contract.
- Extended QoE event catalog.
- Settings sync allow-list.
