# DRAFT — User-supplied content, ToS stance & takedowns (SEC-043 / PRD-040)

**Status:** Working draft for Product + counsel review — **not** final Terms of Service.  
**Purpose:** Give engineering a look-alike position (common for media *clients* / playlist aggregators) so Settings, store text, and source UX can keep moving.  
**Authority:** Final ToS, privacy policy URL, and complaint contact remain **Product (PRD-040 / PRD-042)**. Replace placeholders before store submission.

This draft is original summary language inspired by patterns used by media clients that play *user-provided* libraries or playlists (e.g. “you supply the content; we supply the player”). It is **not** copied from any third-party ToS and is **not legal advice**.

---

## 1. Product posture (MVP)

| Topic | Draft position |
|---|---|
| What Mi IPTV is | A **media client** (Android TV + Companion). It plays streams and browses catalogs that the account is entitled to use. |
| User-supplied sources | Users may add **their own** M3U / Xtream (and similar) source configurations. The client does **not** host, proxy, or redistribute those streams as a CDN. |
| Proprietary catalog | Separate from user sources: content/metadata served by Mi IPTV’s backend under Mi IPTV’s licenses. |
| Who is responsible for legality of user sources | The **account holder** is responsible for having the right to use any playlist, credentials, or stream URL they enter. |
| Encouraged practice | Prefer **HTTPS** streams and legitimate providers (see SEC-023 cleartext warning). |
| What we do *not* claim | We do not claim to be a rights-clearing house for third-party IPTV subscriptions the user brings. |

---

## 2. Draft Terms excerpts (engineering-facing)

Use these as **source strings** for an in-app “Legal” / “About” screen and as input to counsel’s full ToS. Wording may change after legal review.

### 2.1 Acceptance

By creating an account or using the apps, you agree to the Mi IPTV Terms of Service and Privacy Policy (URLs: **TBD — PRD-042**).

### 2.2 User-supplied sources and content

1. You may configure third-party or personal media sources (for example M3U playlists or Xtream Codes–compatible endpoints).
2. You represent that you have all rights and licenses needed to access and play content retrieved through those sources.
3. Mi IPTV does not verify the legality of every user-supplied URL or credential and does not upload your private playlists to other users.
4. Source credentials are stored only as needed to operate the client (secure storage / encrypted cache per client security rules) and are never shown in full in the UI or logs.

### 2.3 Prohibited use (high level)

You must not use Mi IPTV to:

- Infringe copyrights or other IP rights;
- Distribute malware or attempt to attack Mi IPTV services or other users;
- Circumvent technical protection measures except where applicable law expressly allows;
- Scrape or abuse Mi IPTV APIs beyond normal client use;
- Misrepresent affiliation with Mi IPTV when reselling access to the apps themselves.

### 2.4 Our content and software

The apps, branding, and any **Mi Catalog** / proprietary metadata remain owned by Mi IPTV or its licensors. User-supplied streams remain under their respective owners’ rights.

### 2.5 Suspension

We may suspend or terminate accounts that abuse the service, violate these Terms, or create legal risk for Mi IPTV (including repeated valid infringement notices tied to account activity).

### 2.6 Disclaimers (short form for MVP)

Service is provided “as is.” Availability of third-party streams depends on those providers. Live TV QoE varies by network and device (see NFR / QA soak docs).

---

## 3. Complaint / takedown process (draft)

Aligned with common “notice and action” flows for platforms that host *some* content and also allow user configuration:

### 3.1 What can be complained about

| Subject | Draft handling |
|---|---|
| Mi Catalog / app UI assets / branding | Notice → review → remove or restrict catalog item / asset if warranted |
| User-supplied source URLs or playlists stored on **our** servers (synced sources) | Notice → review → disable sync of the reported source config for the account / remove server-side copy where applicable |
| Streams that only exist on a third-party host the user typed in | We typically **cannot** take down the remote host; we can disable the saved source on the account and/or suspend the account |
| Companion “send-to-TV” / pairing | Same account-level remedies |

### 3.2 How to submit a notice (placeholder)

Until Product publishes a real channel, engineering should treat contact as **unset**:

| Field | Draft placeholder |
|---|---|
| Channel | Email (preferred) or HTTPS web form |
| Address | `takedown@<PRODUCT-DOMAIN>` — **replace before launch** |
| Postal (if required for store / local law) | **TBD — Product / counsel** |
| Subject line | `Takedown notice — Mi IPTV` |

### 3.3 What a complete notice should include (checklist for Product UI / help center)

1. Contact name, organization, and email of the complainant  
2. Description of the copyrighted work (or other right) claimed infringed  
3. Location in the product (catalog ID, screenshot, account email if known, source label — **never** ask complainants to paste user passwords)  
4. Statement of good-faith belief that use is not authorized  
5. Statement that the information is accurate and (where required) that the sender is authorized to act  
6. Physical or electronic signature (as required by applicable law)

### 3.4 Counter-notice (stub)

If local law requires a counter-notice path for restored material, Product/counsel will add it. MVP engineering only needs a “we received your notice” acknowledgement path on the backend later — out of scope for this draft.

---

## 4. Store / Play TV alignment (SRS §1.3)

| Concern | Draft client stance |
|---|---|
| User-generated / user-configured media | Disclose that users can add their own IPTV sources; Mi IPTV is not the rights owner of those streams |
| Privacy labels | Unchanged: see CMP-010 / QA-052 — no ads tracking in MVP |
| Reviewer notes | Staging account must not rely on pirate demo playlists in git; use licensed or synthetic fixtures |

---

## 5. Engineering hooks (until counsel signs off)

| Hook | Location / plan |
|---|---|
| Draft policy constants | [`UserSuppliedContentPolicy`](../../lib/core/legal/user_supplied_content_policy.dart) |
| Cleartext media warning | SEC-023 `TransportSecurityPolicy` / `CleartextMediaNotice` |
| In-app Legal screen | Future Settings → Account / About — show draft summary + “ToS URL TBD” |
| Server-side notice mailbox | Backend / Infra — not this repo |

Do **not** hardcode a production takedown mailbox until Product replaces the placeholder.

---

## 6. Open decisions for Product (PRD-040)

- [ ] Final ToS + Privacy Policy URLs (with PRD-042)  
- [ ] Real `takedown@…` or web form URL  
- [ ] Whether synced user sources are stored server-side in MVP (affects takedown mechanics)  
- [ ] Jurisdiction / governing law blurb  
- [ ] Whether to show a one-time “I am authorized to use these sources” checkbox when adding M3U/Xtream  

---

## 7. Sign-off

| Role | Name | Date (UTC) | Result |
|---|---|---|---|
| Product | | | ☐ Approved for counsel / ☐ Revise |
| Counsel | | | ☐ Approved for ship / ☐ Revise |
| Engineering | | | Draft for development only |
