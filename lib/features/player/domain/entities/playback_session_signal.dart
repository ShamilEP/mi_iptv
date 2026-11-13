/// External signals that affect an active playback session (TV-052 / SRS §3).
enum PlaybackSessionSignal {
  /// Another app / system took audio focus.
  audioFocusLost,

  /// Focus restored (does not auto-resume — UI / user decides).
  audioFocusGained,

  /// Process moved to background / inactive.
  appBackgrounded,

  /// Process returned to foreground.
  appForegrounded,

  /// HDMI / external display audio path disconnected.
  hdmiDisconnected,

  /// HDMI / external display audio path connected.
  hdmiConnected,
}
