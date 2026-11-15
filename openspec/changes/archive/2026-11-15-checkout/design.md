# Design

## Context

`packages/api` serves `viewer`, `bags` and `signIn` through `LocalLink` and `LocalServer`. `SessionStore` maps auth tokens to viewer names in the storage server namespace. `modules/auth` and `modules/catalog` are the feature modules. The router guards `/account` only, and refreshes on every `SessionBloc` event through `refreshListenable`. The catalog keeps its picks in `/?bags=…` and replaces the URL with `Router.neglect`. See proposal.md for why this slice adds checkout.

## Goals / Non-Goals

**Goals:**
- The "server" alone guarantees one order per session. The client guard only cuts noise (ADR-0008).
- The URL holds the draft (bags, slot); the "server" holds the session, the card and the order. Refresh rebuilds the page from both.
- Every expected failure is a typed union member and a sealed domain type that blocs switch on exhaustively.
- Tests never depend on the time of day: the "server" and the bloc take a clock.

**Non-Goals:**
- No order query, subscription or hold outcome. The order record only stores what `order-details` needs.
- No client-side window rules. The "server" offers the windows, and the page shows them.

## Decisions

### New members and atoms, and why this slice needs them

| Addition | Why now |
|---|---|
| `modules/checkout` | The start and checkout blocs and pages are the first checkout feature. |
| `WindowChip` (ui atom) | The customer picks one collection window from up to 26 short time ranges. |
| `SavedCardTile` (ui atom) | The customer picks a saved card, with picked and busy states. |
| `formatClock` (ui format) | Windows show as `HH:mm` in local time. `intl`'s `DateFormat` needs locale data set up for `en_ZA`, so a two-digit formatter is simpler. |

### Layout

```text
packages/api/lib/src/
├── domain/checkout/        # CollectionWindow, SavedCard, CheckoutSession, results, CheckoutRepository
└── data/
    ├── graphql/checkout.graphql             # operations, plus *.graphql.dart
    ├── server/checkout_resolvers.dart       # rules: windows, ownership, idempotent confirm
    ├── server/checkout_store.dart           # sessions and orders in the server namespace
    └── repositories/graphql_checkout_repository.dart

modules/checkout/lib/src/
├── checkout_keys.dart
├── register_checkout_module.dart
├── start/                  # CheckoutStartBloc, CheckoutStartPage
└── checkout/               # CheckoutBloc, events, state, CheckoutPage and its parts

apps/web_checkout/lib/pages/order_placeholder_page.dart
```

### Schema

```graphql
type Query {
  checkoutSession(id: ID!): CheckoutSessionResult!
  savedCards: [SavedCard!]!
}
type Mutation {
  createCheckoutSession: CheckoutSession!
  setPaymentMethod(sessionId: ID!, cardId: ID!): SetPaymentMethodResult!
  confirmCheckout(sessionId: ID!, bagIds: [ID!]!, slotStart: String!): ConfirmCheckoutResult!
}

enum CheckoutSessionStatus { OPEN COMPLETED EXPIRED }
enum OrderStatus { CREATED PENDING CONFIRMED FAILED }

type CheckoutSession {
  id: ID!  status: CheckoutSessionStatus!  expiresAt: String!
  orderId: ID  paymentMethod: SavedCard  collectionWindows: [CollectionWindow!]!
}
type CollectionWindow { startsAt: String!  endsAt: String! }
type SavedCard { id: ID!  brand: String!  last4: String! }
type Order { id: ID!  status: OrderStatus! }

type SessionNotFound { sessionId: ID! }
type SessionExpired { sessionId: ID! }
type SlotUnavailable { slotStart: String! }
type PaymentMethodMissing { sessionId: ID! }
type InvalidBags { maxBags: Int! }
type CardNotFound { cardId: ID! }

union CheckoutSessionResult = CheckoutSession | SessionNotFound
union SetPaymentMethodResult = CheckoutSession | SessionNotFound | SessionExpired | CardNotFound
union ConfirmCheckoutResult = Order | SessionExpired | SlotUnavailable | PaymentMethodMissing | InvalidBags | SessionNotFound
```

