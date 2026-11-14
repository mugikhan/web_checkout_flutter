# Oracle

This file records every answer the user gave in the planning ("grill me") session of 2026-11-14 and in later sessions. Read it before you plan or implement a slice, especially after context is lost.

- ADRs in `docs/adr/` record the foundational decisions with their reasons. This file records all answers, including the small ones that never needed an ADR.
- When this file and an ADR disagree, the later decision wins. Tell the user about the conflict.
- When the user decides something new, add it here in the same change.
- Slice briefs for subagents live in `docs/briefs/`.

## Toolchain and workspace

| Topic | Answer | Source |
|---|---|---|
| Flutter | 3.47.9, pinned with FVM. Run every command through `fvm`. | ADR-0001 |
| Material split | Opt in. Use `material_ui` only; no direct `cupertino_ui`. "Good enough for the scope." | ADR-0002 |
| Workspace | Pub workspace: `packages/` (shared) → `modules/` (features) → `apps/` (journeys). Modules never import modules. | ADR-0003 |
| Package names | `packages/api`, not `graphql_api`, in case other API types arrive. | Grill round 1 |
| When to add directories | Add a package, module or atom only in the slice that first uses it. | Grill round 1 and 2 |
| Task runner | Melos 7 (`^7.8.2`). The user chose 7 over the newer 8. | ADR-0004 |
| Lints | The default `flutter create` analysis options (`flutter_lints`). | Grill round 1 |
| App identity | Title "Bag Checkout", fictional store "Corner Pantry", bundle id `dev.mugikhan.bagcheckout`. No Refreshi name or logo. | Grill round 6, ADR-0013 |
| Platforms | Web first; iOS and Android run from the same codebase. | Brief |
| Hosting | None. Reviewers run locally. | Grill round 3 |
| Localization | English only, no ARB files, `intl` formatting in `en_ZA`. | Grill round 3 |
| Deadline | None. | Grill round 1 |
| Time box | Accept going over the brief's 6–8 hours. "With agentic development it is not the same measure of time." Note it in SOLUTION.md. | Grill round 1 |
| Optional brief item (web perf or one test) | Deferred; left out for now. | Grill round 3 |

## Architecture

| Topic | Answer | Source |
|---|---|---|
| Layers in `packages/api` | Clean architecture. Domain barrel at `lib/domain/domain.dart`, data barrel at `lib/data/data.dart`. Modules import the domain barrel only. | ADR-0005 |
| Use cases | None; "overkill". Blocs call repositories. | Grill round 4 |
| GraphQL client | `graphql_codegen` + build_runner, with a custom `LocalLink` that routes by operation name to typed resolvers. | ADR-0006 |
| Generated code | Committed. A Melos `codegen` script regenerates it; CI does not run build_runner. | ADR-0020 |
| Failures | Typed GraphQL result unions, mapped to sealed domain failures. | ADR-0007 |
| State | bloc with bloc_concurrency: confirm `droppable`, `setPaymentMethod` `restartable`, loads `restartable`, status subscription `restartable` and cancelled on close. | ADR-0008 |
| DI | Plain get_it, one `registerXModule(GetIt)` per module, no injectable. | ADR-0012 |
| Fake backend storage | The in-app "server" persists through `packages/storage` (shared_preferences), in its own namespace. | Grill round 1 |

## Routing

| Topic | Answer | Source |
|---|---|---|
| Router | go_router with path URLs. | ADR-0009 |
| Routes | `/sign-in?from=…`, `/?bags=…` (catalog), `/checkout/:sessionId?bags=…&slot=…`, `/orders/:orderId`, `/account`. | Grill rounds 2–4 |
| Guards | Checkout and order routes are guarded. In `simulated-auth`, `/account` is the guarded route that proves the redirect and return-to. Bags stays public. | Grill round 2, session 2026-11-15 |
| Shell | `StatefulShellRoute` with two destinations: Bags and Account. | ADR-0014 |
| Checkout layout | Full screen, outside the shell, no nav. A close (✕) button returns to `/?bags=…`. No "are you sure" dialog. The user may change this after verifying that slice. | Grill round 5–6 |
| Orders layout | `/orders/:orderId` sits inside the shell under Bags. | Grill round 5 |
| After confirm | Navigate to the order with replace, so Back never returns to a confirmable checkout. | Grill round 3 |
| Unknown URLs | "Page not found" with "Go to Bags". | ADR-0018 |

## Domain: bags and checkout

