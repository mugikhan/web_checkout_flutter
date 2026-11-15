# Proposal

## Why

The brief asks for an order details view with a status timeline, and for a pending state that updates when the hold is confirmed. Today `/orders/:orderId` only shows a placeholder, and nobody can see a declined payment fail.

## What Changes

- Add an `order` query that returns the order or `OrderNotFound` for an unknown or foreign id ([ADR-0005](../../../../docs/adr/0005-typed-result-unions.md), [ADR-0009](../../../../docs/adr/0009-simulated-auth.md)).
- Add an `orderStatusChanged` subscription served by `LocalLink` as a stream ([ADR-0004](../../../../docs/adr/0004-graphql-codegen-local-link.md)). The "server" works out each order's status from its stored times, so a refresh during the hold still ends in the right state.
- Add `modules/orders` with an order bloc and the order page, replacing the placeholder. The bloc loads the order, then follows its status until it is final ([ADR-0006](../../../../docs/adr/0006-bloc-with-concurrency.md)).
- Show the order id, store, bags with their snapshot prices, total, collection window in local time, masked card and an animated status timeline with a time per reached state.
- End a Confirmed or Failed order with one "Back to bags" action. A Failed order shows the decline reason.
- Add a `StatusTimeline` atom to `packages/ui`, in `DESIGN.md` first ([ADR-0011](../../../../docs/adr/0011-design-tokens.md)).
- Add an order journey that covers a Visa order turning Confirmed, a Mastercard order turning Failed, and an unknown order id ([ADR-0012](../../../../docs/adr/0012-testing-strategy.md)).

## Out of scope

- An orders list. Orders are reached by the confirm redirect or a deep link.
- Retrying a failed payment. "Back to bags" starts a new checkout.
- Changing the stored order record. The checkout slice already stores everything the status needs.
- README and SOLUTION.md. They belong to `docs-and-delivery`.

## Capabilities

### New Capabilities

- `order-details`: What the order page shows, how it handles an unknown or foreign order, and where it leads next.
- `order-status`: How an order moves from Created to Confirmed or Failed, how the page learns about it live, and how the timeline shows it.

### Modified Capabilities

- `app-navigation`: the "Order placeholder" requirement goes; `order-details` owns the order route.
- `design-language`: adds the status timeline component.
- `workspace-tooling`: the journeys requirement names the order journey.

## Impact

- `packages/api`: schema (`order`, `orderStatusChanged`, a richer `Order` type, `OrderNotFound`), a new operation file with generated code, an order resolver, stream support in `LocalLink`, an order repository behind a domain interface.
- `packages/ui`: `StatusTimeline`.
- New `modules/orders`. `apps/web_checkout` swaps the placeholder for the order page and registers the module.
- New patrol journey `order_test.dart`.
