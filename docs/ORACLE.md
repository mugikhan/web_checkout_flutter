# Oracle

This file records every answer the user gave in the planning ("grill me") session of 2026-11-14 and in later sessions. Read it before you plan or implement a slice, especially after context is lost.

- ADRs in `docs/adr/` record the foundational decisions with their reasons. This file records all answers, including the small ones that never needed an ADR.
- When this file and an ADR disagree, the later decision wins. Tell the user about the conflict.
- When the user decides something new, add it here in the same change.
- The assignment itself is `docs/assignment-brief.pdf`.

## Toolchain and workspace

| Topic | Answer | Source |
|---|---|---|
| Flutter | 3.47.9, pinned with FVM in `.fvmrc`. Run every `flutter` and `dart` command through `fvm`. Workspace SDK constraints match the pinned version. | Grill round 1 |
| Material split | Opt in. Use `material_ui` only; no direct `cupertino_ui`. "Good enough for the scope." | ADR-0001 |
| Workspace | Pub workspace: `packages/` (shared) → `modules/` (features) → `apps/` (journeys). Modules never import modules. | ADR-0002 |
| Package names | `packages/api`, not `graphql_api`, in case other API types arrive. | Grill round 1 |
| When to add directories | Add a package, module or atom only in the slice that first uses it. | Grill round 1 and 2 |
| Task runner | Melos 7 (`^7.8.2`), configured in the root `pubspec.yaml`. The user chose 7 over the newer 8. Run it as `fvm exec melos run <script>`; a global Melos otherwise resolves with the global Flutter and fails. | Grill round 1, session 2026-11-14 |
| Melos scripts | `analyze`, `format:check`, `test`, plus `codegen` and the import-boundary check once `packages/api` exists. Put package filters on `melos exec` flags (`--flutter`, `--dir-exists`); script-level `packageFilters` prompt and crash without a terminal. Flutter `analyze` and `test` run with `-c 1` to avoid the startup lock. | Sessions 2026-11-14/15 |
| Lints | The default `flutter create` analysis options (`flutter_lints`). | Grill round 1 |
| App identity | Title "Bag Checkout", fictional store "Corner Pantry", bundle id `dev.mugikhan.bagcheckout`. No Refreshi name or logo. | Grill round 6, ADR-0011 |
| Platforms | Web first; iOS and Android run from the same codebase. | Brief |
| Hosting | None. Reviewers run locally. | Grill round 3 |
| Localization | English only, no ARB files, `intl` formatting in `en_ZA`. | Grill round 3 |
| Deadline | None. | Grill round 1 |
| Time box | Accept going over the brief's 6–8 hours. "With agentic development it is not the same measure of time." Note it in SOLUTION.md. | Grill round 1 |
| Optional brief item (web perf or one test) | Deferred; left out for now. | Grill round 3 |

## Architecture

| Topic | Answer | Source |
|---|---|---|
| Layers in `packages/api` | Clean architecture. Domain barrel at `lib/domain/domain.dart`, data barrel at `lib/data/data.dart`. Modules import the domain barrel only. | ADR-0003 |
| Use cases | None; "overkill". Blocs call repositories. | Grill round 4 |
| GraphQL client | `graphql_codegen` + build_runner, with a custom `LocalLink` that routes by operation name to typed resolvers. | ADR-0004 |
| Generated code | Committed. A Melos `codegen` script regenerates it; CI does not run build_runner. | ADR-0013 |
| Failures | Typed GraphQL result unions, mapped to sealed domain failures. | ADR-0005 |
| State | bloc with bloc_concurrency: confirm `droppable`, `setPaymentMethod` `restartable`, loads `restartable`, status subscription `restartable` and cancelled on close. | ADR-0006 |
| DI | Plain get_it, one `registerXModule(GetIt)` per module, no injectable. | ADR-0010 |
| Fake backend storage | The in-app "server" persists through `packages/storage` (shared_preferences), in its own namespace. | Grill round 1 |

## Routing

| Topic | Answer | Source |
|---|---|---|
| Router | go_router with path URLs. | ADR-0007 |
| Routes | `/sign-in?from=…`, `/?bags=…` (catalog), `/checkout/:sessionId?bags=…&slot=…`, `/orders/:orderId`, `/account`. | Grill rounds 2–4 |
| Guards | Checkout and order routes are guarded. In `simulated-auth`, `/account` is the guarded route that proves the redirect and return-to. Bags stays public. | Grill round 2, session 2026-11-15 |
| Shell | `StatefulShellRoute` with two destinations: Bags and Account. | Grill round 5 |
| Checkout layout | Full screen, outside the shell, no nav. A close (✕) button returns to `/?bags=…`. No "are you sure" dialog. The user may change this after verifying that slice. | Grill round 5–6 |
| Orders layout | `/orders/:orderId` sits inside the shell under Bags. | Grill round 5 |
| After confirm | Navigate to the order with replace, so Back never returns to a confirmable checkout. | Grill round 3 |
| Bad bag links | When `/?bags=` holds unknown ids, duplicates or more than 2 ids, the catalog drops unknown ids and duplicates and keeps the first 2 valid ids. It replaces the URL with the clean one, with no new history entry, and shows the notice "A max of 2 bags can be selected, some bags were removed" in the error colours (`errorContainer` with `onErrorContainer`). The user chose this wording and colour after the first recordings. | Session 2026-11-15 |
| Unknown URLs | "Page not found" built from `StateView`, with one action, "Go to Bags". The address bar keeps the unknown URL. The view sits outside the shell. A known route with a missing record, such as an unknown order id, is handled inside that slice's page. No silent redirect to `/`. | Session 2026-11-15 |

