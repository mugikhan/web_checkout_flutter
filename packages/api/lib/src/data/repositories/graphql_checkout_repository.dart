import 'package:graphql/client.dart' show GraphQLClient;

import '../../domain/checkout/checkout_repository.dart';
import '../../domain/checkout/checkout_results.dart';
import '../../domain/checkout/checkout_session.dart';
import '../../domain/checkout/collection_window.dart';
import '../../domain/checkout/saved_card.dart';
import '../graphql/checkout.graphql.dart';
import '../graphql/schema.graphql.dart';

/// GraphqlCheckoutRepository implements [CheckoutRepository] over the GraphQL client.
class GraphqlCheckoutRepository implements CheckoutRepository {
  GraphqlCheckoutRepository({required this._client});

  final GraphQLClient _client;

  @override
  Future<StartCheckoutResult> createSession() async {
    final result = await _client.mutate$CreateCheckoutSession();
    final data = result.parsedData;
    if (result.hasException || data == null) return const CheckoutUnavailable();
    return CheckoutStarted(data.createCheckoutSession.id);
  }

  @override
  Future<CheckoutSessionResult> session(String id) async {
    final result = await _client.query$CheckoutSession(
      Options$Query$CheckoutSession(
        variables: Variables$Query$CheckoutSession(id: id),
      ),
    );
    final data = result.parsedData;
    if (result.hasException || data == null) return const CheckoutUnavailable();
    return switch (data.checkoutSession) {
      final Fragment$CheckoutSessionFields fields => CheckoutSessionLoaded(
        _toSession(fields),
        [for (final card in data.savedCards) _toCard(card)],
      ),
      Query$CheckoutSession$checkoutSession$$SessionNotFound() =>
        const SessionNotFound(),
      _ => const CheckoutUnavailable(),
    };
  }

  @override
  Future<SetPaymentMethodResult> setPaymentMethod(
    String sessionId,
    String cardId,
  ) async {
    final result = await _client.mutate$SetPaymentMethod(
      Options$Mutation$SetPaymentMethod(
        variables: Variables$Mutation$SetPaymentMethod(
          sessionId: sessionId,
          cardId: cardId,
        ),
      ),
    );
    final data = result.parsedData;
    if (result.hasException || data == null) return const CheckoutUnavailable();
    return switch (data.setPaymentMethod) {
      final Fragment$CheckoutSessionFields fields => PaymentMethodSet(
        _toSession(fields),
      ),
      Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound() =>
        const SessionNotFound(),
      Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired() =>
        const SessionExpired(),
      Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound() =>
        const CardNotFound(),
      _ => const CheckoutUnavailable(),
    };
  }

  @override
  Future<ConfirmCheckoutResult> confirm(
    String sessionId,
    List<String> bagIds,
    DateTime slotStart,
  ) async {
    final result = await _client.mutate$ConfirmCheckout(
      Options$Mutation$ConfirmCheckout(
        variables: Variables$Mutation$ConfirmCheckout(
          sessionId: sessionId,
          bagIds: bagIds,
          slotStart: slotStart.toUtc().toIso8601String(),
        ),
      ),
    );
    final data = result.parsedData;
    if (result.hasException || data == null) return const CheckoutUnavailable();
    return switch (data.confirmCheckout) {
      Mutation$ConfirmCheckout$confirmCheckout$$Order(:final id) =>
        CheckoutConfirmed(id),
      Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound() =>
        const SessionNotFound(),
      Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired() =>
        const SessionExpired(),
      Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable() =>
        const SlotUnavailable(),
      Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing() =>
        const PaymentMethodMissing(),
      Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags() =>
        const InvalidBags(),
      _ => const CheckoutUnavailable(),
    };
  }

  static CheckoutSession _toSession(Fragment$CheckoutSessionFields fields) =>
      CheckoutSession(
        id: fields.id,
        status: switch (fields.status) {
          Enum$CheckoutSessionStatus.OPEN => CheckoutSessionStatus.open,
          Enum$CheckoutSessionStatus.COMPLETED =>
            CheckoutSessionStatus.completed,
          Enum$CheckoutSessionStatus.EXPIRED ||
          Enum$CheckoutSessionStatus.$unknown => CheckoutSessionStatus.expired,
        },
        expiresAt: DateTime.parse(fields.expiresAt),
        orderId: fields.orderId,
        paymentMethod: fields.paymentMethod == null
            ? null
            : _toCard(fields.paymentMethod!),
        windows: [
          for (final window in fields.collectionWindows)
            CollectionWindow(DateTime.parse(window.startsAt)),
        ],
      );

  static SavedCard _toCard(Fragment$SavedCardFields fields) =>
      SavedCard(id: fields.id, brand: fields.brand, last4: fields.last4);
}
