import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/focusable_surface.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_text_field.dart';
import 'tv_profile_models.dart';

/// Create / edit form for a profile (DSN-061).
class TvProfileEditPanel extends StatefulWidget {
  const TvProfileEditPanel({
    super.key,
    required this.mode,
    required this.initial,
    required this.onSave,
    required this.onCancel,
    this.onDelete,
  });

  final TvProfileScreenMode mode;
  final TvProfile initial;
  final ValueChanged<TvProfile> onSave;
  final VoidCallback onCancel;
  final VoidCallback? onDelete;

  @override
  State<TvProfileEditPanel> createState() => _TvProfileEditPanelState();
}

class _TvProfileEditPanelState extends State<TvProfileEditPanel> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initial.name);
  late bool _isKid = widget.initial.isKid;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String _initialsFor(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }

  void _save() {
    final name = MiTextField.sanitize(_name.text).trim();
    if (name.isEmpty) return;
    widget.onSave(
      widget.initial.copyWith(
        name: name,
        initials: _initialsFor(name),
        isKid: _isKid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final title = widget.mode == TvProfileScreenMode.create
        ? TvProfileCopy.createTitle
        : TvProfileCopy.editTitle;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(color: brand.cloud),
          ),
          const SizedBox(height: AppSpacing.lg),
          MiTextField(
            key: const ValueKey<String>('profile-name-field'),
            controller: _name,
            label: TvProfileCopy.nameLabel,
            hint: TvProfileCopy.nameHint,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            TvProfileCopy.kidToggleLabel,
            style: textTheme.titleSmall?.copyWith(color: brand.cloud),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            TvProfileCopy.kidToggleHint,
            style: textTheme.bodyMedium?.copyWith(color: brand.mist),
          ),
          const SizedBox(height: AppSpacing.sm),
          _KidToggle(
            value: _isKid,
            onChanged: (value) => setState(() => _isKid = value),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              MiButton(
                key: const ValueKey<String>('profile-save'),
                label: TvProfileCopy.saveLabel,
                onPressed: _save,
              ),
              const SizedBox(width: AppSpacing.md),
              MiButton(
                key: const ValueKey<String>('profile-cancel'),
                label: TvProfileCopy.cancelLabel,
                emphasis: ControlEmphasis.secondary,
                onPressed: widget.onCancel,
              ),
              if (widget.onDelete != null) ...[
                const Spacer(),
                MiButton(
                  key: const ValueKey<String>('profile-delete'),
                  label: TvProfileCopy.deleteLabel,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: widget.onDelete,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _KidToggle extends StatelessWidget {
  const _KidToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return FocusableSurface(
      key: const ValueKey<String>('profile-kid-toggle'),
      kind: FocusControlKind.chip,
      fill: value ? brand.warning.withValues(alpha: 0.18) : brand.surface,
      borderRadius: AppRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      onPressed: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            value ? Icons.check_box : Icons.check_box_outline_blank,
            color: value ? brand.warning : brand.mist,
            size: AppSpacing.lg,
            semanticLabel: TvProfileCopy.kidToggleLabel,
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.child_care,
            color: value ? brand.warning : brand.mist,
            size: AppSpacing.lg,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            TvProfileCopy.kidsBadge,
            style: textTheme.titleSmall?.copyWith(
              color: value ? brand.warning : brand.mist,
            ),
          ),
        ],
      ),
    );
  }
}
