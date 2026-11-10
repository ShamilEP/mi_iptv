# Stream-failure recovery overlay (DSN-039)

Executable UI: [`StreamFailureRecoveryOverlay`](../../lib/core/widgets/stream_failure_recovery_overlay.dart), hosted by [`TvLiveTvPage`](../../lib/features/live_tv/presentation/tv/tv_live_tv_page.dart) when `streamFailed` is true.

## Layout

1. **Video stays** — the stage is not replaced by a dead-end page.
2. **Channel context stays** — the top [`ChannelInfoOverlay`](../../lib/core/widgets/channel_info_overlay.dart) remains visible (auto-hide off): number, name, logo, source. The recovery card repeats number, name, and source.
3. **Actionable message** — error icon plus the catalog Error label, then copy that names the three actions.
4. **Actions** — Retry (primary, initial focus), Switch source, Back to channels. The channel list is hidden while the overlay is up so D-pad focus stays on those actions.

## Behavior

- The host owns Retry, Switch source, and Back to channels. This shell does not start playback or open a source picker.
- The selected channel does not change when the overlay appears.
- Back to channels is the host's signal to dismiss the overlay and return to the channel list.
- Default copy: "Couldn't play this channel. Retry, switch source, or go back to channels."
