import 'package:flutter/material.dart';

import '../accessibility/companion_accessibility.dart';
import '../theme/theme.dart';
import 'companion_platform.dart';
import 'companion_platform_back.dart';
import 'companion_platform_conventions.dart';

/// Companion scaffold chrome adapted per iOS / Android conventions (DSN-054).
///
/// Applies Dynamic Type clamping, SafeArea, companion page inset, and optional
/// tap-to-dismiss for the system keyboard. Optional [onBack] wires the platform
/// back affordance (iOS chevron; Android relies on system Back).
class CompanionPlatformShell extends StatelessWidget {
  const CompanionPlatformShell({
    super.key,
    required this.child,
    this.platform,
    this.onBack,
    this.dismissKeyboardOnTap = true,
    this.backgroundColor,
  });

  final Widget child;

  /// Override host platform for design galleries and tests.
  final CompanionPlatform? platform;

  /// When set, shows [CompanionPlatformBackAffordance] above [child].
  final VoidCallback? onBack;

  /// When true, taps outside fields unfocus and hide the system IME.
  final bool dismissKeyboardOnTap;

  final Color? backgroundColor;

  CompanionPlatformConventions get conventions =>
      CompanionPlatformConventions.of(platform);

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    assert(
      conventions.enforceSafeArea,
      'Companion shells always honor SafeArea (DSN-054).',
    );
    assert(
      conventions.usesSystemKeyboard,
      'Companion shells always use the system keyboard (DSN-054).',
    );

    Widget content = child;
    if (onBack != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanionPlatformBackAffordance(
            platform: platform,
            onBack: onBack!,
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: content),
        ],
      );
    }

    Widget body = SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.insetPageCompanion),
        child: content,
      ),
    );

    if (dismissKeyboardOnTap) {
      body = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: body,
      );
    }

    return CompanionAccessibleScope(
      child: Scaffold(
        backgroundColor: backgroundColor ?? brand.cloud,
        body: body,
      ),
    );
  }
}
