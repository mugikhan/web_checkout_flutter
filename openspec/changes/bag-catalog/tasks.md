# Tasks

## 1. Catalog data in packages/api

- [x] 1.1 Add `Money`, `Store`, `Bag`, `BagsResult`, `CatalogRepository` and `BagSelection` behind `lib/domain/domain.dart`, and verify tests for `clean` (unknown, duplicate, extra and empty ids) and `toggle` (add, remove, limit)
- [x] 1.2 Add the `Store` and `Bag` types and the `bags` query to `schema.graphql`, add `catalog.graphql`, run `fvm exec melos run codegen`, and verify `fvm exec melos run analyze` passes
- [x] 1.3 Add `CatalogResolvers` with the four seeded bags and route `Bags` in `LocalServer`, and verify resolver tests and the "every operation has a resolver" test
- [x] 1.4 Add `GraphqlCatalogRepository` and register it in `registerApiData`, and verify tests over `LocalServer` (four bags in order, prices, store) and over a broken link (`BagsUnavailable`)
- [ ] 1.5 Run `fvm exec melos run codegen` again and verify `git status` shows no change to generated files

## 2. UI atoms

- [ ] 2.1 Add `intl` to `packages/ui` and `formatZar`, and verify tests for 5999, 123450 and 0 cents
- [ ] 2.2 Add the `PriceText`, `BagTile` and `InlineNotice` rows to `DESIGN.md`, then the atoms in `packages/ui`; verify widget tests for the crossed-out worth, the price semantics, the picked, disabled and hint states, tile semantics, and the notice dismiss and live region
- [ ] 2.3 Add the `onSurfaceVariant` / `surfaceContainer` and picked-border pairs to the contrast test, and verify it passes in both themes

## 3. modules/catalog

- [ ] 3.1 Create `modules/catalog` as a workspace member with `ui`, `api`, `bloc`, `flutter_bloc`, `bloc_concurrency` and `get_it`, and verify it resolves with no `material_ui` dependency
- [ ] 3.2 Add `CatalogBloc`, and verify `bloc_test` cases: load success, load failure, retry, `restartable` load, a link before and after load, a cleaned link setting `leftOut`, a clean link leaving it false, and dismissing the notice
- [ ] 3.3 Add `CatalogKeys`, `CatalogPage` and `registerCatalogModule`, and verify widget tests for loading, the error view and retry, the tiles, the limit and hint, the summary, the clean-URL callback, the notice, and one and two columns by width
- [ ] 3.4 Verify `fvm exec melos run analyze` still passes the import-boundary check with the new module

## 4. App wiring

- [ ] 4.1 Add `AppRoutes.bagIdsFrom` and `AppRoutes.bagsLocation`, and verify unit tests for empty, spaced, duplicate and multiple ids
- [ ] 4.2 Depend on `catalog`, call `registerCatalogModule` in `configureDependencies`, build `CatalogPage` on the Bags route with `Router.neglect`, and delete `BagsPlaceholderPage`; verify `fvm flutter build web` succeeds
- [ ] 4.3 Update the router and app widget tests with a mocktail `CatalogRepository`, and verify tests for picks in the URL, a deep link with picks, the bad link cleaned to `/?bags=bag_cafe,bag_bakery`, and the return to Bags keeping the picks

## 5. Patrol

- [ ] 5.1 Update the navigation and sign-in journeys to find the catalog page instead of the placeholder text, and verify both pass on Chrome, the Android emulator and the iOS simulator
- [ ] 5.2 Add `patrol_test/catalog_test.dart`: bags load; pick Café and Bakery; the summary and the web URL; Grocery disabled with the hint; remove one and Grocery is enabled; open the bad link and check the picks, the web URL and the notice; verify it passes on all three platforms

## 6. Verification

Sign-off: the catalog journey on web, Android and iOS. It shows two picks with the summary, the limit hint, a removal, and a bad link cleaned with the notice. The checks below support it.

- **Scripts**: `fvm exec melos run analyze`, `fvm exec melos run format:check` and `fvm exec melos run test` all exit 0, with `catalog` included.
- **Codegen**: `fvm exec melos run codegen` leaves no diff.
- **Bloc tests**: `CatalogBloc` covers every event, both repository results, the cleaned link and `restartable` load.
- **Patrol, catalog journey**: four bags show. Café and Bakery picked show "2 bags" and "R109,98", and on web the URL reads `/?bags=bag_cafe,bag_bakery`. Grocery is disabled with "You can pick up to 2 bags". Removing Bakery enables Grocery. `/?bags=bag_unknown,bag_cafe,bag_cafe,bag_bakery,bag_grocery` shows Café and Bakery picked, `/?bags=bag_cafe,bag_bakery` on web, and the notice.
- **Patrol, navigation and sign-in journeys**: still pass on all three platforms.
- **Web, manual**: pick two bags, refresh, and the picks stay. Press Back after picks, and the browser leaves Bags in one step.
- **Web, manual**: resize across 600px and 840px, and the tiles move between one and two columns with the summary visible.

- [ ] 6.1 Run every automated check above and confirm each passes
- [ ] 6.2 Record the catalog journey on web, Android and iOS and paste the output in the PR description
- [ ] 6.3 User verifies the slice

## Workflow follow-up

- Open a PR from `feat/bag-catalog` to `main` after the user signs off (see docs/ORACLE.md).
- Archive the change with `openspec archive bag-catalog` after the merge.
