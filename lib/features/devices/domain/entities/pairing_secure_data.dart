/// Linked-TV pairing secrets for Companion (CMP-005).
///
/// Persist only via secure storage. Never log [sessionSecret].
final class PairingSecureData {
  const PairingSecureData({
    required this.linkedTvDeviceId,
    required this.sessionSecret,
  });

  final String linkedTvDeviceId;
  final String sessionSecret;
}
