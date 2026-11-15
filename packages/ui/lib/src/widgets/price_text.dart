import 'package:material_ui/material_ui.dart';

import '../format/money_format.dart';
import '../tokens/app_spacing.dart';

/// PriceText shows a ZAR price, followed by its worth crossed out.
class PriceText extends StatelessWidget {
  const PriceText({super.key, required this.priceCents, this.worthCents});

  final int priceCents;
  final int? worthCents;

  /// semanticLabel reads the price, then the worth, with no strike-through mark.
  static String semanticLabel(int priceCents, int? worthCents) =>
      worthCents == null
      ? formatZar(priceCents)
      : '${formatZar(priceCents)}, worth ${formatZar(worthCents)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final worth = worthCents;

    return Semantics(
      label: semanticLabel(priceCents, worth),
      excludeSemantics: true,
      child: Wrap(
        spacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(
            formatZar(priceCents),
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
            ),
          ),
          if (worth != null)
            Text(
              formatZar(worth),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                decoration: TextDecoration.lineThrough,
                decorationColor: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
