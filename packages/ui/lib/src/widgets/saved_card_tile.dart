import 'package:material_ui/material_ui.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// SavedCardTile is a selectable tile for one saved card, with a busy state.
class SavedCardTile extends StatelessWidget {
  const SavedCardTile({
    super.key,
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.onTap,
    this.busy = false,
  });

  final String label;
  final String semanticLabel;
  final bool selected;
  final VoidCallback onTap;

  /// busy shows a progress indicator while the card's request runs.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: semanticLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: scheme.surfaceContainer,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: selected
              ? BorderSide(color: scheme.primary, width: 2)
              : BorderSide(color: scheme.outline),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(Icons.credit_card, color: scheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                if (busy)
                  const SizedBox.square(
                    dimension: 24,
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
