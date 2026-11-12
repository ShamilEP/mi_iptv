import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/data/adapters/media3_player_adapter.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const methodName = 'com.example.mi_iptv/media3_player';
  const eventName = 'com.example.mi_iptv/media3_player_events';

  late List<MethodCall> calls;
  late StreamController<Map<String, Object?>> events;

  setUp(() {
    calls = <MethodCall>[];
    events = StreamController<Map<String, Object?>>.broadcast();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel(methodName),
      (call) async {
        calls.add(call);
        return null;
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      const EventChannel(eventName),
      MockStreamHandler.inline(
        onListen: (Object? arguments, MockStreamHandlerEventSink eventsSink) {
          events.stream.listen((event) => eventsSink.success(event));
        },
      ),
    );
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel(methodName), null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(const EventChannel(eventName), null);
    await events.close();
  });

  test('play/pause/seek/stop invoke Media3 method channel', () async {
    final adapter = Media3PlayerAdapter();
    addTearDown(adapter.dispose);

    await adapter.play(Uri.parse('https://example.com/stream.m3u8'));
    await adapter.pause();
    await adapter.seek(const Duration(seconds: 12));
    await adapter.stop();

    expect(calls.map((c) => c.method), <String>['play', 'pause', 'seek', 'stop']);
    expect(calls.first.arguments, <String, Object?>{
      'uri': 'https://example.com/stream.m3u8',
    });
    expect(calls[2].arguments, <String, Object?>{'positionMs': 12000});
  });

  test('status events map Media3 phases onto domain status', () async {
    final adapter = Media3PlayerAdapter();
    addTearDown(adapter.dispose);

    final statuses = <MediaPlayerStatus>[];
    final sub = adapter.status.listen(statuses.add);
    addTearDown(sub.cancel);

    await Future<void>.delayed(Duration.zero);
    events.add(<String, Object?>{
      'phase': 'playing',
      'positionMs': 1500,
      'durationMs': 60000,
      'message': null,
    });
    await Future<void>.delayed(Duration.zero);

    expect(statuses.last.phase, MediaPlayerPhase.playing);
    expect(statuses.last.position, const Duration(milliseconds: 1500));
    expect(statuses.last.duration, const Duration(seconds: 60));
  });

  test('MissingPluginException becomes error status without crashing', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel(methodName), null);

    final adapter = Media3PlayerAdapter();
    addTearDown(adapter.dispose);

    final statuses = <MediaPlayerStatus>[];
    final sub = adapter.status.listen(statuses.add);
    addTearDown(sub.cancel);

    await adapter.play(Uri.parse('https://example.com/a.mp4'));
    await Future<void>.delayed(Duration.zero);

    expect(statuses.last.phase, MediaPlayerPhase.error);
  });
}
