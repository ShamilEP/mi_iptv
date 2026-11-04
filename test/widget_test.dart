import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';

void main() {
  testWidgets('TV home placeholder renders brand lockup', (tester) async {
    await tester.pumpWidget(const MiIptvApp());
    expect(find.text('iptv'), findsOneWidget);
    expect(find.text('Continue watching'), findsOneWidget);
  });
}
