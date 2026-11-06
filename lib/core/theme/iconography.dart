import 'package:flutter/material.dart';

/// MVP icon roles (DSN-019). Prefer [Iconography.of] over ad-hoc [Icons].
enum IconRole {
  // Destinations
  home,
  liveTv,
  search,
  favorites,
  settings,
  sources,
  devices,

  // Playback / actions
  play,
  pause,
  seekBack,
  seekForward,
  info,
  favorite,
  retry,
  phoneCompanion,

  // Status indicators (pair with labels when [IconographyEntry.labelRequired])
  live,
  activeSource,
  synced,
  connected,
  weakNetwork,
  empty,
  error,
  offline,
  warning,
  disabled,
  selected,

  // Content kind placeholders
  movie,
  series,
  channel,
  continueWatching,
}

/// One locked glyph + labeling rule for an [IconRole].
@immutable
class IconographyEntry {
  const IconographyEntry({
    required this.role,
    required this.icon,
    required this.label,
    required this.labelRequired,
    required this.summary,
  });

  final IconRole role;
  final IconData icon;

  /// Default English text label (SRS §13 / DSN-019).
  final String label;

  /// When true, UI must show a visible text label — meaning is ambiguous.
  final bool labelRequired;

  final String summary;
}

/// Executable iconography set for Brand Theme / MVP chrome (DSN-019).
///
/// Ambiguous glyphs always ship with text labels; clear metaphors may omit the
/// visible label but should still expose [IconographyEntry.label] to semantics.
abstract final class Iconography {
  static const List<IconRole> roles = IconRole.values;

  static const IconographyEntry home = IconographyEntry(
    role: IconRole.home,
    icon: Icons.home_outlined,
    label: 'Home',
    labelRequired: false,
    summary: 'Home destination',
  );

  static const IconographyEntry liveTv = IconographyEntry(
    role: IconRole.liveTv,
    icon: Icons.live_tv_outlined,
    label: 'Live TV',
    labelRequired: false,
    summary: 'Live TV destination / channel chrome',
  );

  static const IconographyEntry search = IconographyEntry(
    role: IconRole.search,
    icon: Icons.search,
    label: 'Search',
    labelRequired: false,
    summary: 'Search destination',
  );

  static const IconographyEntry favorites = IconographyEntry(
    role: IconRole.favorites,
    icon: Icons.favorite_border,
    label: 'Favorites',
    labelRequired: false,
    summary: 'Favorites destination / empty favorites',
  );

  static const IconographyEntry settings = IconographyEntry(
    role: IconRole.settings,
    icon: Icons.settings_outlined,
    label: 'Settings',
    labelRequired: false,
    summary: 'Settings destination',
  );

  static const IconographyEntry sources = IconographyEntry(
    role: IconRole.sources,
    icon: Icons.dns_outlined,
    label: 'Sources',
    labelRequired: true,
    summary: 'IPTV / catalog sources (ambiguous without text)',
  );

  static const IconographyEntry devices = IconographyEntry(
    role: IconRole.devices,
    icon: Icons.devices,
    label: 'Devices',
    labelRequired: true,
    summary: 'Paired devices / multi-device sync',
  );

  static const IconographyEntry play = IconographyEntry(
    role: IconRole.play,
    icon: Icons.play_arrow,
    label: 'Play',
    labelRequired: false,
    summary: 'Play / playing state',
  );

  static const IconographyEntry pause = IconographyEntry(
    role: IconRole.pause,
    icon: Icons.pause,
    label: 'Pause',
    labelRequired: false,
    summary: 'Pause playback',
  );

  static const IconographyEntry seekBack = IconographyEntry(
    role: IconRole.seekBack,
    icon: Icons.replay_10,
    label: 'Back 10 seconds',
    labelRequired: false,
    summary: 'Seek backward 10s',
  );

  static const IconographyEntry seekForward = IconographyEntry(
    role: IconRole.seekForward,
    icon: Icons.forward_10,
    label: 'Forward 10 seconds',
    labelRequired: false,
    summary: 'Seek forward 10s',
  );

  static const IconographyEntry info = IconographyEntry(
    role: IconRole.info,
    icon: Icons.info_outline,
    label: 'Info',
    labelRequired: false,
    summary: 'Channel / title info',
  );

  static const IconographyEntry favorite = IconographyEntry(
    role: IconRole.favorite,
    icon: Icons.favorite_border,
    label: 'Favorite',
    labelRequired: false,
    summary: 'Add / show favorite',
  );

  static const IconographyEntry retry = IconographyEntry(
    role: IconRole.retry,
    icon: Icons.refresh,
    label: 'Retry',
    labelRequired: false,
    summary: 'Retry failed action',
  );

  static const IconographyEntry phoneCompanion = IconographyEntry(
    role: IconRole.phoneCompanion,
    icon: Icons.phone_android,
    label: 'Type from your phone',
    labelRequired: true,
    summary: 'Companion keyboard / type-from-phone hint',
  );

