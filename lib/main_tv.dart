import 'app/bootstrap.dart';
import 'app/client_kind.dart';

/// Android TV / Google TV entrypoint (PRD-010 / PRD-011).
Future<void> main() => bootstrap(clientKind: ClientKind.tv);