## Domain: bags and checkout

| Topic | Answer | Source |
|---|---|---|
| What is sold | Bags, like Refreshi's surplus bags: Grocery, Café, Bakery and Surprise. One fictional store. Each bag has a price and a higher "worth". | Grill round 3 |
| Term | "Bag" everywhere; the brief's "services" maps to bags. `bags=` in URLs. | Grill round 3 |
| Quantity | Up to 2 different bags per order, each bag at most once. | Grill round 4 |
| Money | Integer cents in ZAR, formatted `en_ZA`. | Grill round 2 |
| Collection windows | 1-hour windows from 09:00 to 22:00, today and tomorrow only. Windows that already started are hidden. No capacity limit. Stored in UTC, shown in local time. | Grill rounds 3–4 |
| Draft | The URL holds the draft: bags and slot. The catalog keeps its selection in `/?bags=…` too. | Grill rounds 3–4 |
| Catalog summary | The catalog shows a selection summary: the number of bags picked and the total price. It has no "Continue" action yet. The `checkout` slice adds Continue together with `createCheckoutSession`. | Session 2026-11-15 |
| Bag limit in the catalog | With 2 bags selected, the unselected bags become disabled and show the hint "You can pick up to 2 bags". Deselecting a bag enables them again. | Session 2026-11-15 |
| Checkout session | `createCheckoutSession` (no args; the owner comes from the viewer) returns a session id for the URL. The session id is the idempotency key. | ADR-0008 |
| Session expiry | 15 minutes after creation. Expired → "This checkout expired" and "Start again", which keeps the bags and drops a passed slot. | Grill round 4 |
| Unknown session | Rejected (`SessionNotFound`) with a way to start again. The server never accepts unknown or expired sessions. | Grill round 3 |
| Session status | `OPEN`, `COMPLETED(orderId)` or `EXPIRED`. Opening a completed session redirects with replace to its order. | Grill round 4 |
| Payment method | `setPaymentMethod(sessionId, cardId)` stores the card against the session on the "server". The card never goes in the URL. | Grill round 3 |
| Saved cards | Two seeded cards per user: "Visa •••• 4242" succeeds; "Mastercard •••• 0002" declines. No card is preselected; Confirm stays disabled until `setPaymentMethod` succeeds. | Grill round 4 |
| Confirm | `confirmCheckout(sessionId, bagIds, slotStart)` creates at most one order per session; a repeat returns the existing order. The resolver validates session, bags, slot and payment method. | ADR-0008 |
| Confirm failures | Union members: `SessionExpired`, `SlotUnavailable`, `PaymentMethodMissing`, `InvalidBags`, `SessionNotFound`. | ADR-0005 |
| Price snapshot | Orders snapshot bag names and prices at confirm time. | Grill round 4 |

## Domain: orders

| Topic | Answer | Source |
|---|---|---|
| Statuses | Created → Pending → Confirmed or Failed. | Grill round 3 |
| Pending to confirmed | GraphQL subscription `orderStatusChanged`, served by `LocalLink`. The server stores `holdConfirmsAt`, so a refresh during the delay still ends in the right state. | Grill round 2 |
| Delay | The hold confirms or fails 3 seconds after confirm. The decline card fails it. | Grill round 3 |
| Timeline | Animated, with a timestamp per reached state. | Grill round 3 |
| Details page | Order id, store, each bag with snapshot price, total, collection window in local time, masked payment method, timeline. | Grill round 5 |
| Failed order | Shows the reason and "Back to bags". No retry. | Grill round 5 |
| Orders list | None. Orders are reached by the confirm redirect or a deep link. | Grill round 3 |

## Auth

| Topic | Answer | Source |
|---|---|---|
| Mechanism | `signIn(name)` GraphQL mutation returns a Viewer and token. `LocalLink` reads the token from the request context. Resolvers check ownership. | ADR-0009 |
| Name rule | Any non-empty name with more than 3 characters, validated in the form and on the "server". | Grill round 4 |
| Session | Survives refresh. Sign out sits on the Account page. | Grill rounds 1, 4 |
| Other users | Another user's order or session reads as "not found". | Grill round 4 |

## UI and design

