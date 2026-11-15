# Design

## Context

`packages/api` holds `schema.graphql`, `LocalLink`, `LocalServer` and the auth repository. `modules/auth` is the only feature module. The Bags branch of the router shows `BagsPlaceholderPage`. `packages/ui` has five atoms and no money formatting. See proposal.md for why this slice adds the catalog.

## Goals / Non-Goals

**Goals:**
- The URL stays the single source of truth for the picks. The bloc never keeps a selection the URL does not hold.
- The selection rules (limit, cleaning a link) live in one pure domain helper that the `checkout` slice can reuse.
- The catalog query and repository follow the auth pattern, so the next slices copy one shape.

**Non-Goals:**
- No caching of the bag list across page visits. The page loads it each time the Bags route builds a new page.
- No shared money type in `packages/ui`. The atoms take integer cents, so `ui` never depends on `api`.

## Decisions

### New members and atoms, and why this slice needs them

| Addition | Why now |
|---|---|
| `modules/catalog` | The catalog bloc and page are the first feature on the Bags branch. |
| `PriceText` (ui atom) | Every bag shows a price next to a crossed-out worth. |
| `BagTile` (ui atom) | A bag is picked by selecting a tile, which needs picked, disabled and hint states. |
| `InlineNotice` (ui atom) | A cleaned bad link needs a visible, dismissible notice. |
| `intl` in `packages/ui` | Prices format in `en_ZA` (the oracle). |

### Layout

```text
packages/api/lib/src/
├── domain/catalog/              # Bag, Store, Money, BagsResult, CatalogRepository, BagSelection
└── data/
    ├── graphql/catalog.graphql  # Bags query and BagFields fragment, plus *.graphql.dart
    ├── server/catalog_resolvers.dart  # seeded bags
    └── repositories/graphql_catalog_repository.dart

modules/catalog/lib/
├── catalog.dart                 # barrel
└── src/
    ├── catalog_keys.dart
    ├── register_catalog_module.dart
    └── catalog/                 # CatalogBloc, events, state, CatalogPage

packages/ui/lib/src/
├── format/money_format.dart     # formatZar(cents)
└── widgets/                     # price_text.dart, bag_tile.dart, inline_notice.dart
```

### Schema

```graphql
type Store { id: ID!  name: String! }
type Bag {
  id: ID!  name: String!  description: String!
  priceCents: Int!  worthCents: Int!  store: Store!
}
type Query { viewer: Viewer  bags: [Bag!]! }
```

Amounts are integer ZAR cents (the oracle). The schema names the unit in the field, because GraphQL has no money scalar. A query has no expected failure, so `bags` returns a plain list. A GraphQL error stays an unexpected fault (ADR-0005).

Seed data, in pick order:

| Id | Name | Price | Worth |
|---|---|---|---|
| `bag_grocery` | Grocery bag | 7999 | 24000 |
| `bag_cafe` | Café bag | 5999 | 18000 |
| `bag_bakery` | Bakery bag | 4999 | 15000 |
| `bag_surprise` | Surprise bag | 6999 | 21000 |

All four belong to the store `store_corner_pantry`, "Corner Pantry". The seeds live in `CatalogResolvers` as constants, not in storage, because nothing writes them.

### Domain and repository

```dart
final class Money(int cents);            // ZAR; +, ==, Money.zero
final class Store(String id, String name);
final class Bag(String id, String name, String description, Money price, Money worth, Store store);

sealed class BagsResult;
final class BagsLoaded(List<Bag> bags);
sealed class BagsFailure extends BagsResult;
final class BagsUnavailable;

abstract interface class CatalogRepository { Future<BagsResult> bags(); }

abstract final class BagSelection {
  static const maxBags = 2;
  static List<String> clean(Iterable<String> ids, Set<String> knownIds);
  static List<String> toggle(List<String> picked, String id);
  static bool canPick(List<String> picked, String id);
}
```

