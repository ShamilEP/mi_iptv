import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/mi_icon.dart';
import '../../../../core/widgets/mi_text_field.dart';
import 'companion_remote_copy.dart';
import 'companion_remote_key.dart';
import 'companion_remote_layout.dart';

/// Companion remote for a linked TV (DSN-051).
///
/// Large D-pad, navigation, volume, transport, and keyboard entry. Each press
/// gives immediate haptic and color feedback. This shell does not send commands
/// to a TV.
class CompanionRemotePage extends StatefulWidget {
  const CompanionRemotePage({
    super.key,
    this.tvName = CompanionRemoteCopy.demoTvName,
    this.connected = true,
    this.onCommand,
    this.onKeyboardSubmit,
    this.onFeedback = HapticFeedback.lightImpact,
  });

  /// Linked TV this remote is aimed at.
  final String tvName;

  /// Whether [tvName] is connected. Offline still shows the controls.
  final bool connected;

  /// Called with the control that was pressed.
  final ValueChanged<CompanionRemoteCommand>? onCommand;

  /// Called with trimmed keyboard text after Send.
  final ValueChanged<String>? onKeyboardSubmit;

  /// Fired when a press starts. Defaults to a light haptic impact.
  final Future<void> Function() onFeedback;

  @override
  State<CompanionRemotePage> createState() => _CompanionRemotePageState();
}

class _CompanionRemotePageState extends State<CompanionRemotePage> {
  final TextEditingController _keyboard = TextEditingController();
  String _feedback = CompanionRemoteCopy.ready;
  String? _keyboardError;

  @override
  void dispose() {
    _keyboard.dispose();
    super.dispose();
  }

  void _command(CompanionRemoteCommand command) {
    setState(() {
      _keyboardError = null;
      _feedback = CompanionRemoteCopy.labelFor(command);
    });
    widget.onCommand?.call(command);
  }

  void _send() {
    final text = MiTextField.sanitize(_keyboard.text).trim();
    if (text.isEmpty) {
      setState(() => _keyboardError = CompanionRemoteCopy.emptyKeyboardMessage);
      return;
    }
    setState(() {
      _keyboardError = null;
      _feedback = text;
      _keyboard.clear();
    });
    widget.onKeyboardSubmit?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: brand.cloud,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.insetPageCompanion),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandLockup(
                markHeight: AppSpacing.xl,
                tone: BrandMarkTone.companion,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        CompanionRemoteCopy.title,
                        style: textTheme.headlineMedium?.copyWith(
                          color: brand.ink,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.tvName,
                              style: textTheme.titleLarge?.copyWith(
                                color: brand.ink,
                              ),
                            ),
                          ),
                          MiIcon(
                            role: widget.connected
                                ? IconRole.connected
                                : IconRole.offline,
                            color: brand.ink,
                            size: AppSpacing.lg,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      KeyedSubtree(
                        key: const ValueKey<String>('remote-feedback'),
                        child: Text(
                          _feedback,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleLarge?.copyWith(
                            color: brand.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CompanionRemoteDpad(
                        onCommand: _command,
                        onFeedback: widget.onFeedback,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CompanionRemoteCommandRow(
                        commands: const [
                          CompanionRemoteCommand.back,
                          CompanionRemoteCommand.home,
                        ],
                        onCommand: _command,
                        onFeedback: widget.onFeedback,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CompanionRemoteCommandRow(
                        commands: const [
                          CompanionRemoteCommand.volumeDown,
                          CompanionRemoteCommand.mute,
                          CompanionRemoteCommand.volumeUp,
                        ],
                        onCommand: _command,
                        onFeedback: widget.onFeedback,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CompanionRemoteCommandRow(
                        commands: const [
                          CompanionRemoteCommand.play,
                          CompanionRemoteCommand.pause,
                        ],
                        icons: const {
                          CompanionRemoteCommand.play: IconRole.play,
                          CompanionRemoteCommand.pause: IconRole.pause,
                        },
                        onCommand: _command,
                        onFeedback: widget.onFeedback,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CompanionRemoteCommandRow(
                        commands: const [
                          CompanionRemoteCommand.seekBack,
                          CompanionRemoteCommand.seekForward,
                        ],
                        icons: const {
                          CompanionRemoteCommand.seekBack: IconRole.seekBack,
                          CompanionRemoteCommand.seekForward:
                              IconRole.seekForward,
                        },
                        onCommand: _command,
                        onFeedback: widget.onFeedback,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        CompanionRemoteCopy.keyboardLabel,
                        style: textTheme.labelLarge?.copyWith(
                          color: brand.muted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      MiTextField(
                        controller: _keyboard,
                        label: CompanionRemoteCopy.keyboardLabel,
                        hint: CompanionRemoteCopy.keyboardHint,
                      ),
                      if (_keyboardError != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _keyboardError!,
                          style: textTheme.bodyLarge?.copyWith(
                            color: brand.ink,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      CompanionRemoteKey(
                        label: CompanionRemoteCopy.sendLabel,
                        onFeedback: widget.onFeedback,
                        onPressed: _send,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
