import 'package:material_ui/material_ui.dart';

/// AppTextField is the only text input screens use.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.autofillHints,
  });

  /// The label shows above the input and doubles as its semantic label.
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      decoration: InputDecoration(labelText: label, errorText: errorText),
    );
  }
}
