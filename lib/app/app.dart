import 'package:flutter/material.dart';

import '../core/accessibility/companion_accessibility.dart';
import '../core/images/image_pipeline_route_observer.dart';
import '../core/l10n/app_locale.dart';
import '../core/l10n/app_locale_scope.dart';
import '../core/l10n/app_string_catalog.dart';
import '../core/l10n/app_string_key.dart';
import '../core/l10n/locale_controller.dart';
import '../core/theme/theme.dart';
import '../features/player/presentation/playback_session_lifecycle_binder.dart';
import 'client_kind.dart';
import 'di/app_dependencies.dart';
import 'navigation/app_navigator.dart';
import 'navigation/app_routes.dart';

/// Root application widget. [clientKind] selects TV vs Companion (ADR-001).
class MiIptvApp extends StatefulWidget {
  const MiIptvApp({
    super.key,
    this.clientKind = ClientKind.tv,
    this.initialRoute,
    this.localeController,
  });

  final ClientKind clientKind;

  /// Override for widget tests that skip the TV splash gate.
  final String? initialRoute;

  /// Optional locale controller (CMP-008). Defaults to DI when mounted.
  final LocaleController? localeController;

  @override
  State<MiIptvApp> createState() => _MiIptvAppState();
}

class _MiIptvAppState extends State<MiIptvApp> {
  late final LocaleController _locales;
  late final bool _ownsLocales;

  bool get _isCompanion => widget.clientKind == ClientKind.companion;

  String get _defaultInitialRoute =>
      _isCompanion ? AppRoutes.home : AppRoutes.tvSplash;

  @override
  void initState() {
    super.initState();
    if (widget.localeController != null) {
      _locales = widget.localeController!;
      _ownsLocales = false;
    } else if (AppDependencies.isMounted) {
      _locales = AppDependencies.instance.localeController;
      _ownsLocales = false;
    } else {
      _locales = LocaleController();
      _ownsLocales = true;
    }
    _locales.addListener(_onLocale);
    if (_isCompanion) {
      // ignore: discarded_futures
      _locales.hydrate();
    }
  }

  @override
  void dispose() {
    _locales.removeListener(_onLocale);
    if (_ownsLocales) {
      _locales.dispose();
    }
    super.dispose();
  }

  void _onLocale() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final observers = <NavigatorObserver>[
      if (AppDependencies.isMounted)
        ImagePipelineRouteObserver(AppDependencies.instance.imagePipeline),
    ];
    final title = _isCompanion
        ? AppStringCatalog.of(
            AppStringKey.appNameCompanion,
            _locales.locale,
          )
        : 'Mi IPTV';

    Widget app = MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: _isCompanion ? AppTheme.companionLight() : AppTheme.tvDark(),
      locale: _isCompanion ? _locales.locale.toFlutterLocale : null,
      supportedLocales: _isCompanion
          ? AppLocale.supported
              .map((locale) => locale.toFlutterLocale)
              .toList(growable: false)
          : const <Locale>[Locale('en')],
      builder: (context, child) {
        Widget built = child ?? const SizedBox.shrink();
        if (_isCompanion) {
          built = CompanionAccessibleScope(child: built);
        } else if (AppDependencies.isMounted) {
          // TV-052: forward app background/foreground to session coordinator.
          built = PlaybackSessionLifecycleBinder(
            coordinator: AppDependencies.instance.playbackSession,
            child: built,
          );
        }
        return built;
      },
      // TV-020: splash gate inspects JWT then routes Home / Onboarding.
      initialRoute: widget.initialRoute ?? _defaultInitialRoute,
      navigatorObservers: observers,
      onGenerateRoute: (settings) => AppNavigator.onGenerateRoute(
        settings,
        clientKind: widget.clientKind,
      ),
    );

    if (_isCompanion) {
      app = AppLocaleScope(controller: _locales, child: app);
    }
    return app;
  }
}
