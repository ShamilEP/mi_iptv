import '../entities/playback_track.dart';

/// Picks the source-default audio / subtitle for MVP playback (TV-057).
///
/// Manual track selection remains FR-017 / Release 1 (DSN-064). When the source
/// marks no default subtitle, subtitles stay Off.
abstract final class DefaultTrackPolicy {
  static const String subtitleOffId = 'sub-off';

  static DefaultTrackSelection resolve({
    required List<PlaybackTrack> audioTracks,
    required List<PlaybackTrack> subtitleTracks,
  }) {
    final audios = audioTracks
        .where((t) => t.kind == PlaybackTrackKind.audio && !t.isOff)
        .toList(growable: false);
    final subs = subtitleTracks
        .where((t) => t.kind == PlaybackTrackKind.subtitle && !t.isOff)
        .toList(growable: false);

    final audio = _pickDefault(audios) ?? (audios.isEmpty ? null : audios.first);
    final subtitleDefault = _pickDefault(subs);

    String offId = subtitleOffId;
    for (final track in subtitleTracks) {
      if (track.isOff) {
        offId = track.id;
        break;
      }
    }

    return DefaultTrackSelection(
      audioTrackId: audio?.id ?? '',
      subtitleTrackId: subtitleDefault?.id ?? offId,
    );
  }

  static PlaybackTrack? _pickDefault(List<PlaybackTrack> tracks) {
    for (final track in tracks) {
      if (track.isDefault) return track;
    }
    return null;
  }
}
