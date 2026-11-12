/// Linked-TV pairing secrets for Companion (CMP-005 / SEC-022).
///
/// Persist only via secure storage. Never log [sessionSecret].
final class PairingSecureData {
  const PairingSecureData({
    required this.linkedTvDeviceId,
    required this.sessionSecret,
  });

  final String linkedTvDeviceId;
  final String sessionSecret;

  /// Redacted — safe for accidental logging / debug dumps (SEC-022).
  @override
  String toString() =>
      'PairingSecureData(linkedTvDeviceId: $linkedTvDeviceId, sessionSecret: ***)';
}
