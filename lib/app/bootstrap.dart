import 'package:flutter/widgets.dart';

import 'app.dart';

/// Composition root. Wire DI / adapters here once packages are approved.
Future<void> bootstrap({bool useCompanionTheme = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MiIptvApp(useCompanionTheme: useCompanionTheme));
}
