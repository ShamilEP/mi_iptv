import 'package:flutter/foundation.dart';

/// Kind of selectable media track in the player overlay (DSN-064).
enum TvMediaTrackKind {
  audio,
  subtitle,
}

/// Demo / shell media track (no Media3 wiring).
@immutable
class TvMediaTrack {
  const TvMediaTrack({
    required this.id,
    required this.kind,
    required this.label,
    this.languageCode = '',
    this.isOff = false,
  });

  final String id;
  final TvMediaTrackKind kind;
  final String label;
  final String languageCode;

  /// Subtitle “Off” row — hides captions without removing the option.
  final bool isOff;
}

/// Remembered audio / subtitle choice for the player shell (DSN-064).
@immutable
class TvTrackPreference {
  const TvTrackPreference({
    this.audioTrackId = demoDefaultAudioId,
    this.subtitleTrackId = demoDefaultSubtitleId,
  });

  final String audioTrackId;
  final String subtitleTrackId;

  TvTrackPreference copyWith({
    String? audioTrackId,
    String? subtitleTrackId,
  }) {
    return TvTrackPreference(
      audioTrackId: audioTrackId ?? this.audioTrackId,
      subtitleTrackId: subtitleTrackId ?? this.subtitleTrackId,
    );
  }
}

/// Locked copy for the track selector (DSN-064).
abstract final class TvTrackSelectorCopy {
  static const String title = 'Audio & subtitles';
  static const String audioSection = 'Audio';
  static const String subtitleSection = 'Subtitles';
  static const String closeLabel = 'Close';
  static const String openLabel = 'Audio and subtitles';
  static const String selectedCue = 'Selected';
  static const String offLabel = 'Off';
}

const String demoDefaultAudioId = 'aud-en';
const String demoDefaultSubtitleId = 'sub-en';

const List<TvMediaTrack> demoAudioTracks = <TvMediaTrack>[
  TvMediaTrack(
    id: demoDefaultAudioId,
    kind: TvMediaTrackKind.audio,
    label: 'English',
    languageCode: 'en',
  ),
  TvMediaTrack(
    id: 'aud-es',
    kind: TvMediaTrackKind.audio,
    label: 'Español',
    languageCode: 'es',
  ),
  TvMediaTrack(
    id: 'aud-fr',
    kind: TvMediaTrackKind.audio,
    label: 'Français',
    languageCode: 'fr',
  ),
];

const List<TvMediaTrack> demoSubtitleTracks = <TvMediaTrack>[
  TvMediaTrack(
    id: 'sub-off',
    kind: TvMediaTrackKind.subtitle,
    label: TvTrackSelectorCopy.offLabel,
    isOff: true,
  ),
  TvMediaTrack(
    id: demoDefaultSubtitleId,
    kind: TvMediaTrackKind.subtitle,
    label: 'English',
    languageCode: 'en',
  ),
  TvMediaTrack(
    id: 'sub-es',
    kind: TvMediaTrackKind.subtitle,
    label: 'Español',
    languageCode: 'es',
  ),
  TvMediaTrack(
    id: 'sub-fr',
    kind: TvMediaTrackKind.subtitle,
    label: 'Français',
    languageCode: 'fr',
  ),
];
