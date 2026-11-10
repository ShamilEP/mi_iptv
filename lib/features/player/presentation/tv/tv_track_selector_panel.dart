import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/focusable_surface.dart';
import '../../../../core/widgets/mi_list_row.dart';
import '../../../../core/widgets/mi_overlay_panel.dart';
import '../../../../core/widgets/ui_state.dart';
import 'tv_track_models.dart';

/// Right-side player overlay for audio and subtitle tracks (DSN-064).
///
/// Selection updates [preference] via callbacks; the parent remembers the
/// choice across open/close of this picker.
class TvTrackSelectorPanel extends StatelessWidget {
  const TvTrackSelectorPanel({
    super.key,
    required this.preference,
    required this.onAudioSelected,
    required this.onSubtitleSelected,
    required this.onClose,
    this.audioTracks = demoAudioTracks,
    this.subtitleTracks = demoSubtitleTracks,
  });

  final TvTrackPreference preference;
  final ValueChanged<TvMediaTrack> onAudioSelected;
  final ValueChanged<TvMediaTrack> onSubtitleSelected;
  final VoidCallback onClose;
  final List<TvMediaTrack> audioTracks;
  final List<TvMediaTrack> subtitleTracks;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: MiOverlayPanel.scrimColor(context),
              boxShadow: AppElevation.overlay(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          TvTrackSelectorCopy.title,
                          style: textTheme.headlineSmall?.copyWith(
                            color: brand.cloud,
                          ),
                        ),
                      ),
                      FocusableSurface(
                        key: const ValueKey<String>('track-selector-close'),
                        kind: FocusControlKind.button,
                        fill: brand.panel,
                        borderRadius: AppRadius.sm,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        onPressed: onClose,
                        child: Icon(
                          Icons.close,
                          color: brand.cloud,
                          size: AppSpacing.lg,
                          semanticLabel: TvTrackSelectorCopy.closeLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    TvTrackSelectorCopy.audioSection,
                    style: textTheme.titleSmall?.copyWith(color: brand.mist),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ...audioTracks.map(
                    (track) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                      child: _TrackRow(
                        track: track,
                        selected: track.id == preference.audioTrackId,
                        onPressed: () => onAudioSelected(track),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    TvTrackSelectorCopy.subtitleSection,
                    style: textTheme.titleSmall?.copyWith(color: brand.mist),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final track in subtitleTracks)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xxs,
                            ),
                            child: _TrackRow(
                              track: track,
                              selected:
                                  track.id == preference.subtitleTrackId,
                              onPressed: () => onSubtitleSelected(track),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.track,
    required this.selected,
    required this.onPressed,
  });

  final TvMediaTrack track;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    // Keep rows focusable/tappable; selected cue is the checkmark + label
    // (not UiState.selected chrome, which drops onPressed).
    return MiListRow(
      key: ValueKey<String>('track-${track.id}'),
      title: track.label,
      subtitle: track.isOff
          ? null
          : (track.languageCode.isEmpty ? null : track.languageCode),
      state: UiState.defaults,
      onPressed: onPressed,
      trailing: selected
          ? Icon(
              Icons.check,
              color: brand.primary,
              size: AppSpacing.lg,
              semanticLabel: TvTrackSelectorCopy.selectedCue,
            )
          : null,
    );
  }
}
