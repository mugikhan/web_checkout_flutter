# Proposal

## Why

A customer can pick bags but cannot buy them. The brief's core is a checkout that survives double clicks, refresh and Back with no duplicate orders, so this slice builds it.

## What Changes

- Add a "Continue" action to the catalog summary, enabled with 1 or 2 bags picked. It opens `/checkout/new?bags=…`, which asks a signed-out customer to sign in first ([the oracle](../../../docs/ORACLE.md)).
- Add `createCheckoutSession`. `/checkout/new` calls it and replaces the URL with `/checkout/:sessionId?bags=…`. The session id is the idempotency key, and the session expires 15 minutes after creation ([ADR-0008](../../../docs/adr/0008-checkout-session-idempotency.md)).
- Add a `checkoutSession` query. It returns the session status (`OPEN`, `COMPLETED` or `EXPIRED`), the offered collection windows and the payment method. The viewer's saved cards come back in the same request. Another viewer's session reads as not found ([ADR-0009](../../../docs/adr/0009-simulated-auth.md)).
- Offer 1-hour collection windows from 09:00 to 22:00, today and tomorrow, and hide windows that already started. The picked window's start goes in the URL as `slot` ([ADR-0007](../../../docs/adr/0007-go-router-url-holds-draft.md)).
- Add `setPaymentMethod(sessionId, cardId)`. It stores one of two seeded saved cards against the session on the "server". The card never goes in the URL.
- Add `confirmCheckout(sessionId, bagIds, slotStart)`. It creates at most one order per session and returns the existing order on a repeat. Expected failures are union members, mapped to sealed domain failures ([ADR-0005](../../../docs/adr/0005-typed-result-unions.md)).
- Store the order with snapshot bag names and prices, the window, the card, the status `CREATED`, `holdConfirmsAt` and whether the card declines. `order-details` serves the status change from this record.
- Add `modules/checkout` with blocs and pages for starting and running a checkout ([ADR-0006](../../../docs/adr/0006-bloc-with-concurrency.md), [ADR-0010](../../../docs/adr/0010-get-it-registration.md)). Confirm is `droppable`; the page load and `setPaymentMethod` are `restartable`.
- Show checkout full screen, outside the navigation shell, with a close action back to `/?bags=…`. Use two columns from 840px and one column with a bottom confirm bar below that.
- Handle the expired, not-found and completed states. Expired and not found offer "Start again". A completed session moves to its order with replace.
- After confirm, move to `/orders/:orderId` with replace. That route is a guarded placeholder inside the shell that shows "Order placed" and the order id.
- After sign-in, the return to `from` replaces the sign-in entry in browser history. Without this, Back from an order goes through the sign-in URL and opens a new checkout.
- Add the `WindowChip` and `SavedCardTile` atoms to `DESIGN.md` and `packages/ui` ([ADR-0011](../../../docs/adr/0011-design-tokens.md)).
- Add a checkout patrol journey, and keep the navigation, sign-in and catalog journeys passing ([ADR-0012](../../../docs/adr/0012-testing-strategy.md)).

## Out of scope

- The order details page, the `orderStatusChanged` subscription, the timeline and the hold outcome. `order-details` adds them.
- Adding, editing or removing saved cards, and real payment.
- Window capacity, store opening days and time zones other than the device's.
- Changing the bags inside checkout. The customer closes checkout and changes them on Bags.
- An "are you sure" dialog on close.

## Capabilities

### New Capabilities

- `checkout-session`: How Continue starts a checkout session, how the session URL works, and how the app handles unknown, foreign, expired and completed sessions.
- `collection-windows`: Which collection windows the "server" offers, how the customer picks one, and how the pick lives in the URL.
- `payment-method`: How the customer picks a saved card, how the "server" stores it against the session, and how Confirm depends on it.
- `checkout-confirm`: How confirm creates one order per session, validates the draft, handles repeated taps and failures, and moves to the order.
- `checkout-page`: The checkout layout on every window size, the order summary, the close action, bad bag links and accessibility.

### Modified Capabilities

- `bag-catalog`: The selection summary gains a Continue action.
- `app-navigation`: Checkout and order routes are guarded, the order placeholder sits under Bags, and the return after sign-in replaces the sign-in history entry.
- `design-language`: New requirements for collection window chips and saved card tiles.
- `workspace-tooling`: The patrol requirement names the checkout journey.

`app-platforms` and `user-session` keep their requirements.

## Impact

- New member: `modules/checkout`. The root `pubspec.yaml` lists it, and the app depends on it.
- Changed: `packages/api` gains checkout and order types in `schema.graphql`, `checkout.graphql` with its generated code, checkout resolvers with an injected clock, `GraphqlCheckoutRepository` and the domain types. `registerApiData` registers the repository.
- Changed: `modules/catalog` takes an `onContinue` callback and shows the Continue action.
- Changed: the app adds `/checkout/new`, `/checkout/:sessionId` and `/orders/:orderId`, guards them, calls `registerCheckoutModule`, and refreshes the router itself so that sign-in replaces its history entry.
- Changed: `packages/ui` gains `WindowChip`, `SavedCardTile` and `formatClock`.
