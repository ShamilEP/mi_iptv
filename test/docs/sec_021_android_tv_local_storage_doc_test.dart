import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SEC-021 review locks Keystore, Logcat, and backup exclusions', () {
    final doc =
        File('docs/security/android_tv_local_storage_review.md').readAsStringSync();
    expect(doc, contains('SEC-021'));
    expect(doc, contains('Keystore'));
    expect(doc, contains('SecretRedactor'));
    expect(doc, contains('allowBackup'));
    expect(doc, contains('data_extraction_rules'));
    expect(doc, contains('FlutterSecureStorage'));
  });

  test('Android manifest disables backup and points at exclusion XMLs', () {
    final manifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(manifest, contains('android:allowBackup="false"'));
    expect(manifest, contains('@xml/backup_rules'));
    expect(manifest, contains('@xml/data_extraction_rules'));
  });

  test('backup XML excludes FlutterSecureStorage prefs', () {
    final backup =
        File('android/app/src/main/res/xml/backup_rules.xml').readAsStringSync();
    final extraction = File(
      'android/app/src/main/res/xml/data_extraction_rules.xml',
    ).readAsStringSync();
    expect(backup, contains('FlutterSecureStorage'));
    expect(extraction, contains('FlutterSecureStorage'));
    expect(extraction, contains('cloud-backup'));
    expect(extraction, contains('device-transfer'));
  });

  test('secure storage adapter documents Keystore cipher path', () {
    final adapter = File(
      'lib/core/storage/flutter_secure_storage_adapter.dart',
    ).readAsStringSync();
    expect(adapter, contains('Android Keystore'));
    expect(adapter, contains('AES_GCM_NoPadding'));
    expect(adapter, contains('RSA_ECB_OAEPwithSHA_256andMGF1Padding'));
  });
}
