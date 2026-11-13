import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/di/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/startup_destination.dart';
import '../../domain/usecases/resolve_startup_destination.dart';
import '../../domain/usecases/run_tv_startup.dart';
import '../../domain/usecases/warm_local_media.dart';
import 'tv_splash_page.dart';

/// TV splash + startup routing gate (TV-020).
///
/// Shows [TvSplashPage] while warming local media and inspecting the stored
/// JWT, then [pushReplacementNamed] to Home or Onboarding. Navigation waits for
/// **both** the short splash hold and startup work — no long animation.
class TvStartupGate extends StatefulWidget {
  const TvStartupGate({
    super.key,
    this.runStartup,
    this.splashHold,
  });

  /// Injectable for tests. Defaults to DI-backed [RunTvStartup].
  final Future<StartupDestination> Function()? runStartup;

  /// Override splash hold (tests). Defaults to [TvSplashPage] motion.
  final Duration? splashHold;

  @override
  State<TvStartupGate> createState() => _TvStartupGateState();
}

class _TvStartupGateState extends State<TvStartupGate> {
  StartupDestination? _destination;
  bool _splashDone = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<StartupDestination> _defaultRun() {
    final deps = AppDependencies.instance;
    return RunTvStartup(
      warmLocalMedia: WarmLocalMedia(deps.localMediaStore),
      resolveDestination:
          ResolveStartupDestination(deps.sessionTokenStore),
    ).call();
  }

  Future<void> _run() async {
    try {
      final run = widget.runStartup ?? _defaultRun;
      final destination = await run();
      if (!mounted) return;
      setState(() => _destination = destination);
      _maybeNavigate();
    } on Object {
      if (!mounted) return;
      // Fail closed to onboarding — never block on warm/read errors.
      setState(() => _destination = StartupDestination.onboarding);
      _maybeNavigate();
    }
  }

  void _onSplashFinished() {
    _splashDone = true;
    _maybeNavigate();
  }

  void _maybeNavigate() {
    if (_navigated || !_splashDone || _destination == null) return;
    if (!mounted) return;
    _navigated = true;
    final route = switch (_destination!) {
      StartupDestination.home => AppRoutes.home,
      StartupDestination.onboarding => AppRoutes.tvOnboarding,
    };
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return TvSplashPage(
      hold: widget.splashHold ?? AppMotion.splashHold,
      onFinished: _onSplashFinished,
    );
  }
}
