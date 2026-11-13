import 'package:flutter/services.dart';

import 'oem_device_identity.dart';
import 'oem_device_identity_reader.dart';

/// Android `Build.*` fingerprint via MethodChannel (TV-011).
///
/// No pub.dev device_info package — same Option A pattern as Media3.
final class AndroidOemDeviceIdentityReader implements OemDeviceIdentityReader {
  AndroidOemDeviceIdentityReader({
    MethodChannel? methodChannel,
  }) : _methods = methodChannel ??
            const MethodChannel('com.example.mi_iptv/oem_compatibility');

  static const String methodName = 'com.example.mi_iptv/oem_compatibility';

  final MethodChannel _methods;

  @override
  Future<OemDeviceIdentity> read() async {
    try {
      final raw = await _methods.invokeMethod<dynamic>('getDeviceIdentity');
      if (raw is! Map) return OemDeviceIdentity.unknown;
      final map = raw.cast<Object?, Object?>();
      return OemDeviceIdentity.fromHost(
        manufacturer: map['manufacturer'] as String?,
        model: map['model'] as String?,
        apiLevel: map['apiLevel'] as int?,
      );
    } on PlatformException {
      return OemDeviceIdentity.unknown;
    } on MissingPluginException {
      return OemDeviceIdentity.unknown;
    }
  }
}