| Topic | Answer | Source |
|---|---|---|
| What is sold | Bags, like Refreshi's surplus bags: Grocery, Café, Bakery and Surprise. One fictional store. Each bag has a price and a higher "worth". | Grill round 3 |
| Term | "Bag" everywhere; the brief's "services" maps to bags. `bags=` in URLs. | Grill round 3 |
| Quantity | Up to 2 different bags per order, each bag at most once. | Grill round 4 |
| Money | Integer cents in ZAR, formatted `en_ZA`. | Grill round 2 |
| Collection windows | 1-hour windows from 09:00 to 22:00, today and tomorrow only. Windows that already started are hidden. No capacity limit. Stored in UTC, shown in local time. | Grill rounds 3–4 |
| Draft | The URL holds the draft: bags and slot. The catalog keeps its selection in `/?bags=…` too. | Grill rounds 3–4 |
| Checkout session | `createCheckoutSession` (no args; the owner comes from the viewer) returns a session id for the URL. The session id is the idempotency key. | ADR-0010 |
| Session expiry | 15 minutes after creation. Expired → "This checkout expired" and "Start again", which keeps the bags and drops a passed slot. | Grill round 4 |
| Unknown session | Rejected (`SessionNotFound`) with a way to start again. The server never accepts unknown or expired sessions. | Grill round 3 |
| Session status | `OPEN`, `COMPLETED(orderId)` or `EXPIRED`. Opening a completed session redirects with replace to its order. | Grill round 4 |
| Payment method | `setPaymentMethod(sessionId, cardId)` stores the card against the session on the "server". The card never goes in the URL. | Grill round 3 |
| Saved cards | Two seeded cards per user: "Visa •••• 4242" succeeds; "Mastercard •••• 0002" declines. No card is preselected; Confirm stays disabled until `setPaymentMethod` succeeds. | Grill round 4 |
| Confirm | `confirmCheckout(sessionId, bagIds, slotStart)` creates at most one order per session; a repeat returns the existing order. The resolver validates session, bags, slot and payment method. | ADR-0010 |
| Confirm failures | Union members: `SessionExpired`, `SlotUnavailable`, `PaymentMethodMissing`, `InvalidBags`, `SessionNotFound`. | ADR-0007 |
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
| Mechanism | `signIn(name)` GraphQL mutation returns a Viewer and token. `LocalLink` reads the token from the request context. Resolvers check ownership. | ADR-0011 |
| Name rule | Any non-empty name with more than 3 characters, validated in the form and on the "server". | Grill round 4 |
| Session | Survives refresh. Sign out sits on the Account page. | Grill rounds 1, 4 |
| Other users | Another user's order or session reads as "not found". | Grill round 4 |

## UI and design

| Topic | Answer | Source |
|---|---|---|
| Reference | refreshi.co.za home page only: main colours, button and text colours, font. Infer the rest. | Grill round 2 |
| Design source | `DESIGN.md` at the repo root, with tests that check code against it and check AA contrast. | ADR-0013 |
| Font | DM Sans for everything, loaded with `google_fonts`. | Grill round 2 |
| Themes | Light and dark, following the system. | Grill round 2 |
| Navigation | Material 3 window sizes: bottom bar under 600px, rail 600–839px, extended rail with labels from 840px. | ADR-0014 |
| Atoms | In `packages/ui`. Add each atom when a slice first needs it. | Grill round 5 |
| Gallery | None. | Grill round 5 |
| Keys and semantics | Every interactive widget gets a test key and a semantic label. | Grill round 4 |

## Testing and verification

| Topic | Answer | Source |
|---|---|---|
| Tools | patrol + patrol_cli for each slice's journey; `bloc_test` for every bloc. | ADR-0015 |
| Native setup | Patrol runs on Chrome, Android and iOS. | ADR-0017 |
| Recordings | Recorded with the run-patrol-test skill and committed under `apps/web_checkout/patrol_test/recordings/`, not gitignored. Start recording from `simulated-auth`; the bootstrap smoke journey had none. | ADR-0017 |
| Sign-off | The user decides what counts as sign-off. For `design-system` it was a recording on web, Android and iOS showing the Bags and Account screens. From `simulated-auth`: the slice works as expected, plus an error case where one can occur. | Sessions 2026-11-15 |

## Process

| Topic | Answer | Source |
|---|---|---|
| Spec flow | OpenSpec: one change per slice, implemented one at a time. No slice starts before the previous one is signed off. | ADR-0016 |
| Slice delivery | An Opus subagent at medium effort proposes, implements and verifies each slice, then reports. The main session settles decisions before dispatch and handles sign-off, PR and archive. A failure or error makes the subagent report back. | Session 2026-11-15 |
| ADRs | Ask the user before a foundational decision, then write an ADR in `docs/adr/` using the house template. | User, first message |
| Branches | `feat/<change>` off `main`, one PR per slice to `main`. No `develop` branch ("overkill for the assignment"). | ADR-0019 |
| CI | Analyze and unit tests on PRs to `main` that change code, tooling or `DESIGN.md`. Docs, ADR and OpenSpec PRs skip CI. Flutter scripts run with `-c 1`. | ADR-0015, session 2026-11-15 |
| Commits | Conventional Commits in small logical steps. | Grill round 6 |
| README | Do not add notes for side changes, such as editor config, unless asked. | Session 2026-11-15 |
| Editor | Shared `.vscode/launch.json` (web, mobile, both) and `settings.json` pointing at `.fvm/flutter_sdk`. | Session 2026-11-15 |

## Roadmap

1. `bootstrap-workspace`: done.
2. `design-system`: done.
3. `simulated-auth`: in progress (brief in `docs/briefs/simulated-auth.md`).
4. `bag-catalog`
5. `checkout`
6. `order-details`
7. `docs-and-delivery`: README, SOLUTION.md with the "AI usage" section, Loom video.
