import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-010 docs lock icons, permissions, privacy, demo account', () {
    final arch =
        File('docs/architecture/cmp-010-companion-store-readiness.md')
            .readAsStringSync();
    expect(arch, contains('CMP-010'));
    expect(arch, contains('DSN-005'));
    expect(arch, contains('PRD-042'));
    expect(arch, contains('INTERNET'));
    expect(arch, contains('privacy'));
    expect(arch, contains('demo'));

    final privacy =
        File('docs/qa/companion_store_privacy_checklist.md').readAsStringSync();
    expect(privacy, contains('Data Safety'));
    expect(privacy, contains('ATT'));

    final account = File('docs/qa/store_review_account.md').readAsStringSync();
    expect(account, contains('Never commit'));
    expect(account, contains('staging'));
  });
}
