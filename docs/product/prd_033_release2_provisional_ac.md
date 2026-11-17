# Release 2 provisional AC (PRD-033 handoff)

**Status:** **Product draft pending lock** against external SRS §18 / §23 discovery.  
**Tracker:** PRD-033 (Done as “discovery brief remains Release 2”; this handoff completes provisional AC for QA-055 without reopening that row).  
**Scope (PRD-033 details):** Personalization quality and pairing-code security.

This document is **not** a substitute for the locked Release 2 discovery brief. Criteria below are provisional so Design shells (**DSN-070**, **DSN-071**) and QA-055 can map automated vs deferred checks. Do **not** treat shell fixtures (e.g. demo pairing code `482913`) as production secrets.

Language: **English**. Criteria use Given / When / Then. Story IDs **US-R2-01…** continue after Release 1 **US-R1-…**.

---

## US-R2-01 — Personalized Home quality (shell gate)

**Design:** [home_personalized_tv.md](../design/home_personalized_tv.md)  
**As a** viewer on Android TV, **I want** a personalized Home that keeps Live TV easy to reach and shows recommendation rows **so that** I can resume and discover without losing the Live TV path.

### Acceptance

```gherkin
Given I open the personalized TV Home shell
When the first viewport settles
Then Live TV remains in the header quick-access rail above the hero
And a compact hero is visible (not a full-bleed stage that displaces Live TV)
And Continue watching appears as a content rail
And at least one recommendation row is visible (e.g. Because you watched… / Recommended for you)
And selecting a recommendation tile invokes the shell selection callback
```

**Notes:** Shell today (`TvPersonalizedHomePage`); no recommendation API / ranking backend. True personalization quality (relevance, diversity, editorial rules) stays deferred until Product locks discovery and adapters land.

---

## US-R2-02 — Pairing-code security (shell gate)

**Design:** [pairing_code.md](../design/pairing_code.md)  
**As a** account holder linking Companion to TV, **I want** pairing codes handled without leaking the expected secret in errors or logs **so that** a wrong guess does not disclose the code.

### Acceptance

```gherkin
Given the Companion pairing-code entry shell with a design-fixture expected code
When I submit a wrong 6-digit code
Then I see a wrong-code error that does not include the expected code digits
And the entry field clears for retry
When I submit the matching 6-digit code
Then the linked success state is shown
And the design fixture is documented as never logged
And PairingSecureData stringification never prints the session secret in clear text
```

**Notes:** Shell today (`TvPairingCodePage` / `CompanionPairingCodePage`); no pairing API, QR, rate limits, or secure-store writes of the short code. Production hardening (entropy, TTL, attempt limits, transport) stays deferred until Backend / SEC discovery locks.

---

## Out of scope until discovery lock

- Recommendation ranking quality metrics and editorial rule engines  
- Pairing crypto, server-issued codes, QR, attempt lockouts  
- Multi-profile personalization per profile  
