import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/entities/stream_protocol.dart';
import 'package:mi_iptv/features/player/domain/services/stream_format_sniffer.dart';

void main() {
  group('StreamFormatSniffer TV-051', () {
    test('detects HLS DASH and progressive extensions', () {
      expect(
        StreamFormatSniffer.sniff(Uri.parse('https://cdn.example/a/master.m3u8')),
        StreamProtocol.hls,
      );
      expect(
        StreamFormatSniffer.sniff(Uri.parse('https://cdn.example/manifest.mpd')),
        StreamProtocol.dash,
      );
      expect(
        StreamFormatSniffer.sniff(Uri.parse('https://cdn.example/movie.mp4')),
        StreamProtocol.progressiveMp4,
      );
      expect(
        StreamFormatSniffer.sniff(Uri.parse('https://cdn.example/live.ts')),
        StreamProtocol.progressiveTs,
      );
    });

    test('sniffs extension-less IPTV playlist paths', () {
      expect(
        StreamFormatSniffer.sniff(
          Uri.parse('http://iptv.example:8080/user/key/playlist'),
        ),
        StreamProtocol.hls,
      );
      expect(
        StreamFormatSniffer.sniff(
          Uri.parse('http://iptv.example/live'),
        ),
        StreamProtocol.hls,
      );
    });

    test('honors query tokens and catalog hints', () {
      expect(
        StreamFormatSniffer.sniff(
          Uri.parse('http://iptv.example/stream?format=dash'),
        ),
        StreamProtocol.dash,
      );
      expect(
        StreamFormatSniffer.sniff(
          Uri.parse('http://iptv.example/extless'),
          catalogProtocol: 'hls',
        ),
        StreamProtocol.hls,
      );
      expect(
        StreamFormatSniffer.sniff(
          Uri.parse('http://iptv.example/extless'),
          protocolHint: StreamProtocol.progressiveMp4,
        ),
        StreamProtocol.progressiveMp4,
      );
    });

    test('unknown when no signal — Media3 may use Content-Type', () {
      expect(
        StreamFormatSniffer.sniff(Uri.parse('http://iptv.example/abc123')),
        StreamProtocol.unknown,
      );
    });
  });
}
