import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/data/adapters/media3_player_adapter.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_mode.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/entities/stream_protocol.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/services/abr_buffer_policy.dart';

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

    await adapter.play(
      PlaybackRequest(streamUri: Uri.parse('https://example.com/stream.m3u8')),
    );
    await adapter.pause();
    await adapter.seek(const Duration(seconds: 12));
    await adapter.stop();

    final defaultAbr =
        AbrBufferPolicy.defaults.resolve(PlaybackMode.vod).toWire();

    expect(calls.map((c) => c.method), <String>['play', 'pause', 'seek', 'stop']);
    expect(calls.first.arguments, <String, Object?>{
      'uri': 'https://example.com/stream.m3u8',
      'protocol': 'hls',
      'headers': <String, String>{},
      'userAgent': null,
      'abr': defaultAbr,
    });
    expect(calls[2].arguments, <String, Object?>{'positionMs': 12000});
  });

  test('play wires sniffed protocol, headers, user-agent, and ABR profile',
      () async {
    final adapter = Media3PlayerAdapter();
    addTearDown(adapter.dispose);

    await adapter.play(
      PlaybackRequest(
        streamUri: Uri.parse('http://iptv.example/user/key/playlist'),
        protocolHint: StreamProtocol.unknown,
        headers: const <String, String>{'Referer': 'https://portal.example/'},
        userAgent: 'MiIPTV-TV/1.0',
        mode: PlaybackMode.live,
      ),
    );

    final liveAbr =
        AbrBufferPolicy.defaults.resolve(PlaybackMode.live).toWire();

    expect(calls, hasLength(1));
    expect(calls.single.method, 'play');
    expect(calls.single.arguments, <String, Object?>{
      'uri': 'http://iptv.example/user/key/playlist',
      'protocol': 'hls',
      'headers': <String, String>{'Referer': 'https://portal.example/'},
      'userAgent': 'MiIPTV-TV/1.0',
      'abr': liveAbr,
    });
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

    await adapter.play(
      PlaybackRequest(streamUri: Uri.parse('https://example.com/a.mp4')),
    );
    await Future<void>.delayed(Duration.zero);

    expect(statuses.last.phase, MediaPlayerPhase.error);
  });
}