| Topic | Answer | Source |
|---|---|---|
| Reference | refreshi.co.za home page only: main colours, button and text colours, font. Infer the rest. | Grill round 2 |
| Design source | `DESIGN.md` at the repo root, with tests that check code against it and check AA contrast. | ADR-0011 |
| Font | DM Sans for everything, loaded with `google_fonts`. | Grill round 2 |
| Themes | Light and dark, following the system. | Grill round 2 |
| Navigation | Material 3 window sizes: bottom bar under 600px, rail 600–839px, extended rail with labels from 840px. `AdaptiveScaffold` in `packages/ui` owns the switch; breakpoints are tokens. Checkout shows no nav at any size. | Grill round 4 |
| Atoms | In `packages/ui`. Add each atom when a slice first needs it. | Grill round 5 |
| Gallery | None. | Grill round 5 |
| Keys and semantics | Every interactive widget gets a test key and a semantic label. | Grill round 4 |

## Testing and verification

| Topic | Answer | Source |
|---|---|---|
| Tools | patrol + patrol_cli for each slice's journey; `bloc_test` for every bloc. | ADR-0012 |
| Native setup | Patrol runs on Chrome, Android and iOS. Android uses `PatrolJUnitRunner` with the test orchestrator. iOS uses the `RunnerUITests` target, which links `FlutterGeneratedPluginSwiftPackage` (Swift Package Manager), with parallel testing off in the `Runner` scheme. Web runs through Playwright and needs Node.js. Physical iOS devices are out. | Session 2026-11-15 |
| Running journeys | From `apps/web_checkout`: `fvm exec patrol test --device <id>`. Ids: `chrome` (add `--web-headless` to hide the browser), the emulator id from `adb devices`, or the simulator UDID from `xcrun simctl list devices`. One journey file runs on every platform; web-only checks sit behind `kIsWeb`. One `app.main()` per journey file. | Session 2026-11-15 |
| Recordings | Recorded with the run-patrol-test skill and committed under `apps/web_checkout/patrol_test/recordings/`, not gitignored. Start recording from `simulated-auth`; the bootstrap smoke journey had none. A journey under about a second films nothing. | Sessions 2026-11-15 |
| Recording skill | Installed at `.agents/skills/run-patrol-test`, linked from `.claude/skills`. Start it with `/run-patrol-test`; it never starts by itself. Without an agent: `fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart plan --test <name>`, then `fvm exec dart run … run --test <name> --device <id>`. `.patrol-runner.json` sets `defaultProject: apps/web_checkout` and `flutterCommand: fvm flutter`. Recorders: Playwright on web (MP4 with ffmpeg), `patrol test --record-video` on Android and the iOS simulator. | Session 2026-11-15 |
| Skill patch | The installed `SKILL.md` carries a marked project patch: script commands use `fvm dart`, and the printed command runs under `fvm exec`. A reinstall with `install.sh --force` drops it; apply it again. | Session 2026-11-15 |
| Sign-off | The user decides what counts as sign-off. For `design-system` it was a recording on web, Android and iOS showing the Bags and Account screens. From `simulated-auth`: the slice works as expected, plus an error case where one can occur. | Sessions 2026-11-15 |

## Process

| Topic | Answer | Source |
|---|---|---|
| Spec flow | OpenSpec: one change per slice, implemented one at a time. Flow: propose, review, apply, verify, sign-off, archive. Each `tasks.md` ends with a Verification section and the task "User verifies the slice". Write the next proposal only after the previous slice is signed off. | User, first message; grill round 3 |
| Slice delivery | An Opus subagent at medium effort proposes, implements and verifies each slice, then reports. The main session settles decisions before dispatch and handles sign-off, PR and archive. A failure or error makes the subagent report back. | Session 2026-11-15 |
| ADRs | Ask the user before a foundational decision. Write an ADR only for a choice with lasting impact, a meaningful trade-off, or a high cost to reverse: one a future engineer would ask "why was this built this way?" about. Everything else goes in this file. Use the house template in `docs/adr/`. | User, first message; session 2026-11-15 |
| Branches | `feat/<change>` off `main`, one PR per slice to `main`, merged after sign-off. A slice that depends on an unmerged one stacks its PR on that branch. No `develop` branch ("overkill for the assignment"). | Session 2026-11-15 |
| CI | Analyze and unit tests on PRs to `main` that change code, tooling or `DESIGN.md`. Docs, ADR and OpenSpec PRs skip CI. No build_runner and no patrol in CI. | ADR-0012, session 2026-11-15 |
| Commits | Conventional Commits in small logical steps. | Grill round 6 |
| README | Do not add notes for side changes, such as editor config, unless asked. | Session 2026-11-15 |
| Editor | Shared `.vscode/launch.json` (web, mobile, both) and `settings.json` pointing at `.fvm/flutter_sdk`. | Session 2026-11-15 |

## Roadmap

1. `bootstrap-workspace`: done.
2. `design-system`: done.
3. `simulated-auth`: done.
4. `bag-catalog`: done.
5. `checkout`
6. `order-details`
7. `docs-and-delivery`: README, SOLUTION.md with the "AI usage" section, Loom video.
