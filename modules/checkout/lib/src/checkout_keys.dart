import 'package:ui/ui.dart';

/// CheckoutKeys holds the test keys for the checkout module's widgets.
abstract final class CheckoutKeys {
  static const close = Key('checkout-close');
  static Key window(String slot) => ValueKey('checkout-window-$slot');
  static Key card(String id) => ValueKey('checkout-card-$id');
  static const confirm = Key('checkout-confirm');
  static const summaryTotal = Key('checkout-summary-total');
  static const retry = Key('checkout-retry');
  static const startAgain = Key('checkout-start-again');
  static const goToBags = Key('checkout-go-to-bags');
  static const errorNotice = Key('checkout-error-notice');
  static const errorDismiss = Key('checkout-error-dismiss');
  static const startRetry = Key('checkout-start-retry');
}
