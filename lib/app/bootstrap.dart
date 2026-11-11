import 'package:flutter/widgets.dart';

import 'app.dart';
import 'client_kind.dart';
import 'di/app_dependencies.dart';

/// Composition root. Wire DI / adapters here once packages are approved.
Future<void> bootstrap({ClientKind clientKind = ClientKind.tv}) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDependencies.mount(AppDependencies(clientKind: clientKind));
  runApp(MiIptvApp(clientKind: clientKind));
}
