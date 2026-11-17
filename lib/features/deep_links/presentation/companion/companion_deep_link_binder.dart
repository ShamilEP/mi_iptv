import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/di/app_dependencies.dart';
import '../../../../app/navigation/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/session_token_store.dart';
import '../../../catalog/presentation/companion/companion_explore_connectivity_binder.dart';
import '../../data/memory_deep_link_ingress.dart';
import '../../data/method_channel_deep_link_ingress.dart';
import '../../domain/deep_link_ingress.dart';
import '../../domain/deep_link_parse_result.dart';
import '../../domain/deep_link_parser.dart';
import '../../domain/deep_link_target.dart';

/// Companion home: listens for deep links and drives Explore (CMP-050).
class CompanionDeepLinkBinder extends StatefulWidget {
  const CompanionDeepLinkBinder({
    super.key,
    this.ingress,
    this.sessionTokenStore,
  });

  final DeepLinkIngress? ingress;
  final SessionTokenStore? sessionTokenStore;

  @override
  State<CompanionDeepLinkBinder> createState() =>
      _CompanionDeepLinkBinderState();
}

class _CompanionDeepLinkBinderState extends State<CompanionDeepLinkBinder> {
  DeepLinkIngress? _ownedIngress;
  StreamSubscription<Uri>? _sub;
  String? _pendingItemId;
  String? _deepLinkError;

  DeepLinkIngress get _ingress {
    if (widget.ingress != null) return widget.ingress!;
    return _ownedIngress ??= MethodChannelDeepLinkIngress();
  }

  SessionTokenStore? get _sessions {
    if (widget.sessionTokenStore != null) return widget.sessionTokenStore;
    if (AppDependencies.isMounted) {
      return AppDependencies.instance.sessionTokenStore;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _sub = _ingress.onLink.listen(_onUri);
    unawaited(_consumeInitial());
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    final owned = _ownedIngress;
    if (owned is MethodChannelDeepLinkIngress) {
      unawaited(owned.dispose());
    } else if (owned is MemoryDeepLinkIngress) {
      unawaited(owned.dispose());
    }
    super.dispose();
  }

  Future<void> _consumeInitial() async {
    final uri = await _ingress.initialLink();
    if (uri != null && mounted) {
      await _onUri(uri);
    }
  }

  Future<void> _onUri(Uri uri) async {
    final parsed = DeepLinkParser.parse(uri);
    if (parsed is! DeepLinkParseSuccess) {
      setState(() {
        _deepLinkError = CompanionDeepLinkCopy.unsupportedLink;
        _pendingItemId = null;
      });
      return;
    }

    final signedIn = await _isSignedIn();
    if (!signedIn) {
      if (!mounted) return;
      await Navigator.of(context).pushNamed(AppRoutes.companionLogin);
      if (!mounted) return;
      final after = await _isSignedIn();
      if (!after) {
        setState(() {
          _deepLinkError = CompanionDeepLinkCopy.signInRequired;
          _pendingItemId = null;
        });
        return;
      }
    }

    _applyTarget(parsed.target);
  }

  Future<bool> _isSignedIn() async {
    final store = _sessions;
    if (store == null) return true;
    final tokens = await store.read();
    return tokens != null;
  }

  void _applyTarget(DeepLinkTarget target) {
    setState(() {
      _pendingItemId = target.id;
      _deepLinkError = null;
    });
  }

  void _onMiss() {
    setState(() {
      _deepLinkError = CompanionDeepLinkCopy.contentNotFound;
      _pendingItemId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_deepLinkError != null)
          Material(
            color: brand.warning.withValues(alpha: 0.15),
            child: ListTile(
              key: const ValueKey<String>('deep-link-error'),
              title: Text(
                _deepLinkError!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: brand.ink),
              ),
              trailing: IconButton(
                key: const ValueKey<String>('deep-link-error-dismiss'),
                onPressed: () => setState(() => _deepLinkError = null),
                icon: Icon(Icons.close, color: brand.ink),
              ),
            ),
          ),
        Expanded(
          child: CompanionExploreConnectivityBinder(
            initialItemId: _pendingItemId,
            onDeepLinkMiss: _onMiss,
          ),
        ),
      ],
    );
  }
}

/// User-visible deep-link messages (CMP-050).
abstract final class CompanionDeepLinkCopy {
  static const String unsupportedLink = 'This link is not supported.';
  static const String contentNotFound = 'That title or channel was not found.';
  static const String signInRequired = 'Sign in to open this link.';
}
