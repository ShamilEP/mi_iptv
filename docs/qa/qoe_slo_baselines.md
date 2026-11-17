# Extended QoE / SLO baselines (QA-054)

**Refs:** FR-029 · NFR-QOE-01…03 · Depends on **PRD-006** (interim lock)  
**Product lock:** [prd_006_qoe_slo_baselines.md](../product/prd_006_qoe_slo_baselines.md)  
**Executable suite:** [`test/qa/qoe_slo_baselines_test.dart`](../../test/qa/qoe_slo_baselines_test.dart)  
**Code:** [`lib/core/qoe/`](../../lib/core/qoe/)

## Goal

Compare **lab / synthetic** QoE session samples against the interim **global** referential SLOs locked for PRD-006 until Release 2 definitive targets land.

## Budgets (global)

| Metric | Budget |
|---|---|
| Startup | &lt; 3 s |
| Channel change | &lt; 1.5 s |
| Rebuffer ratio | &lt; 2% |

## Coverage

| Check | Automated |
|---|---|
| Budget constants match Product lock | `ReferentialQoeSlos` unit asserts |
| Passing lab fixtures meet all three SLOs | `QoeSloEvaluator` over fixture set |
| Failing fixtures are detected per metric | Startup / zap / rebuffer breach samples |
| Event scope | MVP trio only (startup, zap, rebuffer) — extended catalog deferred |

## Notes

- No real beta CSV required for this gate (Product decision 2026-11-17).
- Anonymous IDs only when live emission lands (SEC-C09); fixtures carry no credentials.
- Release 2: replace referential budgets + add field aggregates without changing the evaluator API shape if possible.
