import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import 'tv_profile_edit_panel.dart';
import 'tv_profile_models.dart';
import 'tv_profile_tile.dart';

/// TV profile picker / management design shell (DSN-061).
///
/// Launch picker, create/edit forms, and kid-profile visual cues (badge +
/// icon — not hue alone). Release 1 design shell; not MVP ship scope.
class TvProfilePickerPage extends StatefulWidget {
  const TvProfilePickerPage({
    super.key,
    this.profiles = demoProfiles,
    this.initialMode = TvProfileScreenMode.picker,
    this.managing = false,
    this.onProfileSelected,
  });

  final List<TvProfile> profiles;
  final TvProfileScreenMode initialMode;
  final bool managing;
  final ValueChanged<TvProfile>? onProfileSelected;

  @override
  State<TvProfilePickerPage> createState() => _TvProfilePickerPageState();
}

class _TvProfilePickerPageState extends State<TvProfilePickerPage> {
  late List<TvProfile> _profiles = List<TvProfile>.of(widget.profiles);
  late TvProfileScreenMode _mode = widget.initialMode;
  late bool _managing = widget.managing;
  TvProfile? _editing;
  final Map<String, FocusNode> _tileNodes = <String, FocusNode>{};

  FocusNode _nodeFor(String id) =>
      _tileNodes.putIfAbsent(id, FocusNode.new);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _mode != TvProfileScreenMode.picker) return;
      if (_profiles.isEmpty) return;
      _nodeFor(_profiles.first.id).requestFocus();
    });
  }

  @override
  void dispose() {
    for (final node in _tileNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _openCreate() {
    setState(() {
      _mode = TvProfileScreenMode.create;
      _editing = TvProfile(
        id: 'p-${DateTime.now().millisecondsSinceEpoch}',
        name: '',
        initials: '?',
      );
    });
  }

  void _openEdit(TvProfile profile) {
    setState(() {
      _mode = TvProfileScreenMode.edit;
      _editing = profile;
    });
  }

  void _onTilePressed(TvProfile profile) {
    if (_managing) {
      _openEdit(profile);
      return;
    }
    widget.onProfileSelected?.call(profile);
  }

  void _save(TvProfile profile) {
    setState(() {
      final index = _profiles.indexWhere((p) => p.id == profile.id);
      if (index >= 0) {
        _profiles = List<TvProfile>.of(_profiles)..[index] = profile;
      } else {
        _profiles = <TvProfile>[..._profiles, profile];
      }
      _mode = TvProfileScreenMode.picker;
      _editing = null;
      _managing = true;
    });
  }

  void _delete() {
    final editing = _editing;
    if (editing == null) return;
    setState(() {
      _profiles = _profiles.where((p) => p.id != editing.id).toList();
      _mode = TvProfileScreenMode.picker;
      _editing = null;
    });
  }

  void _cancelEdit() {
    setState(() {
      _mode = TvProfileScreenMode.picker;
      _editing = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final editing = _editing;

    return TvAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.ink,
        body: Padding(
          padding: AppOverscan.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const BrandLockup(markHeight: AppSpacing.xxl),
                  const Spacer(),
                  if (_mode == TvProfileScreenMode.picker)
                    MiButton(
                      key: const ValueKey<String>('profile-manage'),
                      label: _managing
                          ? TvProfileCopy.doneManageLabel
                          : TvProfileCopy.manageLabel,
                      emphasis: ControlEmphasis.secondary,
                      onPressed: () =>
                          setState(() => _managing = !_managing),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (_mode == TvProfileScreenMode.picker) ...[
                Text(
                  TvProfileCopy.pickerTitle,
                  style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
                ),
                const SizedBox(height: AppSpacing.stackTight),
                Text(
                  TvProfileCopy.pickerSubtitle,
                  style: textTheme.bodyLarge?.copyWith(color: brand.mist),
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < _profiles.length; i++) ...[
                            TvProfileTile(
                              profile: _profiles[i],
                              managing: _managing,
                              focusNode: _nodeFor(_profiles[i].id),
                              onPressed: () => _onTilePressed(_profiles[i]),
                            ),
                            const SizedBox(width: AppGrid.gutter),
                          ],
                          TvAddProfileTile(
                            focusNode: _nodeFor('add'),
                            onPressed: _openCreate,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else if (editing != null) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: TvProfileEditPanel(
                      mode: _mode,
                      initial: editing,
                      onSave: _save,
                      onCancel: _cancelEdit,
                      onDelete: _mode == TvProfileScreenMode.edit
                          ? _delete
                          : null,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