`GraphqlCatalogRepository` maps the query to `BagsLoaded`, and an exception or empty data to `BagsUnavailable`. It never throws. The sealed failure keeps room for typed failures later, and the bloc already switches over it exhaustively.

`BagSelection.clean` keeps known ids once each, in link order, and stops at `maxBags`. `toggle` removes a picked id, adds an unpicked one when there is room, and otherwise returns the list unchanged.

Alternative: put the rules in the bloc. Rejected, because `checkout` must apply the same rules to its own `bags` query.

### URL format and navigation

The app owns the URL format, so modules never know routes:
- `AppRoutes.bagIdsFrom(Uri)` splits the `bags` query on commas, trims each id and drops empty ones. It keeps order and duplicates, so the catalog can tell that a link was bad.
- `AppRoutes.bagsLocation(List<String>)` returns `/` for no ids, else `/?bags=a,b`. It writes the commas raw, because the ids are plain `[a-z_]` strings, and `Uri(queryParameters:)` would encode them as `%2C`.

`CatalogPage` takes `bagIds` and an `onSelectionChanged(List<String>)` callback. The route sets the callback to `Router.neglect(context, () => context.go(AppRoutes.bagsLocation(ids)))`.

`Router.neglect` makes the browser replace the current history entry. go_router's own `replace` still pushes a browser entry: its information provider reports `RouteInformationReportingType.none`, which only replaces on the first report. `go` to `/` keeps the same page key within the branch, so the page and its bloc survive each URL change.

Alternative: keep the picks in the bloc and mirror them to the URL. Rejected by the settled decision: the URL is the single source of truth.

### Bloc

`CatalogState` is one class, like `SignInState`:
- `status`: `loading`, `loaded` or `failed`.
- `bags`: the loaded bags.
- `linkIds`: the ids the URL holds now, raw.
- `picked`: the clean ids, valid only once `status` is `loaded`.
- `leftOut`: true after a link was cleaned, until the notice is dismissed.
- Getters: `pickedBags`, `total`, `canPick(id)`, and `needsCleanUrl` (loaded and `linkIds` differ from `picked`).

Events:
- `CatalogLoadRequested`, `restartable` (ADR-0006). It emits `loading`, then `loaded` with the link cleaned, or `failed`.
- `CatalogLinkChanged(ids)`. It stores `linkIds` and, once loaded, cleans them. A clean result that differs from the link sets `leftOut`.
- `CatalogNoticeDismissed` clears `leftOut`.

`CatalogPage`:
- Adds `CatalogLinkChanged` in `initState` and in `didUpdateWidget` when `bagIds` changes.
- Listens for `needsCleanUrl` and calls `onSelectionChanged(state.picked)` once. The clean URL comes back as a new `bagIds`, which equals `picked`, so the loop ends.
- On a tile tap, calls `onSelectionChanged(BagSelection.toggle(state.picked, id))`. The tap never changes state directly.

The route builder creates the bloc with `BlocProvider(create: …)` and adds `CatalogLoadRequested`.

### UI atoms

- `formatZar(int cents)` wraps `NumberFormat.simpleCurrency(locale: 'en_ZA')`: "R59,99", and "R1 234,50" with a no-break space.
- `PriceText(priceCents, worthCents)`: price in `titleMedium` `onSurface`; worth in `bodyMedium` `onSurfaceVariant` with a line through. Its semantic label is "R59,99, worth R180,00".
- `BagTile`: a flat card with an `outline` border, `md` radius and `lg` padding. Picked: a 2px `primary` border and a `check_circle` in `primary`. Disabled: taps do nothing, the circle icon dims, and the hint shows in `bodyMedium` `onSurfaceVariant`. One merged semantics node carries `checked`, `enabled` and `button`.
- `InlineNotice(message, onDismiss, dismissKey)`: `secondary` background, `onSecondary` text and icons, `md` radius, a close `IconButton` with the tooltip "Dismiss". It is a live region.

