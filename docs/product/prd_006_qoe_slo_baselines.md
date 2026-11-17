# PRD-006 — QoE / SLO baselines (interim lock)

**Tracker:** PRD-006 (Done as Release 2 deferral of *definitive* field-based SLOs).  
**Refs:** SRS §24 · NFR-QOE-01…03 · FR-029  
**QA gate:** [qoe_slo_baselines.md](../qa/qoe_slo_baselines.md) (QA-054)

## Human lock (2026-11-17)

Until Release 2 replaces these with beta-derived definitive targets, Product locks the **referential SRS** baselines as the QA-054 source of truth:

| ID | Metric | Global budget (interim) |
|---|---|---|
| **NFR-QOE-01** | Playback **startup** (tune → first frame / playable) | **&lt; 3 s** |
| **NFR-QOE-02** | Live **channel change** (zap) | **&lt; 1.5 s** |
| **NFR-QOE-03** | **Rebuffer** ratio (rebuffer time ÷ play time) | **&lt; 2%** |

### Scope decisions

1. **SLO source:** Referential SRS targets (not new definitive numbers).
2. **“Field data” for QA-054:** In-repo **lab / synthetic fixtures** are sufficient (no beta CSV required for this gate).
3. **QoE event catalog:** **MVP three only** until Release 2 — startup, channel change, buffering/rebuffer (US-20 / FR-029). Extended catalog (US-R1-10) stays deferred.
4. **Segmentation:** **Global** budgets for now (no per device-tier / network-class split).

### Out of scope until Release 2

- Definitive SLOs derived from beta field aggregates (original PRD-006 intent).
- Per-tier (L/M/H) or Wi‑Fi vs ethernet SLO tables.
- Extended QoE event payloads beyond the MVP three.

Security bar unchanged: anonymous IDs only; no email, tokens, or source credentials in QoE payloads (SEC-C09).
