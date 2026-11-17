import 'dart:async';

import '../domain/deep_link_ingress.dart';

/// Test / demo ingress for Companion deep links (CMP-050).
final class MemoryDeepLinkIngress implements DeepLinkIngress {
  MemoryDeepLinkIngress({this.initial});

  /// Consumed once by [initialLink].
  Uri? initial;
  final StreamController<Uri> _controller =
      StreamController<Uri>.broadcast();

  @override
  Future<Uri?> initialLink() async {
    final value = initial;
    initial = null;
    return value;
  }

  @override
  Stream<Uri> get onLink => _controller.stream;

  void emit(Uri uri) {
    if (!_controller.isClosed) {
      _controller.add(uri);
    }
  }

  Future<void> dispose() => _controller.close();
}
