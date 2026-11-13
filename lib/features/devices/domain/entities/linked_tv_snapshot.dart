/// Last-known linked TV presence for Companion offline UX (CMP-006 / NFR-011).
///
/// Non-secret — device id + display name + online flag only. Pairing tokens
/// stay in [PairingSecureStore].
final class LinkedTvSnapshot {
  const LinkedTvSnapshot({
    required this.deviceId,
    required this.displayName,
    required this.lastKnownOnline,
    required this.updatedAt,
  });

  final String deviceId;
  final String displayName;
  final bool lastKnownOnline;
  final DateTime updatedAt;
}
