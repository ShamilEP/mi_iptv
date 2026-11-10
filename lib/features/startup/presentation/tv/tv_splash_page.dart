import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';

/// TV Splash / Startup hi-fi shell (DSN-030).
///
/// Minimal brand identity on Ink: centered [BrandLockup], short hold, optional
/// fast fade-in. No long animation or marketing sequence.
class TvSplashPage extends StatefulWidget {
  const TvSplashPage({
    super.key,
    this.onFinished,
    this.hold = AppMotion.splashHold,
    this.markHeight = 96,
  }) : assert(markHeight >= BrandAssets.minMarkSize);

  /// Fired once after the identity hold (and fade, if any).
  final VoidCallback? onFinished;

  /// Time the lockup remains visible before [onFinished].
  final Duration hold;

  /// Mark height for the centered lockup (hero-level, still compact).
  final double markHeight;

  @override
  State<TvSplashPage> createState() => _TvSplashPageState();
}

class _TvSplashPageState extends State<TvSplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
  );
  Timer? _holdTimer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final reduce = AppMotion.reduceMotion(context);
      if (reduce) {
        _fade.value = 1;
        _complete();
      } else {
        _fade.forward().whenComplete(() {
          if (!mounted) return;
          _armHold(widget.hold);
        });
      }
    });
  }

  void _armHold(Duration hold) {
    _holdTimer?.cancel();
    _holdTimer = Timer(hold, _complete);
  }

  void _complete() {
    if (_finished || !mounted) return;
    _finished = true;
    widget.onFinished?.call();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;

    return Scaffold(
      backgroundColor: brand.ink,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: BrandLockup(markHeight: widget.markHeight),
          ),
        ),
      ),
    );
  }
}
