import 'package:flutter/widgets.dart';

import 'app.dart';
import 'client_kind.dart';

/// Composition root. Wire DI / adapters here once packages are approved.
Future<void> bootstrap({ClientKind clientKind = ClientKind.tv}) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MiIptvApp(clientKind: clientKind));
}
