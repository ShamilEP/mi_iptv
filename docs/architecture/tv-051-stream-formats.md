# TV-051 — Support HLS, DASH and progressive TS/MP4

Depends on **TV-050** (Media3 `MediaPlayerController`).  
Refs: Frontend §2.2; SRS §16.

## Goal

Play **HLS**, **DASH**, and **progressive TS/MP4** through the shared Media3 host,
including **extension-less IPTV URLs** (content sniffing), **custom headers /
User-Agent**, and **HTTP redirects**.

## Wiring

| Concern | Authority |
|---|---|
| Request model | [`PlaybackRequest`](../../lib/features/player/domain/entities/playback_request.dart) |
| Protocol enum | [`StreamProtocol`](../../lib/features/player/domain/entities/stream_protocol.dart) |
| URI sniffing | [`StreamFormatSniffer`](../../lib/features/player/domain/services/stream_format_sniffer.dart) |
| Dart bridge | [`Media3PlayerAdapter.play`](../../lib/features/player/data/adapters/media3_player_adapter.dart) passes `protocol`, `headers`, `userAgent` |
| Native HTTP | `DefaultHttpDataSource.Factory` — `setAllowCrossProtocolRedirects(true)`, optional UA + default request properties |
| Mime hints | `MimeTypes.APPLICATION_M3U8` / `APPLICATION_MPD` / `VIDEO_MP2T` / `VIDEO_MP4`; `unknown` omits mime so Media3 can use Content-Type after redirects |

## Sniffing rules (Dart)

1. Explicit `protocolHint` / catalog protocol wins when known.
2. Path extensions: `.m3u8` → HLS, `.mpd` → DASH, `.mp4`/`.m4v` → progressive MP4, `.ts`/`.m2ts` → progressive TS.
3. Query `format` / `type` / `protocol` / `ext` tokens.
4. Extension-less path tokens (`playlist`, `index`, `live`, `chunklist`) → HLS.
5. Otherwise `unknown` — native host relies on response Content-Type after redirects.

## Security

- Do not log Authorization headers, license payloads, or credential-bearing stream URIs.
- Platform error messages stay as Media3 `errorCodeName` / channel codes only.

## Validation

- `test/features/player/domain/stream_format_sniffer_test.dart`
- `test/features/player/data/media3_player_adapter_test.dart` (headers / protocol wire)
- `test/docs/tv_051_stream_formats_doc_test.dart`
