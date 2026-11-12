import 'package:flutter/widgets.dart';

import 'app.dart';
import 'app_environment.dart';
import 'client_kind.dart';
import 'di/app_dependencies.dart';

/// Composition root. Wire DI / adapters here once packages are approved.
Future<void> bootstrap({
  ClientKind clientKind = ClientKind.tv,
  AppEnvironment? environment,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final resolvedEnv = environment ?? AppEnvironment.fromDartDefine();
  AppDependencies.mount(
    AppDependencies(clientKind: clientKind, environment: resolvedEnv),
  );
  runApp(MiIptvApp(clientKind: clientKind));
}
