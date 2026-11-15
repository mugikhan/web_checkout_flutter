# Tasks

## 1. API: order query and status subscription

- [x] 1.1 Add the order domain types (`Order`, `OrderBag`, card, window times, `OrderStatus`, sealed `OrderResult`) and the `OrderRepository` interface behind the domain barrel, and verify `fvm exec melos run analyze` passes with the import-boundary check
- [x] 1.2 Extend `schema.graphql` with the richer `Order`, `OrderNotFound`, `OrderResult`, the `order` query and the `orderStatusChanged` subscription; add the operations file and run `fvm exec melos run codegen`; verify the generated code is committed and a second codegen run leaves no diff
- [x] 1.3 Add stream resolvers to `LocalLink` and verify a test that a subscription yields every event the resolver emits, then closes
- [x] 1.4 Add the order resolvers with derived status (injected clock and delay); verify resolver tests for Pending before the hold time, Confirmed and Failed after it, `OrderNotFound` for unknown and foreign ids, and a subscription that emits Pending then the settled order at the original hold time
- [x] 1.5 Add `GraphqlOrderRepository` with no-cache fetching, register it in `registerApiData`, and verify repository tests map every union member and an unexpected fault

## 2. UI: StatusTimeline

- [ ] 2.1 Add the `StatusTimeline` row to `DESIGN.md`, then the atom in `packages/ui`; verify widget tests for reached, upcoming and failed colours in both themes, the step times, the animation and its absence when animations are disabled
- [ ] 2.2 Add any missing timeline colour pairs to the contrast test and verify it passes

## 3. Orders module

- [ ] 3.1 Add `modules/orders` to the workspace with `OrderBloc` (restartable load and follow, subscription cancelled on close); verify bloc tests for load, follow to Confirmed, follow to Failed, a late open with no subscription, not found, unavailable with retry, and cancel on close
- [ ] 3.2 Add `OrderPage`, `OrdersKeys` and `registerOrdersModule`; verify page tests for the details content, the Pending timeline, Confirmed and Failed with "Back to bags", the decline reason in the error tone, "Order not found", loading and error states, and semantic labels

## 4. App wiring

- [ ] 4.1 Route `/orders/:orderId` to `OrderPage`, delete `OrderPlaceholderPage`, register the module in the composition root, and verify router tests for a guarded order URL, refresh on the order page with Bags selected, "Back to bags" to `/`, and an unknown order id
- [ ] 4.2 Keep the checkout journey and the checkout-confirm scenarios passing with the new page ("Order placed" heading, order id key), and verify with `fvm exec melos run test`

## 5. Order journey

- [ ] 5.1 Add `patrol_test/order_test.dart` covering a Visa order turning Confirmed, a Mastercard order turning Failed with its reason, and `/orders/ord_missing` showing "Order not found"; verify it passes on Chrome (`--web-headless`), emulator-5554 and the iOS simulator
- [ ] 5.2 Run all journeys (navigation, sign-in, catalog, checkout, order) on the three platforms and verify every one passes

## 6. Verification

Checks the verifier runs and the user signs off:

- **Scripts:** `melos run analyze` (with the boundary check), `format:check` and `test` all exit 0; `codegen` leaves no diff; `openspec validate order-details --strict` passes.
- **Journeys:** all five pass on Chrome, the Android emulator and the iOS simulator.
- **Recordings (sign-off):** the order journey recorded on web, Android and iOS. Each video shows a Visa order going Pending → Confirmed with times, a Mastercard order going Pending → Failed with "The payment was declined and you were not charged. Try placing the order again" and "Back to bags", and "Order not found" for an unknown id.
- **Error cases:** the declined payment and the unknown order id.
- **Manual, web:** refresh during the hold keeps the original hold time; refresh after the hold shows the settled status at once.

- [ ] 6.1 Run every automated check above and confirm it passes
- [ ] 6.2 Record the order journey on web, Android and iOS and paste the output in the PR description
- [ ] 6.3 User verifies the slice

## Workflow follow-up

- Merge the PR into `main` after CI passes and the user signs off.
- Archive the change with `openspec archive order-details` after the merge.
