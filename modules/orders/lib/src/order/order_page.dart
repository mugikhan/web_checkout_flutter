import 'package:api/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../orders_keys.dart';
import 'order_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';

const _declineReason =
    'The payment was declined and you were not charged. '
    'Try placing the order again';

/// OrderPage shows one order, follows its status and leads back to Bags.
class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.onBackToBags});

  /// onBackToBags asks the app to open Bags with no bags picked.
  final VoidCallback onBackToBags;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) => switch (state.status) {
        OrderLoadStatus.loading => const StateView.loading(
          title: 'Loading order',
        ),
        OrderLoadStatus.failed => StateView.error(
          title: 'Order could not load',
          message: 'Something went wrong. Try again.',
          actionLabel: 'Try again',
          actionKey: OrdersKeys.retry,
          onAction: () =>
              context.read<OrderBloc>().add(OrderLoadRequested(state.orderId)),
        ),
        OrderLoadStatus.notFound => StateView.empty(
          icon: Icons.search_off,
          title: 'Order not found',
          message: 'Check the link, or go back to Bags.',
          actionLabel: 'Back to bags',
          actionKey: OrdersKeys.backToBags,
          onAction: onBackToBags,
        ),
        OrderLoadStatus.loaded => _OrderDetails(
          order: state.order!,
          onBackToBags: onBackToBags,
        ),
      },
    );
  }
}

class _OrderDetails extends StatefulWidget {
  const _OrderDetails({required this.order, required this.onBackToBags});

  final Order order;
  final VoidCallback onBackToBags;

  @override
  State<_OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<_OrderDetails> {
  bool _reasonDismissed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final order = widget.order;
    final window = order.window;
    final padding =
        WindowSizeClass.fromWidth(MediaQuery.sizeOf(context).width) ==
            WindowSizeClass.compact
        ? AppSpacing.lg
        : AppSpacing.xl;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Order placed', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text('Order number', style: muted),
              Text(
                order.id,
                key: OrdersKeys.orderId,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Status', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: StatusTimeline(
                  key: OrdersKeys.timeline,
                  steps: _steps(order),
                ),
              ),
              if (order.status == OrderStatus.failed && !_reasonDismissed) ...[
                const SizedBox(height: AppSpacing.lg),
                InlineNotice(
                  key: OrdersKeys.declineNotice,
                  message: _declineReason,
                  tone: InlineNoticeTone.error,
                  icon: Icons.error_outline,
                  dismissKey: OrdersKeys.declineDismiss,
                  onDismiss: () => setState(() => _reasonDismissed = true),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Text('Store', style: muted),
              Text(
                order.store,
                key: OrdersKeys.store,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Your bags', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              for (final bag in order.bags) ...[
                AppCard(
                  key: OrdersKeys.bag(bag.id),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          bag.name,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        formatZar(bag.price.cents),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text('Total', style: theme.textTheme.titleMedium),
                  ),
                  Text(
                    formatZar(order.total.cents),
                    key: OrdersKeys.total,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Collection window', style: muted),
              Text(
                '${window.start.toLocal().day}/${window.start.toLocal().month}, '
                '${formatClock(window.start)}–${formatClock(window.end)}',
                key: OrdersKeys.window,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Paid with', style: muted),
              Text(
                '${order.card.brand} •••• ${order.card.last4}',
                key: OrdersKeys.card,
                style: theme.textTheme.titleMedium,
              ),
              if (order.isSettled) ...[
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  key: OrdersKeys.backToBags,
                  label: 'Back to bags',
                  onPressed: widget.onBackToBags,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static List<TimelineStep> _steps(Order order) {
    final created = formatClock(order.createdAt);
    final settled = formatClock(order.holdConfirmsAt);
    final started = order.status != OrderStatus.created;
    return [
      TimelineStep(
        label: 'Created',
        state: TimelineStepState.reached,
        timeText: created,
      ),
      TimelineStep(
        label: 'Pending',
        state: started ? TimelineStepState.reached : TimelineStepState.upcoming,
        timeText: created,
      ),
      switch (order.status) {
        OrderStatus.failed => TimelineStep(
          label: 'Failed',
          state: TimelineStepState.failed,
          timeText: settled,
        ),
        OrderStatus.confirmed => TimelineStep(
          label: 'Confirmed',
          state: TimelineStepState.reached,
          timeText: settled,
        ),
        OrderStatus.created || OrderStatus.pending => const TimelineStep(
          label: 'Confirmed',
          state: TimelineStepState.upcoming,
        ),
      },
    ];
  }
}
