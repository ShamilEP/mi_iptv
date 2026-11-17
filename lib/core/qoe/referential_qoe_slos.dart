/// Interim global QoE budgets from PRD-006 referential SRS targets (NFR-QOE-01…03).
///
/// Definitive beta-derived SLOs remain Release 2. Do not invent per-tier splits here.
abstract final class ReferentialQoeSlos {
  /// NFR-QOE-01 — tune → first playable frame.
  static const Duration maxStartup = Duration(seconds: 3);

  /// NFR-QOE-02 — live channel zap.
  static const Duration maxChannelChange = Duration(milliseconds: 1500);

  /// NFR-QOE-03 — rebuffer_time / play_time (strictly less than 2%).
  static const double maxRebufferRatio = 0.02;
}
