/// Stance on user-supplied IPTV sources and takedowns (SEC-043 / PRD-040).
///
/// ToS body copy remains a **development draft** until counsel signs off.
/// Takedown contact was set by Product for client/store use.
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

  /// Product-provided complaint / takedown mailbox (SEC-043).
  static const String takedownContactEmail = 'shamil.espinosa@gmail.com';

  /// `mailto:` URI for in-app / store listing links.
  static const String takedownContactUri = 'mailto:$takedownContactEmail';

  static const String takedownContactLabel = 'Copyright / takedown notices';

  static const String tosUrlPlaceholderLabel = 'Terms of Service — TBD (PRD-042)';

  static const String privacyUrlPlaceholderLabel =
      'Privacy Policy — TBD (PRD-042)';

  /// In-app notice when [isDraft] is true.
  static const String draftBanner =
      'Legal text is a development draft and is not final Terms of Service.';

  static bool get hasPublishedTakedownContact =>
      takedownContactUri.trim().isNotEmpty;
}
