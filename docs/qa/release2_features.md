# Release 2 features (QA-055)

**Refs:** SRS §23 · Depends on **PRD-033** (provisional AC)  
**Stories:** [`docs/product/prd_033_release2_provisional_ac.md`](../product/prd_033_release2_provisional_ac.md) (US-R2-01…02)  
**Executable suite:** [`test/qa/release2_features_test.dart`](../../test/qa/release2_features_test.dart)

## Goal

Gate Release 2 client surfaces called out for QA-055 — **personalization quality** and **pairing-code security** — against provisional PRD-033 acceptance criteria. Automated checks cover **shipped Design shells** only; API-backed ranking and production pairing hardening stay deferred until discovery / adapters land.

## Coverage map

| QA-055 / story | Automated now | Deferred / manual |
|---|---|---|
| **Personalization quality** (US-R2-01) | `TvPersonalizedHomePage`: Live TV above compact hero; Continue watching + recommendation rows; selection callback | Rec API, ranking quality, editorial rules, diversity metrics |
| **Pairing-code security** (US-R2-02) | Wrong code error omits expected digits; field clears; correct path links; design docs say never logged; shell sources have no `print`/`debugPrint` of the fixture; `PairingSecureData.toString` redacts session secret | Server-issued codes, TTL, rate limits, QR, secure-store of short code, Backend SEC review |

## Notes

- Provisional AC is Product draft pending SRS §18 / §23 discovery lock — do not invent Backend contracts in this suite.
- Design-shell fixtures (e.g. pairing demo code) must never appear in logs or production auth.
- When adapters ship, promote deferred rows into automated checks and keep this matrix current.
