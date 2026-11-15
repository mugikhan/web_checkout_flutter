import 'package:material_ui/material_ui.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// WindowChip is a selectable chip for one collection window.
class WindowChip extends StatelessWidget {
  const WindowChip({
    super.key,
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String semanticLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (background, foreground) = selected
        ? (scheme.primary, scheme.onPrimary)
        : (scheme.surfaceContainer, scheme.onSurface);

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: semanticLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: background,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: selected ? BorderSide.none : BorderSide(color: scheme.outline),
        ),
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: foreground,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
