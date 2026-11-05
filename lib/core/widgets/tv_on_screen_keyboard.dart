import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'mi_text_field.dart';
import 'tv_osk_key.dart';
import 'type_from_phone_hint.dart';

/// TV on-screen keyboard with letter focus model, Companion shortcut, and
/// optional masked password entry (DSN-014 / SRS §11).
class TvOnScreenKeyboard extends StatefulWidget {
  const TvOnScreenKeyboard({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmit,
    this.onTypeFromPhone,
    this.obscureText = false,
    this.fieldLabel,
    this.hint,
    this.showTypeFromPhoneHint = true,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;
  final VoidCallback? onTypeFromPhone;

  /// When true, field text is masked (password entry).
  final bool obscureText;

  final String? fieldLabel;
  final String? hint;
  final bool showTypeFromPhoneHint;

  /// Default letter rows (uppercase) — focus travels left/right then down.
  static const List<String> letterRows = <String>[
    'ABCDEFGHIJ',
    'KLMNOPQRST',
    'UVWXYZ',
  ];

  @override
  State<TvOnScreenKeyboard> createState() => TvOnScreenKeyboardState();
}

class TvOnScreenKeyboardState extends State<TvOnScreenKeyboard> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  bool _shift = false;

  String get text => _controller.text;

  bool get isObscured => widget.obscureText;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _emit() {
    widget.onChanged?.call(_controller.text);
    setState(() {});
  }

  void insertCharacter(String raw) {
    final char = _shift ? raw.toUpperCase() : raw.toLowerCase();
    final next = MiTextField.sanitize(_controller.text + char);
    _controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
    _emit();
  }

  void backspace() {
    final value = _controller.text;
    if (value.isEmpty) return;
    final next = value.substring(0, value.length - 1);
    _controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
    _emit();
  }

  void insertSpace() => insertCharacter(' ');

  void toggleShift() => setState(() => _shift = !_shift);

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MiTextField(
            controller: _controller,
            label: widget.fieldLabel,
            hint: widget.hint,
            obscureText: widget.obscureText,
            onChanged: (_) => _emit(),
          ),
          if (widget.showTypeFromPhoneHint) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: FocusTraversalOrder(
                order: const NumericFocusOrder(-1),
                child: TypeFromPhoneHint(
                  onPressed: widget.onTypeFromPhone,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          for (var rowIndex = 0;
              rowIndex < TvOnScreenKeyboard.letterRows.length;
              rowIndex++) ...[
            if (rowIndex > 0) const SizedBox(height: AppSpacing.xs),
            _LetterRow(
              letters: TvOnScreenKeyboard.letterRows[rowIndex],
              shift: _shift,
              rowIndex: rowIndex,
              onLetter: insertCharacter,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: FocusTraversalOrder(
                  order: const NumericFocusOrder(100),
                  child: TvOskKey(
                    label: _shift ? 'ABC' : 'abc',
                    semanticLabel: 'Shift',
                    expanded: true,
                    onPressed: toggleShift,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                flex: 2,
                child: FocusTraversalOrder(
                  order: const NumericFocusOrder(101),
                  child: TvOskKey(
                    label: 'Space',
                    expanded: true,
                    onPressed: insertSpace,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: FocusTraversalOrder(
                  order: const NumericFocusOrder(102),
                  child: TvOskKey(
                    label: '⌫',
                    semanticLabel: 'Backspace',
                    expanded: true,
                    onPressed: backspace,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: FocusTraversalOrder(
                  order: const NumericFocusOrder(103),
                  child: TvOskKey(
                    label: 'OK',
                    semanticLabel: 'Submit',
                    expanded: true,
                    onPressed: widget.onSubmit,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'D-pad: move between keys · Select to type',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: brand.mist,
                ),
          ),
        ],
      ),
    );
  }
}

class _LetterRow extends StatelessWidget {
  const _LetterRow({
    required this.letters,
    required this.shift,
    required this.rowIndex,
    required this.onLetter,
  });

  final String letters;
  final bool shift;
  final int rowIndex;
  final ValueChanged<String> onLetter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < letters.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xxs),
          FocusTraversalOrder(
            order: NumericFocusOrder((rowIndex * 20 + i).toDouble()),
            child: TvOskKey(
              label: shift ? letters[i] : letters[i].toLowerCase(),
              autofocus: rowIndex == 0 && i == 0,
              onPressed: () => onLetter(letters[i]),
            ),
          ),
        ],
      ],
    );
  }
}
