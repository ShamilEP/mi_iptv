import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/oem/android_oem_device_identity_reader.dart';
import 'package:mi_iptv/core/oem/oem_compatibility.dart';
import 'package:mi_iptv/core/oem/oem_decoder_capabilities.dart';
import 'package:mi_iptv/core/oem/oem_device_identity.dart';
import 'package:mi_iptv/core/oem/oem_display_mode.dart';
import 'package:mi_iptv/core/oem/oem_manufacturer.dart';
import 'package:mi_iptv/core/oem/oem_profile_catalog.dart';
import 'package:mi_iptv/core/oem/oem_quirk.dart';
import 'package:mi_iptv/core/oem/tv_remote_action.dart';
import 'package:mi_iptv/core/oem/tv_remote_key_mapper.dart';

void main() {
  group('TV-011 OEM compatibility', () {
    test('parses manufacturers from Build-style strings', () {
      expect(OemManufacturerParser.parse('Sony'), OemManufacturer.sony);
      expect(OemManufacturerParser.parse('TCL'), OemManufacturer.tcl);
      expect(OemManufacturerParser.parse('Hisense'), OemManufacturer.hisense);
      expect(OemManufacturerParser.parse('NVIDIA'), OemManufacturer.nvidia);
      expect(OemManufacturerParser.parse('Google'), OemManufacturer.google);
      expect(OemManufacturerParser.parse('acme'), OemManufacturer.unknown);
    });

    test('catalog maps OEM groups to decoder, display, and quirks', () {
      final sony = OemProfileCatalog.resolve(
        const OemDeviceIdentity(manufacturer: OemManufacturer.sony),
      );
      expect(sony.decoder.maxWidth, 1920);
      expect(sony.displayMode, OemDisplayMode.fullHd60);
      expect(sony.hasQuirk(OemQuirk.pageKeysAsChannel), isTrue);
      expect(sony.hasQuirk(OemQuirk.debounceDuplicateBack), isTrue);

      final nvidia = OemProfileCatalog.resolve(
        const OemDeviceIdentity(manufacturer: OemManufacturer.nvidia),
      );
      expect(nvidia.decoder, OemDecoderCapabilities.premium);
      expect(nvidia.displayMode, OemDisplayMode.uhd60);

      final stick = OemProfileCatalog.resolve(
        const OemDeviceIdentity(
          manufacturer: OemManufacturer.google,
          model: 'Chromecast HD',
        ),
      );
      expect(stick.decoder, OemDecoderCapabilities.lowMemory);
      expect(stick.hasQuirk(OemQuirk.prefer1080pCeiling), isTrue);
    });

    test('key mapper always maps CH+/CH− and OEM page aliases when quirked', () {
      const base = TvRemoteKeyMapper();
      expect(
        base.actionFor(LogicalKeyboardKey.channelUp),
        TvRemoteAction.channelUp,
      );
      expect(
        base.actionFor(LogicalKeyboardKey.channelDown),
        TvRemoteAction.channelDown,
      );
      expect(base.actionFor(LogicalKeyboardKey.pageUp), isNull);

      const oem = TvRemoteKeyMapper(quirks: {OemQuirk.pageKeysAsChannel});
      expect(oem.actionFor(LogicalKeyboardKey.pageUp), TvRemoteAction.channelUp);
      expect(
        oem.actionFor(LogicalKeyboardKey.pageDown),
        TvRemoteAction.channelDown,
      );
      expect(
        oem.actionFor(LogicalKeyboardKey.mediaTrackNext),
        TvRemoteAction.channelUp,
      );
    });

    test('OemCompatibility facade wires profile quirks into key mapper', () {
      final compat = OemCompatibility.forIdentity(
        const OemDeviceIdentity(manufacturer: OemManufacturer.tcl),
      );
      expect(compat.profile.manufacturer, OemManufacturer.tcl);
      expect(
        compat.keyMapper.actionFor(LogicalKeyboardKey.pageUp),
        TvRemoteAction.channelUp,
      );
    });

    test('Android identity reader maps MethodChannel payload', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const channel = MethodChannel(AndroidOemDeviceIdentityReader.methodName);
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'getDeviceIdentity');
        return <String, Object?>{
          'manufacturer': 'Sony',
          'model': 'Bravia',
          'apiLevel': 34,
        };
      });

      final identity = await AndroidOemDeviceIdentityReader().read();
      expect(identity.manufacturer, OemManufacturer.sony);
      expect(identity.model, 'Bravia');
      expect(identity.apiLevel, 34);
    });
  });
}
