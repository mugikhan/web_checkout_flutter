# Tasks

## 1. Checkout domain in packages/api

- [x] 1.1 Add `CollectionWindow`, `SavedCard`, `CheckoutSession`, the sealed results and failures, and `CheckoutRepository` behind `lib/domain/domain.dart`; verify tests for `CollectionWindow.offered` at 08:30, 13:00 and 21:30, and for `slotParam` and `parseSlot`

## 2. Checkout "server" in packages/api

- [x] 2.1 Add the checkout types, unions and operations to `schema.graphql` and `checkout.graphql`, run `fvm exec melos run codegen`, and verify `fvm exec melos run analyze` passes
- [x] 2.2 Add `CheckoutStore` and `CheckoutResolvers` with an injected clock, route the new operations in `LocalServer`, and verify resolver tests: create, owner, read, expiry, foreign and unknown sessions, saved cards, `setPaymentMethod` (stored, unknown card, expired, completed), every confirm rule, a repeat confirm, two concurrent confirms, and the order record with snapshot prices, `holdConfirmsAt` and `declines`
- [x] 2.3 Add `GraphqlCheckoutRepository` and register it in `registerApiData`; verify mapping tests over `LocalServer` for every result and over a broken link (`CheckoutUnavailable`), and the "every operation has a resolver" test
- [x] 2.4 Run `fvm exec melos run codegen` again and verify `git status` shows no change to generated files

## 3. UI atoms

- [x] 3.1 Add `formatClock`, and verify tests for 09:05, 14:00 and 00:00
- [x] 3.2 Add the `WindowChip` and `SavedCardTile` rows to `DESIGN.md`, then the atoms in `packages/ui`; verify widget tests for picked and unpicked colours, busy state, taps and semantics in both themes

## 4. modules/checkout

- [x] 4.1 Create `modules/checkout` as a workspace member with `ui`, `api`, `bloc`, `flutter_bloc`, `bloc_concurrency` and `get_it`, and verify it resolves with no `material_ui` dependency
- [x] 4.2 Add `CheckoutStartBloc`, and verify `bloc_test` cases: started, failed, retry and `droppable` start
- [x] 4.3 Add `CheckoutBloc`, and verify `bloc_test` cases: open, completed, expired, not found and failed loads; bag and slot cleaning; card picked, failed and `restartable` (last card wins); confirm success, each failure, the `SlotUnavailable` reload, the `canConfirm` guard and `droppable` double confirm
- [x] 4.4 Add `CheckoutKeys`, `CheckoutStartPage`, `CheckoutPage` and `registerCheckoutModule`; verify widget tests for loading, failed, not found, expired, no bags, ready, the disabled Confirm, both layouts, the clean-URL, close, start-again and completed callbacks
- [x] 4.5 Verify `fvm exec melos run analyze` still passes the import-boundary check with the new module
- [x] 4.6 Show the stale slot notice for a passed or unknown slot on load and for `SlotUnavailable` on confirm, keep Confirm disabled until a new window, and verify bloc and page tests for both cases, the dropped slot and the cleared notice

## 5. Catalog Continue

- [x] 5.1 Add the Continue action and `onContinue` to `CatalogPage`, and verify widget tests: disabled with nothing picked, enabled with 1 or 2 picks, and the callback receives the picks

## 6. App wiring

- [x] 6.1 Add `AppRoutes.isGuarded`, `checkoutStart`, `checkoutLocation`, `orderLocation` and `slotFrom`, and use `isGuarded` in `authRedirect`; verify unit tests for guarded paths, builders and the `from` for a checkout URL
- [x] 6.2 Add the `/checkout/new`, `/checkout/:sessionId` and `/orders/:orderId` routes, `OrderPlaceholderPage`, `registerCheckoutModule`, and Continue on Bags; verify router tests for the signed-in start, the signed-out redirect, the placeholder in the shell, the completed redirect and close
- [x] 6.3 Refresh the router from `SessionBloc` in the app, with `Router.neglect` on sign-in; verify the router and auth redirect tests still pass and `fvm flutter build web` succeeds
- [x] 6.4 Verify router tests: a passed slot leaves the URL with the notice, and `SlotUnavailable` on confirm stays on checkout without a slot

## 7. Patrol

- [x] 7.1 Update the navigation, sign-in and catalog journeys where Continue or the new routes change what they see, and verify they pass on Chrome, the Android emulator and the iOS simulator
- [x] 7.2 Add `patrol_test/checkout_test.dart`: signed-out Continue, sign in, checkout with the bags (web URL holds the session id and bags), pick the first offered window (web URL gains `slot`), Confirm disabled, pick Visa, double-tap Confirm, one order and the placeholder with its id, web Back skips checkout, then an unknown session shows "Checkout not found" with Start again; verify it passes on all three platforms
- [ ] 7.3 Extend the checkout journey: open a checkout URL whose `slot` is a day in the past, see the notice and the URL without `slot`, then pick a window and see the notice clear; verify it passes on all three platforms

## 8. Verification

Sign-off: the checkout journey on web, Android and iOS. It shows a signed-out Continue, sign-in, a window and a card picked, a double-tapped Confirm that lands on one order, and the not-found error case. The checks below support it.

- **Scripts**: `fvm exec melos run analyze`, `fvm exec melos run format:check` and `fvm exec melos run test` all exit 0, with `checkout` included.
- **Codegen**: `fvm exec melos run codegen` leaves no diff.
- **Bloc tests**: `CheckoutStartBloc` and `CheckoutBloc` cover every event, every repository result, `restartable` card picks and `droppable` confirm.
- **Server tests**: a repeat confirm and two concurrent confirms each leave one order.
- **Patrol, checkout journey**: as in task 7.2. On web the URL reads `/checkout/<id>?bags=bag_cafe,bag_bakery`, then gains `slot`, then reads `/orders/<id>`, and Back leaves the order for `/?bags=bag_cafe,bag_bakery`. A checkout URL with a past `slot` shows "That time slot is no longer available, please select another time slot and confirm your order" and loses `slot`.
- **Patrol, navigation, sign-in and catalog journeys**: still pass on all three platforms.
- **Web, manual**: refresh on checkout after picking a window and a card, and both stay picked. Refresh on the order page, and it still shows the order id.
- **Web, manual**: resize across 840px, and the page moves between two columns and the bottom confirm bar.

- [ ] 8.1 Run every automated check above and confirm each passes
- [ ] 8.2 Record the checkout journey on web, Android and iOS and paste the output in the PR description
- [ ] 8.3 User verifies the slice

## Workflow follow-up

- Open a PR from `feat/checkout` to `main` after the user signs off (see docs/ORACLE.md).
- Archive the change with `openspec archive checkout` after the merge.