  static const IconographyEntry live = IconographyEntry(
    role: IconRole.live,
    icon: Icons.fiber_manual_record,
    label: 'LIVE',
    labelRequired: true,
    summary: 'LIVE badge (Ember) — never hue or dot alone',
  );

  static const IconographyEntry activeSource = IconographyEntry(
    role: IconRole.activeSource,
    icon: Icons.radio_button_checked,
    label: 'Active source',
    labelRequired: true,
    summary: 'Active IPTV / catalog source indicator',
  );

  static const IconographyEntry synced = IconographyEntry(
    role: IconRole.synced,
    icon: Icons.cloud_done_outlined,
    label: 'Synced',
    labelRequired: true,
    summary: 'Account / device synced',
  );

  static const IconographyEntry connected = IconographyEntry(
    role: IconRole.connected,
    icon: Icons.link,
    label: 'Connected',
    labelRequired: true,
    summary: 'Device connected',
  );

  static const IconographyEntry weakNetwork = IconographyEntry(
    role: IconRole.weakNetwork,
    icon: Icons.wifi_1_bar,
    label: 'Weak network',
    labelRequired: true,
    summary: 'Degraded connectivity',
  );

  static const IconographyEntry empty = IconographyEntry(
    role: IconRole.empty,
    icon: Icons.inbox_outlined,
    label: 'Empty',
    labelRequired: true,
    summary: 'Empty state cue',
  );

  static const IconographyEntry error = IconographyEntry(
    role: IconRole.error,
    icon: Icons.error_outline,
    label: 'Error',
    labelRequired: false,
    summary: 'Error / stream failed cue',
  );

  static const IconographyEntry offline = IconographyEntry(
    role: IconRole.offline,
    icon: Icons.wifi_off_outlined,
    label: 'Offline',
    labelRequired: true,
    summary: 'Offline state — pair with copy',
  );

  static const IconographyEntry warning = IconographyEntry(
    role: IconRole.warning,
    icon: Icons.warning_amber_outlined,
    label: 'Warning',
    labelRequired: true,
    summary: 'Sync conflict / caution',
  );

  static const IconographyEntry disabled = IconographyEntry(
    role: IconRole.disabled,
    icon: Icons.block,
    label: 'Disabled',
    labelRequired: false,
    summary: 'Disabled control cue',
  );

  static const IconographyEntry selected = IconographyEntry(
    role: IconRole.selected,
    icon: Icons.check,
    label: 'Selected',
    labelRequired: false,
    summary: 'Selected / confirmed',
  );

  static const IconographyEntry movie = IconographyEntry(
    role: IconRole.movie,
    icon: Icons.movie_outlined,
    label: 'Movie',
    labelRequired: false,
    summary: 'Movie poster placeholder',
  );

  static const IconographyEntry series = IconographyEntry(
    role: IconRole.series,
    icon: Icons.slideshow_outlined,
    label: 'Series',
    labelRequired: false,
    summary: 'Series / landscape placeholder',
  );

  static const IconographyEntry channel = IconographyEntry(
    role: IconRole.channel,
    icon: Icons.live_tv_outlined,
    label: 'Channel',
    labelRequired: false,
    summary: 'Channel tile placeholder',
  );

  static const IconographyEntry continueWatching = IconographyEntry(
    role: IconRole.continueWatching,
    icon: Icons.play_circle_outline,
    label: 'Continue watching',
    labelRequired: false,
    summary: 'Continue Watching placeholder',
  );

  static IconographyEntry of(IconRole role) {
    switch (role) {
      case IconRole.home:
        return home;
      case IconRole.liveTv:
        return liveTv;
      case IconRole.search:
        return search;
      case IconRole.favorites:
        return favorites;
      case IconRole.settings:
        return settings;
      case IconRole.sources:
        return sources;
      case IconRole.devices:
        return devices;
      case IconRole.play:
        return play;
      case IconRole.pause:
        return pause;
      case IconRole.seekBack:
        return seekBack;
      case IconRole.seekForward:
        return seekForward;
      case IconRole.info:
        return info;
      case IconRole.favorite:
        return favorite;
      case IconRole.retry:
        return retry;
      case IconRole.phoneCompanion:
        return phoneCompanion;
      case IconRole.live:
        return live;
      case IconRole.activeSource:
        return activeSource;
      case IconRole.synced:
        return synced;
      case IconRole.connected:
        return connected;
      case IconRole.weakNetwork:
        return weakNetwork;
      case IconRole.empty:
        return empty;
      case IconRole.error:
        return error;
      case IconRole.offline:
        return offline;
      case IconRole.warning:
        return warning;
      case IconRole.disabled:
        return disabled;
      case IconRole.selected:
        return selected;
      case IconRole.movie:
        return movie;
      case IconRole.series:
        return series;
      case IconRole.channel:
        return channel;
      case IconRole.continueWatching:
        return continueWatching;
    }
  }

  static List<IconographyEntry> get all =>
      roles.map(of).toList(growable: false);

  /// Roles that must show a visible text label (DSN-019 DoD).
  static List<IconographyEntry> get labelRequiredEntries =>
      all.where((e) => e.labelRequired).toList(growable: false);
}
