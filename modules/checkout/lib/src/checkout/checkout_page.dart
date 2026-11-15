import 'package:api/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../checkout_keys.dart';
import 'checkout_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

/// CheckoutPage runs a checkout session full screen from the draft the URL holds.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.bagIds,
    required this.slot,
    required this.onDraftChanged,
    required this.onClose,
    required this.onStartAgain,
    required this.onCompleted,
  });

  /// bagIds holds the bag ids from the URL, as written.
  final List<String> bagIds;

  /// slot holds the `slot` query from the URL, as written.
  final String? slot;

  /// onDraftChanged asks the app to replace the URL with these bags and slot.
  final void Function(List<String> bagIds, String? slot) onDraftChanged;
  final ValueChanged<List<String>> onClose;
  final void Function(List<String> bagIds, String? slot) onStartAgain;

  /// onCompleted asks the app to replace the URL with the order's.
  final ValueChanged<String> onCompleted;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    _sendLink();
  }

  @override
  void didUpdateWidget(CheckoutPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.bagIds, widget.bagIds) ||
        oldWidget.slot != widget.slot) {
      _sendLink();
    }
  }

  void _sendLink() => context.read<CheckoutBloc>().add(
    CheckoutLinkChanged(widget.bagIds, widget.slot),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (previous, current) =>
              current.needsCleanUrl &&
              (!previous.needsCleanUrl ||
                  !listEquals(previous.picked, current.picked) ||
                  previous.window != current.window),
          listener: (context, state) =>
              widget.onDraftChanged(state.picked, state.window?.slotParam),
        ),
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (previous, current) =>
              current.orderId != null && previous.orderId == null,
          listener: (context, state) => widget.onCompleted(state.orderId!),
        ),
      ],
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          final ready =
              state.status == CheckoutStatus.ready && state.picked.isNotEmpty;
          final expanded =
              WindowSizeClass.fromWidth(MediaQuery.sizeOf(context).width) ==
              WindowSizeClass.expanded;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                key: CheckoutKeys.close,
                tooltip: 'Close checkout',
                icon: const Icon(Icons.close),
                onPressed: () => widget.onClose(
                  state.status == CheckoutStatus.ready
                      ? state.picked
                      : widget.bagIds,
                ),
              ),
              title: const Text('Checkout'),
            ),
            body: SafeArea(
              child: ready
                  ? _ReadyView(
                      state: state,
                      expanded: expanded,
                      onWindowPicked: (window) =>
                          widget.onDraftChanged(state.picked, window.slotParam),
                    )
                  : _stateView(context, state),
            ),
            bottomNavigationBar: ready && !expanded
                ? _ConfirmBar(state: state)
                : null,
          );
        },
      ),
    );
  }

  Widget _stateView(BuildContext context, CheckoutState state) =>
      switch (state.status) {
        CheckoutStatus.loading || CheckoutStatus.completed =>
          const StateView.loading(title: 'Loading checkout'),
        CheckoutStatus.failed => StateView.error(
          title: 'Checkout could not load',
          message: 'Something went wrong. Try again.',
          actionLabel: 'Try again',
          actionKey: CheckoutKeys.retry,
          onAction: () => context.read<CheckoutBloc>().add(
            CheckoutLoadRequested(state.sessionId),
          ),
        ),
        CheckoutStatus.notFound => StateView.empty(
          icon: Icons.search_off,
          title: 'Checkout not found',
          message:
              'This checkout link does not work. Start a new checkout '
              'with the same bags.',
          actionLabel: 'Start again',
          actionKey: CheckoutKeys.startAgain,
          onAction: () => widget.onStartAgain(widget.bagIds, widget.slot),
        ),
        CheckoutStatus.expired => StateView.empty(
          icon: Icons.timer_off_outlined,
          title: 'This checkout expired',
          message:
              'A checkout lasts 15 minutes. Start again with the same '
              'bags.',
          actionLabel: 'Start again',
          actionKey: CheckoutKeys.startAgain,
          onAction: () => widget.onStartAgain(widget.bagIds, widget.slot),
        ),
        CheckoutStatus.ready => StateView.empty(
          icon: Icons.shopping_bag_outlined,
          title: 'No bags to check out',
          message: 'Pick up to ${BagSelection.maxBags} bags first.',
          actionLabel: 'Go to Bags',
          actionKey: CheckoutKeys.goToBags,
          onAction: () => widget.onClose(const []),
        ),
      };
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({
    required this.state,
    required this.expanded,
    required this.onWindowPicked,
  });

  static const _summaryWidth = 360.0;
  static const _maxWidth = 640.0;

  final CheckoutState state;
  final bool expanded;
  final ValueChanged<CollectionWindow> onWindowPicked;

  @override
  Widget build(BuildContext context) {
    final padding =
        WindowSizeClass.fromWidth(MediaQuery.sizeOf(context).width) ==
            WindowSizeClass.compact
        ? AppSpacing.lg
        : AppSpacing.xl;
    final details = SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: _Details(state: state, onWindowPicked: onWindowPicked),
        ),
      ),
    );
    if (!expanded) return details;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: details),
        SizedBox(
          width: _summaryWidth + padding,
          child: Padding(
            padding: EdgeInsets.only(top: padding, right: padding),
            child: _Summary(state: state),
          ),
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.state, required this.onWindowPicked});

  final CheckoutState state;
  final ValueChanged<CollectionWindow> onWindowPicked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final error = state.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (error != null) ...[
          InlineNotice(
            key: CheckoutKeys.errorNotice,
            message: _errorMessage(error),
            tone: InlineNoticeTone.error,
            icon: Icons.error_outline,
            dismissKey: CheckoutKeys.errorDismiss,
            onDismiss: () => context.read<CheckoutBloc>().add(
              const CheckoutErrorDismissed(),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        Text('Your bags', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        for (final bag in state.pickedBags) ...[
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(bag.name, style: theme.textTheme.titleMedium),
                ),
                PriceText(priceCents: bag.price.cents),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text('Collection window', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Collect your bags at ${state.pickedBags.first.store.name}.',
          style: muted,
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.windows.isEmpty)
          Text(
            'No collection windows are left. Try again tomorrow.',
            style: muted,
          ),
        for (final (day, windows) in _byDay(state.windows)) ...[
          Text(_dayLabel(day), style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final window in windows)
                WindowChip(
                  key: CheckoutKeys.window(window.slotParam),
                  label:
                      '${formatClock(window.start)}–'
                      '${formatClock(window.end)}',
                  semanticLabel:
                      '${_dayLabel(day)}, '
                      '${formatClock(window.start)} to '
                      '${formatClock(window.end)}',
                  selected: window == state.window,
                  onTap: () => onWindowPicked(window),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        const SizedBox(height: AppSpacing.sm),
        Text('Pay with', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        for (final card in state.savedCards) ...[
          SavedCardTile(
            key: CheckoutKeys.card(card.id),
            label: '${card.brand} •••• ${card.last4}',
            semanticLabel: '${card.brand} ending in ${card.last4}',
            selected: (state.pendingCardId ?? state.cardId) == card.id,
            busy: state.pendingCardId == card.id,
            onTap: () =>
                context.read<CheckoutBloc>().add(CheckoutCardPicked(card.id)),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }

  String _dayLabel(DateTime day) {
    final today = state.today;
    if (today == null) return '${day.day}/${day.month}';
    return switch (day.difference(today).inHours ~/ 24) {
      0 => 'Today',
      1 => 'Tomorrow',
      _ => '${day.day}/${day.month}',
    };
  }

  static List<(DateTime, List<CollectionWindow>)> _byDay(
    List<CollectionWindow> windows,
  ) {
    final days = <DateTime, List<CollectionWindow>>{};
    for (final window in windows) {
      final local = window.start.toLocal();
      days
          .putIfAbsent(DateTime(local.year, local.month, local.day), () => [])
          .add(window);
    }
    return [for (final MapEntry(:key, :value) in days.entries) (key, value)];
  }

  static String _errorMessage(CheckoutError error) => switch (error) {
    CheckoutError.cardFailed => 'That card could not be used. Pick another.',
    CheckoutError.slotUnavailable =>
      'That time slot is no longer available, please select another time '
          'slot and confirm your order',
    CheckoutError.paymentMissing => 'Pick a card to pay with.',
    CheckoutError.invalidBags =>
      'These bags cannot be checked out. Close checkout and pick them again.',
    CheckoutError.confirmFailed => 'Checkout failed. Try again.',
  };
}

class _Summary extends StatelessWidget {
  const _Summary({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Order summary', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          for (final bag in state.pickedBags)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(bag.name, style: theme.textTheme.bodyLarge),
                  ),
                  Text(
                    formatZar(bag.price.cents),
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text('Total', style: theme.textTheme.titleMedium),
              ),
              Text(
                formatZar(state.total.cents),
                key: CheckoutKeys.summaryTotal,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ConfirmButton(state: state),
          _ConfirmHint(state: state),
        ],
      ),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding =
        WindowSizeClass.fromWidth(MediaQuery.sizeOf(context).width) ==
            WindowSizeClass.compact
        ? AppSpacing.lg
        : AppSpacing.xl;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          formatZar(state.total.cents),
                          key: CheckoutKeys.summaryTotal,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(child: _ConfirmButton(state: state)),
                  ],
                ),
                _ConfirmHint(state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      key: CheckoutKeys.confirm,
      label: 'Confirm order',
      loading: state.confirming,
      onPressed: state.canConfirm
          ? () => context.read<CheckoutBloc>().add(
              const CheckoutConfirmRequested(),
            )
          : null,
    );
  }
}

class _ConfirmHint extends StatelessWidget {
  const _ConfirmHint({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final missing = [
      if (state.window == null) 'a collection window',
      if (state.cardId == null && state.pendingCardId == null) 'a card',
    ];
    if (missing.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Text(
        'Pick ${missing.join(' and ')} to confirm.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
