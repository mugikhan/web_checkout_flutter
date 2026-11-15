import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../checkout_keys.dart';
import 'checkout_start_bloc.dart';
import 'checkout_start_event.dart';
import 'checkout_start_state.dart';

/// CheckoutStartPage creates a checkout session and hands its id to the app.
class CheckoutStartPage extends StatelessWidget {
  const CheckoutStartPage({
    super.key,
    required this.onStarted,
    required this.onClose,
  });

  /// onStarted asks the app to replace the URL with the new session's.
  final ValueChanged<String> onStarted;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutStartBloc, CheckoutStartState>(
      listenWhen: (previous, current) =>
          current.status == CheckoutStartStatus.started &&
          previous.status != CheckoutStartStatus.started,
      listener: (context, state) => onStarted(state.sessionId!),
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: CheckoutKeys.close,
            tooltip: 'Close checkout',
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
          title: const Text('Checkout'),
        ),
        body: SafeArea(
          child: state.status == CheckoutStartStatus.failed
              ? StateView.error(
                  title: 'Checkout could not start',
                  message: 'Something went wrong. Try again.',
                  actionLabel: 'Try again',
                  actionKey: CheckoutKeys.startRetry,
                  onAction: () => context.read<CheckoutStartBloc>().add(
                    const CheckoutStartRequested(),
                  ),
                )
              : const StateView.loading(title: 'Starting checkout'),
        ),
      ),
    );
  }
}