- Times travel as ISO-8601 UTC strings. A custom `DateTime` scalar would need codegen scalar mapping for two fields; the repository parses the strings instead.
- `collectionWindows` is empty unless the session is `OPEN`.
- `createCheckoutSession` without a viewer raises a GraphQL error. The route guard makes that unreachable, so it is an unexpected fault, not a union member.
- `setPaymentMethod` on a completed session changes nothing and returns the session, so the page sees `COMPLETED` and moves to the order. This needs no extra union member.
- `CardNotFound` is not in the oracle's list, which covers confirm only. `setPaymentMethod` needs it for a forged card id.
- `Order` carries only `id` and `status`. `order-details` adds the fields its page reads.

The page asks for the session and the saved cards in one `CheckoutSession` operation, because `LocalLink` routes one resolver per operation.

### "Server" rules

`LocalServer(store, {random, clock})` builds `CheckoutResolvers` with the auth `SessionStore`, a new `CheckoutStore` and the clock. `clock` defaults to `DateTime.now`.

- **Owner:** the resolver reads the viewer id (`viewer:<lower-case name>`) from the token. No viewer, or a different owner, reads as `SessionNotFound`.
- **Session ids:** `cs_` plus 16 random hex characters. Order ids: `ord_` plus 12. Neither can equal `new`.
- **Expiry:** `expiresAt` is creation plus 15 minutes. Status is computed on read: `COMPLETED` when the session has an order id, else `EXPIRED` when the clock is at or past `expiresAt`, else `OPEN`.
- **Windows:** `CollectionWindow.offered(now)` builds starts at 09:00 to 21:00 local time for today and tomorrow, keeps those after `now`, and stores them as UTC. It is a pure domain function, so resolver and bloc tests share it.
- **Saved cards:** constants for every viewer: `card_visa_4242` (Visa, 4242) and `card_mastercard_0002` (Mastercard, 0002, declines).
- **Confirm order of checks:** not found → completed returns its order → expired → bags (1–2, distinct, known) → slot (equals an offered start) → payment method → create. A completed session returns its order before any other check, so a repeat with stale arguments still gets the same order.
- **Serialization:** `setPaymentMethod` and `confirmCheckout` run one at a time through a promise chain in `CheckoutResolvers`. Without it, two confirms could both read `OPEN` across the async storage calls and both create an order.

Order record, stored by id under `orders`:

```json
{ "id": "ord_…", "ownerId": "viewer:naledi", "sessionId": "cs_…", "status": "CREATED",
  "createdAt": "…Z", "holdConfirmsAt": "…Z (createdAt + 3 s)", "declines": false,
  "store": "Corner Pantry", "bags": [{ "id": "bag_cafe", "name": "Café bag", "priceCents": 5999 }],
  "totalCents": 5999, "window": { "startsAt": "…Z", "endsAt": "…Z" },
  "paymentMethod": { "id": "card_visa_4242", "brand": "Visa", "last4": "4242" } }
```

Sessions sit under `checkout_sessions` with `id`, `ownerId`, `createdAt`, `expiresAt`, `cardId` and `orderId`.

### Domain

```dart
final class CollectionWindow(DateTime start);   // UTC; end = start + 1h; offered(now); slot <-> String
final class SavedCard(String id, String brand, String last4);
enum CheckoutSessionStatus { open, completed, expired }
final class CheckoutSession(id, status, expiresAt, orderId?, paymentMethod?, windows);

sealed class StartCheckoutResult;      CheckoutStarted(sessionId)
sealed class CheckoutSessionResult;    CheckoutSessionLoaded(session, savedCards)
sealed class SetPaymentMethodResult;   PaymentMethodSet(session)
sealed class ConfirmCheckoutResult;    CheckoutConfirmed(orderId)

sealed class CheckoutFailure;
SessionNotFound      implements CheckoutSessionResult, SetPaymentMethodResult, ConfirmCheckoutResult
SessionExpired       implements SetPaymentMethodResult, ConfirmCheckoutResult
CardNotFound         implements SetPaymentMethodResult
SlotUnavailable, PaymentMethodMissing, InvalidBags implement ConfirmCheckoutResult
CheckoutUnavailable  implements all four results

abstract interface class CheckoutRepository {
  Future<StartCheckoutResult> createSession();
  Future<CheckoutSessionResult> session(String id);
  Future<SetPaymentMethodResult> setPaymentMethod(String sessionId, String cardId);
  Future<ConfirmCheckoutResult> confirm(String sessionId, List<String> bagIds, DateTime slotStart);
}
```

