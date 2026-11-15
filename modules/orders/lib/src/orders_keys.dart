import 'package:ui/ui.dart';

/// OrdersKeys holds the test keys for the orders module's widgets.
abstract final class OrdersKeys {
  static const orderId = Key('order-id');
  static const store = Key('order-store');
  static Key bag(String id) => ValueKey('order-bag-$id');
  static const total = Key('order-total');
  static const window = Key('order-window');
  static const card = Key('order-card');
  static const timeline = Key('order-timeline');
  static const declineNotice = Key('order-decline-notice');
  static const declineDismiss = Key('order-decline-dismiss');
  static const backToBags = Key('order-back-to-bags');
  static const retry = Key('order-retry');
}