New contrast pairs, checked in the `packages/ui` contrast test:

| Pair | Light | Dark | Needs |
|---|---|---|---|
| `onSurfaceVariant` / `surfaceContainer` | same as on `surface` | `#9DADAF` on `#18251F` | 4.5:1 |
| `primary` / `surfaceContainer` (picked border) | `#1D2B24` on `#F6F3EE` | `#E7F54D` on `#18251F` | 3:1 |

`onSecondary` / `secondary` is already in the test.

### Page layout

The page is a `Column`: a scrolling list, then a summary bar with a top `outline` divider. The list holds the heading, the notice when shown, and the tiles in rows. Compact windows use one column. Medium and expanded windows use two columns, with the content capped at 960px wide. Each row is an `IntrinsicHeight` `Row`, so paired tiles share a height without a fixed aspect ratio.

The summary shows "No bags picked", "1 bag" or "2 bags", and the total from `formatZar`.

### Keys and semantics

`CatalogKeys` holds `bag(String id)`, `summaryCount`, `summaryTotal`, `notice`, `noticeDismiss` and `retry`. Tiles take their semantic label from the bag name, the price label and the hint. The dismiss and retry actions take theirs from the tooltip and the button text.

### Dependency injection

- `registerApiData` adds `CatalogRepository` as `GraphqlCatalogRepository`.
- `registerCatalogModule(GetIt)` registers `CatalogBloc` as a factory.
- `configureDependencies` calls it after `registerAuthModule`.

### Tests

- `packages/api`: `BagSelection` rules, the `Bags` resolver, `LocalLink` coverage of the new operation, and `GraphqlCatalogRepository` over `LocalServer` and over a broken link.
- `packages/ui`: `formatZar`, `PriceText` text and semantics, `BagTile` picked, disabled and hint states and semantics, `InlineNotice` dismiss and live region, the new contrast pairs.
- `modules/catalog`: `bloc_test` for every event, the cleaned link, `leftOut`, failure and retry, and `restartable` load, with a mocktail `CatalogRepository`. Widget tests for the loading, error and loaded views, the limit, the summary and the clean-URL callback.
- `apps/web_checkout`: `bagIdsFrom` and `bagsLocation`, and router tests for picks in the URL, the bad link and the return to Bags.
- Patrol: a new catalog journey; the navigation and sign-in journeys check the catalog page instead of the placeholder.

## Risks / Trade-offs

- [`Router.neglect` depends on Flutter's reporting order] → Router tests cannot see browser history, so the catalog journey checks the URL on web, and a manual check covers Back.
- [Tapping Bags while on Bags goes to the branch's first page, `/`, and clears the picks] → Keep the existing shell rule for now; see "Open for sign-off".
- [A bad link triggers two builds: the raw link, then the clean URL] → The bloc cleans the link before the page shows tiles, so the raw picks never render.
- [The bag list reloads each time the Bags page is built again] → Acceptable for four seeded bags with no network.

## Found during implementation

- The domain `Store` clashes with `Store` from `package:graphql/client.dart`. `GraphqlCatalogRepository` imports only `GraphQLClient`, and its test hides `Store`.
- `Semantics.checked` and `enabled` still exist in Flutter 3.47.9. Tests use `isSemantics`, because `containsSemantics` is deprecated.
- The catalog journey checks Back on web with `$.platform.web.goBack()`. With `Router.neglect` removed, it fails at that step, so the check is real.
- The design named a "Web, manual" Back check. The journey now covers it on web, and the manual check stays as a backup.

## Open for sign-off

- Tapping the Bags destination while Bags is open resets the branch to `/`, which drops the picks. Switching from Account to Bags keeps them. The shell can stop resetting Bags in a later slice.
- The bad-link notice stays until the user dismisses it. A pick does not clear it.
- The schema carries amounts as `priceCents` and `worthCents` integers, not as a `Money` object type. A `Money` type can replace them before orders snapshot prices.
