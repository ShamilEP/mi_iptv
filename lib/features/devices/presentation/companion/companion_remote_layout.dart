import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import 'companion_remote_copy.dart';
import 'companion_remote_key.dart';

/// Large Up / Down / Left / Right / OK cluster (DSN-051).
class CompanionRemoteDpad extends StatelessWidget {
  const CompanionRemoteDpad({
    super.key,
    required this.onCommand,
    required this.onFeedback,
  });

  final ValueChanged<CompanionRemoteCommand> onCommand;
  final Future<void> Function() onFeedback;

  @override
  Widget build(BuildContext context) {
    Widget key(CompanionRemoteCommand command) {
      return CompanionRemoteKey(
        label: CompanionRemoteCopy.labelFor(command),
        large: true,
        onFeedback: onFeedback,
        onPressed: () => onCommand(command),
      );
    }

    return Column(
      children: [
        key(CompanionRemoteCommand.up),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            key(CompanionRemoteCommand.left),
            const SizedBox(width: AppSpacing.xs),
            key(CompanionRemoteCommand.ok),
            const SizedBox(width: AppSpacing.xs),
            key(CompanionRemoteCommand.right),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        key(CompanionRemoteCommand.down),
      ],
    );
  }
}

/// Equal-width row of remote commands.
class CompanionRemoteCommandRow extends StatelessWidget {
  const CompanionRemoteCommandRow({
    super.key,
    required this.commands,
    required this.onCommand,
    required this.onFeedback,
    this.icons = const {},
  });

  final List<CompanionRemoteCommand> commands;
  final ValueChanged<CompanionRemoteCommand> onCommand;
  final Future<void> Function() onFeedback;
  final Map<CompanionRemoteCommand, IconRole> icons;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < commands.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: CompanionRemoteKey(
              label: CompanionRemoteCopy.labelFor(commands[i]),
              icon: icons[commands[i]],
              onFeedback: onFeedback,
              onPressed: () => onCommand(commands[i]),
            ),
          ),
        ],
      ],
    );
  }
}
