/// Container / playlist protocol for Media3 source selection (TV-051).
enum StreamProtocol {
  /// HTTP Live Streaming (`.m3u8`).
  hls,

  /// MPEG-DASH (`.mpd`).
  dash,

  /// Progressive MPEG-TS (`.ts` / `.m2ts`).
  progressiveTs,

  /// Progressive MP4 / ISO BMFF (`.mp4` / `.m4v`).
  progressiveMp4,

  /// Extension-less / unknown — let Media3 infer from Content-Type after redirects.
  unknown,
}

extension StreamProtocolWire on StreamProtocol {
  /// Stable wire token for the Media3 MethodChannel.
  String get wireName => switch (this) {
        StreamProtocol.hls => 'hls',
        StreamProtocol.dash => 'dash',
        StreamProtocol.progressiveTs => 'progressive_ts',
        StreamProtocol.progressiveMp4 => 'progressive_mp4',
        StreamProtocol.unknown => 'unknown',
      };

  static StreamProtocol parse(String? raw) {
    return switch (raw?.trim().toLowerCase()) {
      'hls' || 'm3u8' => StreamProtocol.hls,
      'dash' || 'mpd' => StreamProtocol.dash,
      'ts' || 'progressive_ts' || 'mpegts' => StreamProtocol.progressiveTs,
      'mp4' || 'progressive_mp4' || 'm4v' => StreamProtocol.progressiveMp4,
      _ => StreamProtocol.unknown,
    };
  }
}
