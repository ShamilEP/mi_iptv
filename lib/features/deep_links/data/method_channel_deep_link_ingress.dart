import 'dart:async';

import 'package:flutter/services.dart';

import '../domain/deep_link_ingress.dart';

/// Android VIEW intent → Dart via MethodChannel (CMP-050).
final class MethodChannelDeepLinkIngress implements DeepLinkIngress {
  MethodChannelDeepLinkIngress({
    MethodChannel? channel,
  }) : _channel = channel ??
            const MethodChannel('com.example.mi_iptv/deep_links') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final MethodChannel _channel;
  final StreamController<Uri> _controller =
      StreamController<Uri>.broadcast();

  @override
  Future<Uri?> initialLink() async {
    final raw = await _channel.invokeMethod<String>('getInitialLink');
    return _parse(raw);
  }

  @override
  Stream<Uri> get onLink => _controller.stream;

  Future<void> dispose() async {
    _channel.setMethodCallHandler(null);
    await _controller.close();
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'onLink') {
      final uri = _parse(call.arguments as String?);
      if (uri != null && !_controller.isClosed) {
        _controller.add(uri);
      }
    }
  }

  Uri? _parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return Uri.tryParse(raw.trim());
  }
}
