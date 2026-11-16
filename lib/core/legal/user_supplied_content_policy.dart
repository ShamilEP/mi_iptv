/// Draft stance on user-supplied IPTV sources and takedowns (SEC-043 / PRD-040).
///
/// **Not final legal copy.** Product + counsel must approve before store ship.
/// Contact fields stay empty until PRD-040 provides them — do not invent a
/// production mailbox.
abstract final class UserSuppliedContentPolicy {
  /// Documented draft for Product / counsel review.
  static const String draftDocPath =
      'docs/legal/user_supplied_content_tos_draft.md';

  /// Engineering may use these strings in About / Legal UI while marked draft.
  static const bool isDraft = true;

  static const String shortProductStance =
      'Mi IPTV is a media client. You may add your own M3U or Xtream sources. '
      'You are responsible for having the rights to use those sources. '
      'Mi IPTV does not host or redistribute your private streams.';

  static const String userResponsibilitySummary =
      'By adding a source, you confirm you are authorized to access the '
      'playlists and streams it provides.';

  static const String proprietaryCatalogSummary =
      'Mi Catalog and app branding are separate from user-supplied sources and '
      'remain owned by Mi IPTV or its licensors.';

  /// Empty until Product sets a real HTTPS help URL or mailto (PRD-040).
  static const String? takedownContactUri = null;

  static const String takedownContactPlaceholderLabel =
      'Takedown contact — TBD (Product PRD-040)';

  static const String tosUrlPlaceholderLabel = 'Terms of Service — TBD (PRD-042)';

  static const String privacyUrlPlaceholderLabel =
      'Privacy Policy — TBD (PRD-042)';

  /// In-app notice when [isDraft] is true.
  static const String draftBanner =
      'Legal text is a development draft and is not final Terms of Service.';

  static bool get hasPublishedTakedownContact =>
      takedownContactUri != null && takedownContactUri!.trim().isNotEmpty;
}
