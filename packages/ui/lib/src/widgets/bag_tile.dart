import 'package:material_ui/material_ui.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'price_text.dart';

/// BagTile is a selectable card for one bag, with a disabled state and hint.
class BagTile extends StatelessWidget {
  const BagTile({
    super.key,
    required this.title,
    required this.description,
    required this.priceCents,
    required this.worthCents,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    this.hint,
  });

  final String title;
  final String description;
  final int priceCents;
  final int worthCents;
  final bool selected;
  final VoidCallback onTap;

  /// A disabled tile ignores taps and keeps its content readable.
  final bool enabled;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onSurfaceVariant,
    );
    final hint = this.hint;

    return Semantics(
      container: true,
      button: true,
      checked: selected,
      enabled: enabled,
      label: '$title, ${PriceText.semanticLabel(priceCents, worthCents)}',
      hint: hint,
      excludeSemantics: true,
      onTap: enabled ? onTap : null,
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
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(description, style: muted),
                      const SizedBox(height: AppSpacing.md),
                      PriceText(priceCents: priceCents, worthCents: worthCents),
                      if (hint != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(hint, style: muted),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected
                      ? scheme.primary
                      : enabled
                      ? scheme.onSurfaceVariant
                      : scheme.onSurface.withValues(alpha: 0.38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
