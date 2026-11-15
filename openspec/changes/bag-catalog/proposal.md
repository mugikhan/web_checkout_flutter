# Proposal

## Why

Bags still shows a placeholder, so a customer cannot pick anything to buy. Checkout needs a draft of picked bags in the URL before it can start a session, so the catalog comes first.

## What Changes

- Add a `bags` query and a `Store` type to `schema.graphql`. The "server" resolves it from four seeded bags sold by Corner Pantry: Grocery, Café, Bakery and Surprise ([ADR-0004](../../../docs/adr/0004-graphql-codegen-local-link.md), [the oracle](../../../docs/ORACLE.md)).
- Add a catalog repository to `packages/api` behind the domain barrel. It maps the query to domain bags with a price and a worth in ZAR cents, and maps a fault to a sealed failure ([ADR-0003](../../../docs/adr/0003-clean-architecture-in-api.md), [ADR-0005](../../../docs/adr/0005-typed-result-unions.md)).
- Add `modules/catalog` with a catalog bloc and the catalog page ([ADR-0006](../../../docs/adr/0006-bloc-with-concurrency.md), [ADR-0010](../../../docs/adr/0010-get-it-registration.md)). The page replaces the Bags placeholder.
- Keep the selection in `/?bags=…`. A tap updates the URL without a new history entry, and the page reads its selection back from the URL. Refresh and deep links keep the picks ([ADR-0007](../../../docs/adr/0007-go-router-url-holds-draft.md)).
- Allow up to 2 different bags. With 2 picked, the other bags turn disabled and show "You can pick up to 2 bags".
- Show a summary with the number of bags picked and the total price.
- Clean a bad link. Unknown ids and duplicates drop out, and only the first 2 valid ids stay. The URL is replaced with the clean one, and a notice says some bags from the link were left out.
- Show a loading view while bags load, and an error view with a retry action when they fail.
- Add the `PriceText`, `BagTile` and `InlineNotice` atoms to `DESIGN.md` and `packages/ui` ([ADR-0011](../../../docs/adr/0011-design-tokens.md)).
- Add a catalog patrol journey, and update the navigation and sign-in journeys for the new Bags page ([ADR-0012](../../../docs/adr/0012-testing-strategy.md)).

## Out of scope

- A "Continue" action and `createCheckoutSession`. The `checkout` slice adds both.
- Collection windows, the `slot` parameter, payment and orders.
- Stock, capacity or sold-out bags. Every bag is always available.
- More than one store, search, filters and bag images.
- "Server" validation of the picked bags. `confirmCheckout` checks them in the `checkout` slice.

## Capabilities

### New Capabilities

- `bag-catalog`: How the customer sees the store's bags, picks up to 2 of them, keeps the picks in the URL, sees the summary, and how the catalog cleans a bad link and handles a load failure.

### Modified Capabilities

- `app-navigation`: Bags at `/` takes an optional `bags` query, and returning to Bags keeps the picks.
- `design-language`: New requirements for prices with a crossed-out worth, selectable tiles with a disabled state, and inline notices.
- `workspace-tooling`: The patrol requirement names the catalog journey next to the navigation and sign-in journeys.

`app-platforms` and `user-session` keep their requirements.

## Impact

- New member: `modules/catalog`. The root `pubspec.yaml` lists it in the workspace, and the app depends on it.
- New dependency: `intl` in `packages/ui`, to format ZAR in `en_ZA`.
- Changed: `packages/api` gains the catalog operation, its generated code, a resolver and the repository. `registerApiData` registers the repository.
- Changed: the app's Bags route builds the catalog page from the `bags` query, and `configureDependencies` calls `registerCatalogModule`. `BagsPlaceholderPage` goes away.
- Changed: the router and app widget tests, and the navigation and sign-in journeys, look for the catalog page instead of the placeholder text.
