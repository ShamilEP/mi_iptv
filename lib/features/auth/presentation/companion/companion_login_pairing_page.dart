import 'package:flutter/material.dart';

import '../../../../core/platform/companion_platform_shell.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/mi_text_field.dart';
import 'companion_linked_tv.dart';
import 'companion_login_pairing_copy.dart';
import 'companion_login_pairing_panels.dart';

/// Companion login and linked-TV list (DSN-050).
///
/// Light-theme shell: sign in with the account, then see each linked TV with
/// a labeled connection state. This screen does not call auth or pairing APIs.
class CompanionLoginPairingPage extends StatefulWidget {
  const CompanionLoginPairingPage({
    super.key,
    this.initialStep = CompanionLoginPairingStep.login,
    this.linkedTvs = demoLinkedTvs,
    this.accountEmail = CompanionLoginPairingCopy.demoAccountEmail,
    this.onSignedIn,
  });

  /// First screen. Tests can open [CompanionLoginPairingStep.linkedTvs].
  final CompanionLoginPairingStep initialStep;

  /// Linked TVs shown after login.
  final List<CompanionLinkedTv> linkedTvs;

  /// Account email shown on the linked-TV screen before a new sign-in.
  final String accountEmail;

  /// Called with the signed-in email after a non-empty login.
  final ValueChanged<String>? onSignedIn;

  static const List<CompanionLinkedTv> demoLinkedTvs = <CompanionLinkedTv>[
    CompanionLinkedTv(
      name: 'Living room',
      connection: CompanionTvConnection.connected,
    ),
    CompanionLinkedTv(
      name: 'Bedroom',
      connection: CompanionTvConnection.offline,
    ),
  ];

  @override
  State<CompanionLoginPairingPage> createState() =>
      _CompanionLoginPairingPageState();
}

/// Login, then the linked-TV list.
enum CompanionLoginPairingStep {
  /// Email and password for the account.
  login,

  /// Linked TVs and their connection states.
  linkedTvs,
}

class _CompanionLoginPairingPageState extends State<CompanionLoginPairingPage> {
  late CompanionLoginPairingStep _step = widget.initialStep;
  late String _accountEmail = widget.accountEmail;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? _formError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    final email = MiTextField.sanitize(_email.text).trim();
    final password = MiTextField.sanitize(_password.text).trim();
    if (email.isEmpty || password.isEmpty) {
      setState(
        () => _formError = CompanionLoginPairingCopy.missingCredentialsMessage,
      );
      return;
    }
    setState(() {
      _formError = null;
      _accountEmail = email;
      _step = CompanionLoginPairingStep.linkedTvs;
    });
    widget.onSignedIn?.call(email);
  }

  @override
  Widget build(BuildContext context) {
    return CompanionPlatformShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandLockup(
            markHeight: AppSpacing.xxl,
            tone: BrandMarkTone.companion,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: _step == CompanionLoginPairingStep.login
                  ? CompanionLoginPanel(
                      email: _email,
                      password: _password,
                      formError: _formError,
                      onSignIn: _signIn,
                    )
                  : CompanionLinkedTvList(
                      accountEmail: _accountEmail,
                      tvs: widget.linkedTvs,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
