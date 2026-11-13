import 'oem_compatibility_profile.dart';
import 'oem_device_identity.dart';
import 'oem_profile_catalog.dart';
import 'tv_remote_key_mapper.dart';

/// Facade over OEM profile + remote key map (TV-011).
///
/// Presentation and player code should depend on this type (or its pieces),
/// not on raw `Build.MANUFACTURER` strings.
final class OemCompatibility {
  OemCompatibility._({
    required this.identity,
    required this.profile,
    required this.keyMapper,
  });

  factory OemCompatibility.forIdentity(OemDeviceIdentity identity) {
    final profile = OemProfileCatalog.resolve(identity);
    return OemCompatibility._(
      identity: identity,
      profile: profile,
      keyMapper: TvRemoteKeyMapper(quirks: profile.quirks),
    );
  }

  /// Test / Companion default — mid-range unknown profile.
  factory OemCompatibility.unknown() {
    return OemCompatibility.forIdentity(OemDeviceIdentity.unknown);
  }

  final OemDeviceIdentity identity;
  final OemCompatibilityProfile profile;
  final TvRemoteKeyMapper keyMapper;
}
