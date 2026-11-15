import 'package:ui/ui.dart';

import '../app_keys.dart';

/// OrderPlaceholderPage confirms a placed order until `order-details` builds the real page.
class OrderPlaceholderPage extends StatelessWidget {
  const OrderPlaceholderPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Order placed', style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Order number',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              orderId,
              key: AppKeys.orderId,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
