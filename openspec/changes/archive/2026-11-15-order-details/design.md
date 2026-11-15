# Design

## Context

See proposal.md for the motivation. Current state after `checkout`:

- `confirmCheckout` stores an order in the "server" namespace through `CheckoutStore.saveOrder`. The record holds `id`, `ownerId`, `sessionId`, `status: CREATED`, `createdAt`, `holdConfirmsAt` (3 seconds later), `declines`, `store`, the `bags` snapshot (`id`, `name`, `priceCents`), `totalCents`, the `window` (`startsAt`, `endsAt`) and the card. This slice does not change that record.
- The schema has `enum OrderStatus { CREATED PENDING CONFIRMED FAILED }` and a thin `type Order { id status }`.
- `LocalLink.request` yields one `Response` from a `Future`-returning `Resolver`. Subscriptions need a stream.
- `CheckoutResolvers` already takes an injected clock (`LocalServer(store, clock:)`).
- `/orders/:orderId` is guarded, sits in the shell's Bags branch and shows `OrderPlaceholderPage`.

## Goals / Non-Goals

**Goals:**
- The status is correct at every read, after any refresh, without a background job.
- One journey proves Confirmed, Failed and not-found on all three platforms, long enough to film.

**Non-Goals:**
- No server push across app restarts. The subscription lives as long as the order page does.
- No changes to the checkout flow or the stored order record.

## Decisions

### Status is derived, not stored

The resolver computes the status from the clock and the record:

```text
statusOf(order, now)
  if now < holdConfirmsAt   → PENDING
  else if order.declines    → FAILED
  else                      → CONFIRMED
```

Created and Pending both start at `createdAt`, because the hold is placed with the order. The final step happens at `holdConfirmsAt`. The stored `status: CREATED` stays as written.

Alternative: write the new status with a timer. Rejected, because a timer dies on refresh. Deriving the status makes refresh and late opens correct for free.

### Schema additions

```graphql
type Order {
  id: ID!
  status: OrderStatus!
  store: String!
  bags: [OrderBag!]!
  totalCents: Int!
  window: CollectionWindowTimes!   # startsAt, endsAt (UTC ISO strings)
  card: OrderCard!                 # brand, last4
  createdAt: String!
  holdConfirmsAt: String!
}
type OrderNotFound { orderId: ID! }
union OrderResult = Order | OrderNotFound

extend type Query { order(id: ID!): OrderResult! }
type Subscription { orderStatusChanged(orderId: ID!): OrderResult! }
```

Field names are a guide. Reuse existing types where they fit. An unknown id and another viewer's id both return `OrderNotFound` (ADR-0009).

### Streams in LocalLink

Add a second resolver map for subscriptions: `StreamResolver = Stream<Map<String, dynamic>> Function(variables, context)`. `LocalLink.request` checks it first and yields each event as a `Response`. The `orderStatusChanged` resolver:

1. emits the order as it is now;
2. if the order is Pending, waits until `holdConfirmsAt` by the injected clock, then emits the settled order;
3. closes.

The wait must use an injectable delay, for example a `Future<void> Function(Duration)` defaulting to `Future.delayed`, so resolver tests run with `fakeAsync` or a fake delay and no real waiting.

### Domain and repository

In `packages/api` domain: `Order` (with `OrderBag`, card, window times), `OrderStatus` (`created`, `pending`, `confirmed`, `failed`), a sealed `OrderResult` (`OrderLoaded`, `OrderNotFound`, `OrderUnavailable` for unexpected faults), and an `OrderRepository` with `Future<OrderResult> order(String id)` and `Stream<OrderResult> watchStatus(String id)`. `GraphqlOrderRepository` in data uses the client's `query` and `subscribe`, registered in `registerApiData`.

The timeline steps come from the order: Created and Pending at `createdAt`; Confirmed or Failed at `holdConfirmsAt` once reached.

### Orders module

`modules/orders`, following `modules/checkout`:

- `OrderBloc` loads the order (`restartable`). If the order is Pending, it starts following `watchStatus` (`restartable`) and cancels the subscription in `close()` (ADR-0006).
- `OrderPage` shows the content from the `order-details` spec. It shows `StateView.loading` while loading, "Order not found" with "Back to bags" for `OrderNotFound`, and `StateView.error` with retry for `OrderUnavailable`.
- The decline reason uses `InlineNotice` in its error tone.
- "Back to bags" navigates to `/` with `go`, so no picks remain.
- `OrdersKeys` holds the test keys. `registerOrdersModule` is called from the composition root.
- The heading stays "Order placed", so the `checkout-confirm` scenarios ("the order page shows 'Order placed' and the order id") keep holding. Keep the order id's existing test key value (`AppKeys.orderId`) or move it to `OrdersKeys` and update the checkout journey to match.

### StatusTimeline atom

`packages/ui` gains `StatusTimeline`. It takes a list of steps (label, optional time text, state `reached`, `upcoming` or `failed`) and stays free of order types, so the module maps orders to steps. Add its `DESIGN.md` row first.

- Colours: `primary` for reached, `onSurfaceVariant` for upcoming, `error` for failed. Add the pairs to the contrast test if they are missing.
- A newly reached step animates in with the `long` motion token (500ms). `MediaQuery.disableAnimations` skips the animation.
- Times use `formatClock` in local time.

### Journey

`apps/web_checkout/patrol_test/order_test.dart`, one `app.main()`:

1. Sign in, pick Café and Bakery, check out with "Visa •••• 4242", and land on the order page.
2. See Pending, then wait for Confirmed with its time; see the bags, total, window and card; select "Back to bags".
3. Check out again with "Mastercard •••• 0002". See Pending, then Failed with the reason in the error tone and "Back to bags".
4. Open `/orders/ord_missing` in-app and see "Order not found".

Wait for the settled state with patrol's waiting finders, not fixed sleeps. The real 3-second hold makes the clip long enough to film both outcomes.

### Tests

- Resolver: Pending before the hold time, Confirmed or Failed after it, not found for unknown and foreign ids, and a subscription that emits Pending then the settled status at the hold time (fake clock and delay).
- Repository, bloc (load, follow, cancel on close, a late open skips the subscription), page, `StatusTimeline` (colours, reduced motion) and router tests.

## Risks / Trade-offs

- [The client subscription and query share one GraphQL client cache] → Use `FetchPolicy.noCache` or `networkOnly` for the order query and the subscription, so a refresh never shows a stale Pending.
- [A real 3-second wait per order makes the journey slow] → Accepted. It is what the user sees, and it gives the videos both outcomes.
- [A clock change on the device during the hold] → Out of scope for an in-app "server".

## Found during implementation

- The order page and Bags share the shell branch navigator, so `go('/')` from "Back to bags" ran the platform page transition and kept the order page on screen while Bags opened.
- The Bags and order routes now use `NoTransitionPage`, so the swap is instant on web and mobile. Route tests check that no `OrderPage` remains after one frame.