One file holds the results and failures, so each failure can implement several sealed results. A bloc's `switch` over `ConfirmCheckoutResult` then lists exactly the members the schema allows. Alternative: one failure class per result. Rejected, because `SessionNotFound` would exist three times.

The `slot` query uses the compact form `2026-11-15T12:00Z`. `CollectionWindow.slotParam` writes it and `CollectionWindow.parseSlot` reads any ISO-8601 instant.

### Routes and history

- `/checkout/new` comes before `/checkout/:sessionId`, both top level, outside the shell. `/checkout/new` redirects to `/` when `bags` is empty.
- `/orders/:orderId` sits in the Bags branch next to `/`.
- `AppRoutes.isGuarded(path)` covers `/account` and every path under `/checkout/` and `/orders/`. `authRedirect` uses it.
- Every move that must leave no history entry goes through `Router.neglect(context, () => context.go(…))`, as the catalog does: session created (`/checkout/new` → `/checkout/:id`), slot or bag clean-up, completed session → order, confirm → order, and "Start again".
- Continue and close use plain `context.go`.

**Sign-in replaces its entry.** A signed-out Continue leaves `/sign-in?from=/checkout/new…` in history. The return to `from` happens through a router refresh, and go_router reports a refresh as a new entry. Back from the order then reopens sign-in, which sends the signed-in viewer on to `/checkout/new` and a new session. The app now listens to `SessionBloc` itself instead of passing `refreshListenable`. On `SessionSignedIn` it calls `Router.neglect(navigatorContext, router.refresh)`, so the redirect to `from` replaces the sign-in entry. Other session changes call `router.refresh()` as before. go_router parses and redirects synchronously, so the neglect intention is still set when the Router reports the new URL.

Alternative: a callback on `SignInPage` that navigates after sign-in. Rejected, because the router refresh redirects in the same frame, and the two navigations race.

### Blocs

`CheckoutStartBloc`: `CheckoutStartRequested` (`droppable`) → `starting`, then `started(sessionId)` or `failed`. The page calls `onStarted(sessionId)` once.

`CheckoutBloc(checkoutRepository, catalogRepository, clock)`:
- `CheckoutLoadRequested(sessionId)`, `restartable`. It loads the session and the bags in parallel. `COMPLETED` sets `orderId`; `EXPIRED` and `SessionNotFound` set their status; a fault in either sets `failed`. An open session stores windows, cards and the stored card id.
- `CheckoutLinkChanged(bagIds, slot)`. It stores the raw link and, once loaded, cleans the bags with `BagSelection.clean` and matches the slot to an offered window. A slot with no match sets `slotUnavailable`. A matched slot clears it, so picking a new window removes the notice. A card pick keeps it.
- `CheckoutCardPicked(cardId)`, `restartable`. It sets `pendingCardId`, calls `setPaymentMethod`, then stores the session's card id or an error.
- `CheckoutConfirmRequested`, `droppable`. It returns early unless `canConfirm`. Success keeps `confirming` true and sets `orderId`, so the button stays busy until the route changes. `SlotUnavailable` clears the window, sets `slotUnavailable` and reloads the session, so the page drops the slot from the URL.
- `CheckoutErrorDismissed`.

State getters: `pickedBags`, `total`, `canConfirm` (ready, bags picked, window picked, card stored, no card request, no stale slot notice, not confirming), and `needsCleanUrl` (loaded, and the raw bags or slot differ from the clean ones).

`today` comes from the clock at load and labels the window groups "Today" and "Tomorrow".

### Pages

`CheckoutPage(bagIds, slot, onDraftChanged, onClose, onStartAgain, onCompleted)`. Like `CatalogPage`, it never changes the URL itself. It forwards link changes to the bloc and asks the app for clean URLs. `CheckoutStartPage(onStarted, onClose)`.

Layout: `Scaffold` with an `AppBar` holding the close button and "Checkout". From 840px, a `Row`: the left column scrolls (bags, windows, cards), and the right column is a fixed 360px summary card with Confirm. Below 840px, one scrolling column plus a bottom bar with the total and Confirm.

