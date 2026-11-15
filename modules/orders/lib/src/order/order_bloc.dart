import 'package:api/domain/domain.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'order_event.dart';
import 'order_state.dart';

/// OrderBloc loads one order and follows its status until it settles.
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required this._orderRepository}) : super(const OrderState()) {
    on<OrderLoadRequested>(_onLoadRequested, transformer: restartable());
  }

  final OrderRepository _orderRepository;

  Future<void> _onLoadRequested(
    OrderLoadRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderState(orderId: event.orderId));
    final result = await _orderRepository.order(event.orderId);
    emit(_fromResult(event.orderId, result));
    if (result is OrderLoaded && !result.order.isSettled) {
      await emit.forEach<OrderResult>(
        _orderRepository.watchStatus(event.orderId),
        onData: (update) => _fromResult(event.orderId, update),
      );
    }
  }

  static OrderState _fromResult(String orderId, OrderResult result) =>
      switch (result) {
        OrderLoaded(:final order) => OrderState(
          status: OrderLoadStatus.loaded,
          orderId: orderId,
          order: order,
        ),
        OrderNotFound() => OrderState(
          status: OrderLoadStatus.notFound,
          orderId: orderId,
        ),
        OrderUnavailable() => OrderState(
          status: OrderLoadStatus.failed,
          orderId: orderId,
        ),
      };
}
