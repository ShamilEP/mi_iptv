import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/transport_security_policy.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/cleartext_media_notice.dart';

void main() {
  testWidgets('SEC-023 CleartextMediaNotice shows policy warning', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const Scaffold(body: CleartextMediaNotice()),
      ),
    );
    expect(
      find.text(TransportSecurityPolicy.cleartextMediaWarning),
      findsOneWidget,
    );
  });
}
