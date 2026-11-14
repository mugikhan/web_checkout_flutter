import 'package:material_ui/material_ui.dart';

import '../tokens/app_radius.dart';

enum AppButtonVariant { primary, secondary, ghost }

/// AppButton is the only button widget screens use.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  /// While loading, the button shows a spinner and ignores taps.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (variant) {
      AppButtonVariant.primary => (scheme.primary, scheme.onPrimary),
      AppButtonVariant.secondary => (Colors.transparent, scheme.onSurface),
      AppButtonVariant.ghost => (Colors.transparent, scheme.onSurface),
    };
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      side: variant == AppButtonVariant.secondary
          ? BorderSide(color: scheme.outline)
          : BorderSide.none,
    );
    // Keep the enabled colours while loading, so the button does not flash grey.
    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) && !loading
            ? scheme.onSurface.withValues(alpha: 0.12)
            : background,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) && !loading
            ? scheme.onSurface.withValues(alpha: 0.38)
            : foreground,
      ),
      minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
      shape: WidgetStatePropertyAll(shape),
      textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge),
    );

    return Semantics(
      label: loading ? '$label, loading' : null,
      excludeSemantics: loading,
      button: true,
      child: TextButton(
        style: style,
        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              )
            : Text(label),
      ),
    );
  }
}