States: loading (`StateView.loading`), failed (error with "Try again"), not found and expired (`StateView.empty` with "Start again"), no bags ("Go to Bags"), ready.

### UI atoms

- `WindowChip(label, semanticLabel, selected, onTap)`: `sm` radius, `labelMedium`. Picked: `primary` background, `onPrimary` text. Unpicked: `surfaceContainer`, `outline` border, `onSurface` text. Semantics: button, selected, label.
- `SavedCardTile(label, semanticLabel, selected, busy, onTap)`: like `BagTile`, flat with `outline` border and `md` radius. Picked: 2px `primary` border and `check_circle`. Busy: an 18px progress indicator in place of the check icon.

Both colour pairs are already in the contrast test (`onPrimary` / `primary`, `onSurface` / `surfaceContainer`, `primary` / `surfaceContainer`), so the test gains no pair.

### Keys and semantics

`CheckoutKeys`: `close`, `window(slotParam)`, `card(cardId)`, `confirm`, `summaryTotal`, `retry`, `startAgain`, `goToBags`, `errorNotice`, `errorDismiss`, `startRetry`. The app adds `AppKeys.orderId` on the placeholder. Window labels read "Today, 14:00 to 15:00". Card labels read "Visa ending in 4242".

### Dependency injection

- `registerApiData` adds `CheckoutRepository` as `GraphqlCheckoutRepository`.
- `registerCheckoutModule(GetIt)` registers both blocs as factories.
- `configureDependencies` calls it after `registerCatalogModule`.

### Tests

- `packages/api`: `CollectionWindow.offered` and slot parsing; resolver tests over `MemoryStore` with a fixed clock for create, read, expiry, ownership, cards, every confirm rule, the repeat confirm, two concurrent confirms and the order record; `GraphqlCheckoutRepository` mapping over `LocalServer` and over a broken link; the "every operation has a resolver" test.
- `packages/ui`: `formatClock`, `WindowChip` and `SavedCardTile` states and semantics.
- `modules/checkout`: `bloc_test` for both blocs, each concurrency rule and every result; widget tests for every state, both layouts, the disabled Confirm and the callbacks.
- `modules/catalog`: Continue enabled state and callback.
- `apps/web_checkout`: `isGuarded`, location builders and router tests for `/checkout/new`, guards, the placeholder and the completed redirect.
- Patrol: `checkout_test.dart`; the catalog journey also checks Continue's state.

## Risks / Trade-offs

- [The windows use the device time zone, because the "server" runs on the device] → Fine for a local "server". A real store would fix its own zone; see "Open for sign-off".
- [`Router.neglect` around a refresh depends on go_router redirecting synchronously] → The checkout journey checks Back on web after a signed-out Continue, so a regression fails it.
- [A refresh on `/checkout/new` before the session returns creates a second session] → Sessions without an order cost nothing and expire. Only confirm is idempotent.
- [The serialization lock lives in one `LocalServer` instance] → The app builds one server. A real backend would use a transaction.
- [The session reloads in full after `SlotUnavailable`] → One extra request, only on a rare failure.

## Found during implementation

- Removing the serialization lock makes the "two confirms at once" resolver test fail, so the test proves the lock.
- Replacing `Router.neglect` on sign-in with a plain refresh makes the checkout journey fail on web at the Back step, so that check is real too.
- Resolver and repository tests pick the first window from `CollectionWindow.offered(now)`, so they pass in any machine time zone.
- bloc emits its first state even when it equals the initial state, so start bloc tests expect `starting` first, as the catalog tests do.
- Confirm shows a hint under it that names what is missing: "Pick a collection window and a card to confirm."
- The journey proves one order by reading `server.orders` from shared_preferences after a double tap with no frame between the taps.

## Open for sign-off

- Windows follow the device's local time zone. The store has no time zone of its own.
- Close uses `context.go`, so Back after close returns to the still-open checkout.
- `setPaymentMethod` has a `CardNotFound` member for a forged card id, beyond the oracle's confirm list.
- `createCheckoutSession` without a viewer is a GraphQL error, not a union member.
- The return to `from` after sign-in now replaces the sign-in history entry for every guarded route, Account included.
- The order placeholder offers no action. The shell's Bags destination leads back.
