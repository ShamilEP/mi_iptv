import 'package:flutter/foundation.dart';

/// Profile modes for the TV design shell (DSN-061).
enum TvProfileScreenMode {
  /// Launch picker — select who is watching.
  picker,

  /// Create a new profile.
  create,

  /// Edit an existing profile.
  edit,
}

/// Demo profile for the Release 1 design shell.
@immutable
class TvProfile {
  const TvProfile({
    required this.id,
    required this.name,
    required this.initials,
    this.isKid = false,
  });

  final String id;
  final String name;
  final String initials;
  final bool isKid;

  TvProfile copyWith({
    String? id,
    String? name,
    String? initials,
    bool? isKid,
  }) {
    return TvProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      isKid: isKid ?? this.isKid,
    );
  }
}

/// Locked copy for the profiles design shell (DSN-061).
abstract final class TvProfileCopy {
  static const String pickerTitle = 'Who’s watching?';
  static const String pickerSubtitle =
      'Choose a profile to continue. Kid profiles show a Kids badge.';
  static const String manageLabel = 'Manage profiles';
  static const String doneManageLabel = 'Done';
  static const String addLabel = 'Add profile';
  static const String createTitle = 'Create profile';
  static const String editTitle = 'Edit profile';
  static const String nameLabel = 'Profile name';
  static const String nameHint = 'Name';
  static const String kidToggleLabel = 'Kid profile';
  static const String kidToggleHint =
      'Shows a Kids badge and softer catalog cues.';
  static const String kidsBadge = 'Kids';
  static const String saveLabel = 'Save';
  static const String cancelLabel = 'Cancel';
  static const String deleteLabel = 'Remove';
}

/// Demo profiles for the design shell (not MVP ship scope).
const List<TvProfile> demoProfiles = <TvProfile>[
  TvProfile(id: 'p-alex', name: 'Alex', initials: 'A'),
  TvProfile(id: 'p-sam', name: 'Sam', initials: 'S'),
  TvProfile(id: 'p-kids', name: 'Kids', initials: 'K', isKid: true),
];
