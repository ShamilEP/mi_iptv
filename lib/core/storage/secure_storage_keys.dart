/// Canonical secure-storage keys for Companion (CMP-005) and TV (TV-008).
///
/// Key names are not secret; values are.
abstract final class SecureStorageKeys {
  static const String accessToken = 'auth.access_token';
  static const String refreshToken = 'auth.refresh_token';
  static const String pairingDeviceId = 'pairing.linked_tv_device_id';
  static const String pairingSessionSecret = 'pairing.session_secret';

  /// Per-source credential blob (username / password / token JSON).
  static String sourceCredentials(String sourceId) =>
      'source.credentials.$sourceId';
}
