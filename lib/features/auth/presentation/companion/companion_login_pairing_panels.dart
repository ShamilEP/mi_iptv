import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_icon.dart';
import '../../../../core/widgets/mi_list_row.dart';
import '../../../../core/widgets/mi_text_field.dart';
import 'companion_linked_tv.dart';
import 'companion_login_pairing_copy.dart';

/// Email and password sign-in for the companion account (DSN-050).
class CompanionLoginPanel extends StatelessWidget {
  const CompanionLoginPanel({
    super.key,
    required this.email,
    required this.password,
    required this.onSignIn,
    this.formError,
  });

  final TextEditingController email;
  final TextEditingController password;
  final VoidCallback onSignIn;
  final String? formError;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CompanionLoginPairingCopy.signInTitle,
          style: textTheme.headlineMedium?.copyWith(color: brand.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          CompanionLoginPairingCopy.signInBody,
          style: textTheme.bodyLarge?.copyWith(color: brand.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        MiTextField(
          controller: email,
          label: CompanionLoginPairingCopy.emailLabel,
          hint: CompanionLoginPairingCopy.demoAccountEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        MiTextField(
          controller: password,
          label: CompanionLoginPairingCopy.passwordLabel,
          obscureText: true,
        ),
        if (formError != null) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MiIcon(
                role: IconRole.error,
                color: brand.error,
                size: AppSpacing.lg,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  formError!,
                  style: textTheme.bodyLarge?.copyWith(color: brand.ink),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        MiButton(
          label: CompanionLoginPairingCopy.logInLabel,
          emphasis: ControlEmphasis.primary,
          onPressed: onSignIn,
        ),
      ],
    );
  }
}

/// Linked TVs for the signed-in account, each with a connection label.
class CompanionLinkedTvList extends StatelessWidget {
  const CompanionLinkedTvList({
    super.key,
    required this.accountEmail,
    required this.tvs,
  });

  final String accountEmail;
  final List<CompanionLinkedTv> tvs;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CompanionLoginPairingCopy.linkedTvsTitle,
          style: textTheme.headlineMedium?.copyWith(color: brand.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          CompanionLoginPairingCopy.linkedTvsBody,
          style: textTheme.bodyLarge?.copyWith(color: brand.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          CompanionLoginPairingCopy.accountLabel,
          style: textTheme.labelLarge?.copyWith(color: brand.muted),
        ),
        Text(
          accountEmail,
          style: textTheme.titleLarge?.copyWith(color: brand.ink),
        ),
        const SizedBox(height: AppSpacing.lg),
        MiIcon(role: IconRole.devices, color: brand.ink, size: AppSpacing.lg),
        const SizedBox(height: AppSpacing.sm),
        if (tvs.isEmpty)
          Text(
            CompanionLoginPairingCopy.emptyTvsMessage,
            style: textTheme.bodyLarge?.copyWith(color: brand.ink),
          )
        else
          for (final tv in tvs) ...[
            MiListRow(
              title: tv.name,
              leading: MiIcon(
                role: IconRole.liveTv,
                color: brand.ink,
                size: AppSpacing.lg,
              ),
              trailing: MiIcon(
                role: _connectionRole(tv.connection),
                color: brand.ink,
                size: AppSpacing.lg,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }

  IconRole _connectionRole(CompanionTvConnection connection) {
    switch (connection) {
      case CompanionTvConnection.connected:
        return IconRole.connected;
      case CompanionTvConnection.offline:
        return IconRole.offline;
    }
  }
}
