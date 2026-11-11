import 'app/bootstrap.dart';
import 'app/client_kind.dart';

/// Companion (Android + iOS) entrypoint (PRD-011 / CMP-001).
Future<void> main() => bootstrap(clientKind: ClientKind.companion);
