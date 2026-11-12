# Android TV / Google TV device matrix (QA-002)

**Refs:** SRS §1.3, §21, §22 · Depends on **PRD-010**  
**Client:** Flutter TV entry (`lib/main_tv.dart`, Android flavor `tv`)  
**Related:** [test_strategy.md](./test_strategy.md), [tv_distance_legibility.md](./tv_distance_legibility.md), [tv_accessibility.md](./tv_accessibility.md)

## Locked product constraints (PRD-010)

| Constraint | Value |
|---|---|
| Client stack | Flutter (not native Leanback/Compose) |
| Minimum OS / API | **Android 14 / API 34** |
| Target SDK | **Latest** stable Android / Flutter `targetSdk` (see Gradle) |
| Lowest hardware class | ~**5-year-old** living-room TV / stick class (performance envelope) |
| Gradle (TV-001) | `tv` flavor `minSdk = 34`; `targetSdk` / `compileSdk` = `flutter.*SdkVersion` ([ADR-002](../architecture/adr-002-tv-toolkit-sdk.md)) |

**Lab implication:** Every physical or virtual device used for MVP TV certification must run **API 34+**. “5-year-old tier” describes **RAM/SoC/thermal class**, not permission to ship on older OS versions.

---

## Tier definitions

| Tier | Role in MVP | RAM (typical) | Resolution under test | Must cover before MVP close |
|---|---|---|---|---|
| **L — Low-memory stick** | Worst-case QoE, focus jank, image cache pressure | ≤ 2 GB | 1080p | ≥ 1 device or certified AVD profile |
| **M — Mid-range TV / box** | Primary manual + beta path | 2–3 GB | 1080p (4K optional) | **≥ 1 secured physical device** (DoD) |
| **H — High-end** | 4K / higher SoC smoke | ≥ 4 GB | 1080p + 4K where available | ≥ 1 before Release 1 preferred; optional for MVP exit |

---

## Manufacturer / platform coverage

Select at least one device from **each OEM group** across the program (MVP may share a single mid-range unit; Sprint 0 defines the matrix).

| Group | Example platforms (API 34+ Google TV / Android TV) | Notes |
|---|---|---|
| Google reference | Chromecast with Google TV (4K or HD), Google TV Streamer | Stick / dongle class; HD SKU ≈ low-memory |
| Sony | Bravia Google TV (recent OS update to 14+) | Panel OEM; remote + HDMI-CEC behaviors |
| TCL / Hisense | Google TV smart TVs | High volume retail; verify OEM skin overlays |
| NVIDIA | Shield TV / Shield TV Pro (OS ≥ 14 when available) | High-end box; strong decode path |
| Amazon (only if Google TV / Play path applies) | N/A for pure Fire OS | **Out of MVP matrix** unless Product adds Fire later |
| Emulator | Android TV AVD, API 34, 1080p | Mandatory for local/CI-adjacent manual smoke when hardware missing |

---

## SoC / decode class (for inventory tags)

Tag each lab device with SoC family when known:

| Class | Example SoCs | Test emphasis |
|---|---|---|
| Stick / entry | Amlogic S905x variants, low MediaTek | ABR stress, memory, thermal throttle |
| Mid TV | Mid MediaTek / Amlogic TV SKUs | Channel change, Live + VOD dual paths |
| Premium | Higher Amlogic / NVIDIA Tegra | 4K, multi-audio, DRM ClearKey + Widevine L3 |

DRM schemes for player work remain **ClearKey + Widevine L3** (PRD-003 clarification).

---

## Resolution & display

| Resolution | Priority | When |
|---|---|---|
| **1920×1080** | **P0** | All MVP TV certification; overscan + focus distance (2–3 m) |
| 3840×2160 | P1 | At least one H-tier smoke before Release 1 |
| 1280×720 | P2 | Only if a lab stick forces it; not a ship target |

Design / widget tests continue to assume **1080p** logical canvas for TV.

---

## Android TV OS versions

| API | Codename | Matrix role |
|---|---|---|
| **34** | Android 14 | **Minimum** — required on all cert devices |
| 35+ | Android 15+ | Target / forward smoke when Flutter `targetSdk` moves |

Do **not** schedule API &lt; 34 devices for MVP TV certification.

---

## Recommended Sprint 0 / MVP lab set

| ID | Tier | Candidate | Manufacturer | SoC class | Res | OS | Status |
|---|---|---|---|---|---|---|---|
| TV-L1 | L | Chromecast with Google TV (HD) or equivalent ≤2 GB stick on API 34+ | Google | Stick | 1080p | API 34+ | **To procure / assign** |
| TV-M1 | M | Chromecast with Google TV (4K) **or** mid Bravia / TCL Google TV | Google / Sony / TCL | Mid | 1080p | API 34+ | **Must secure before MVP close** |
| TV-H1 | H | Shield TV Pro or premium Bravia | NVIDIA / Sony | Premium | 1080p/4K | API 34+ | Optional MVP; recommended R1 |
| TV-E1 | L/M | Android TV AVD API 34, 1080p, 2 GB | Emulator | — | 1080p | API 34 | Available locally |

Update the **Status** column in this table when hardware is checked out (owner + serial / AVD name). Do not store account passwords or Widevine device keys in this repo.

---

## Procurement / ownership checklist (human)

- [ ] Assign a QA owner for the matrix inventory.
- [ ] **Secure ≥ 1 mid-range physical device (TV-M1)** before MVP close.
- [ ] Secure or emulate ≥ 1 low-memory stick-class profile (TV-L1 or TV-E1 with 2 GB).
- [ ] Record device model, serial (internally), API level, RAM, and SoC in the team inventory (not in git if serials are sensitive).
- [ ] Confirm Play services / Google TV channel available for sideload or internal track installs.
- [x] TV-001 landed exact `minSdk` / `targetSdk` in Gradle (`tv` minSdk 34; target/compile via Flutter toolchain — ADR-002).

---

## Test mapping

| Concern | Matrix tier | Primary docs / suites |
|---|---|---|
| Focus / D-pad / overscan | M (+ L) | Widget tests; [tv_accessibility.md](./tv_accessibility.md) |
| 2–3 m legibility | M on 1080p panel | [tv_distance_legibility.md](./tv_distance_legibility.md) |
| Memory / image cache | L | Manual soak on stick |
| Live TV channel change QoE | M | Manual + future device tests |
| DRM smoke (ClearKey / WV L3) | M or H | Player tasks (TV-050+) on physical device |
| 4K | H | Release 1 preference |

---

## Out of scope for this matrix

- Companion phone/tablet matrix (separate QA task when scheduled).
- Fire OS–only devices.
- API &lt; 34 Android TV units for MVP certification.
- Backend/device-farm procurement budgets (Infra / Product).
