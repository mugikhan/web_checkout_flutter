# Solution

A Flutter checkout for surplus food bags, built web first and run on iOS and Android from one codebase. A customer picks up to two bags, picks a collection window and a saved card, and confirms. The app places a hold and shows the order with a live status timeline.

Run instructions are in [README.md](README.md). The full decision record lives in [docs/adr/](docs/adr/README.md) (architecture) and [docs/ORACLE.md](docs/ORACLE.md) (everything else).

## Shape

```text
packages/   ui (tokens, theme, atoms) · storage (key-value) · api (GraphQL schema, LocalLink, in-app "server", repositories)
modules/    auth · catalog · checkout · orders        (blocs and pages; import only package:api/domain)
apps/       web_checkout                              (go_router, get_it composition root, journeys)
```

A module never imports another module. A script in `melos run analyze` fails the build if a module reaches into the api data layer.

## Decisions

Each bullet is a choice I made or confirmed: what I chose and what I rejected.

- Chose Flutter 3.47.9 pinned with FVM and Melos 7, rejected Melos 8.
- Chose `material_ui` only as it was easier to theme with a custom design system. Rejected `cupertino_ui` direct usage.
- Chose Pub workspace: packages → modules → app for maintainability and ease of future development. Rejected one package with folders as well as all features in the app.
- Chose Clean architecture in `packages/api`; everything depends on the domain models in pure dart. Rejected use cases and a repository per module.
- Chose `graphql_codegen` with an in-app `LocalLink` and a fake "server". Rejected an in-process GraphQL executor; a real backend.
- Chose to commit generated code as it is quicker and cheaper on CI.
- Chose typed result unions in the schema for failures to map to domain failures. Rejected error codes in `extensions`. Cost: wordier operations.
- Chose bloc with bloc_concurrency and get_it, bloc handles streams, blocking state updates using transformers and I am familiar with it. Rejected `injectable` as it is not necessary and makes it harder to see at a glance what is registered.
- Chose `go_router` as it supports deep linking on web and supports mobile.
- Chose a server-issued checkout session as the idempotency key stored in the url, unknown and expired sessions are rejected. Rejected the card token in the url.
- Chose a simulated auth using a token in a request header, ownership checked by the "server". Rejected passing the user in each mutation.
- Chose to pull design tokens from refreshi.co.za in `DESIGN.md`, DM Sans font via google_fonts. Also added support for light and dark mode.
- Chose Material 3 window sizes, bottom nav bar on mobile, compact rail on tablet and an extended rail on desktop.
- Chose to show the Bags and Account screens only. Rejected an orders list as it was not required by the assignment.
- Chose visible notices for a bad bag link, a stale window and a declined payment; "Page not found" and "Order not found" pages. Rejected silent clean-ups and redirects.
- Chose a `patrol` journey (E2E test) per slice on web, Android and iOS; `bloc_test` and `mocktail` for unit testing business logic. Recordings committed as slices were completed. Rejected integration_test; patrol in CI as it would slow it down a lot and increase cost.
- Chose to set up an `analyze and unit test` GH workflow on PRs to `main`.
- Chose OpenSpec slices, each signed off from recordings; ADRs only for architecture; one PR per slice into `main`. More ceremony than the brief's 6–8 hours however with agentic development, hours are a different measure.

## Repeated actions and refresh

The brief asks that double clicks and refreshes never create duplicate financial outcomes.

- Continue creates a checkout session on the "server". Its id goes into the URL and acts as the idempotency key.
- `confirmCheckout` checks the session before anything else. A completed session returns its existing order, so a repeat never creates a second one. Confirms run one at a time, so two concurrent requests still create one order.
- On the client, confirm uses a `droppable` transformer, and the button stays busy until the route changes.
- After confirm, the app replaces the URL with the order. Back never returns to a confirmable checkout, and a refresh on a completed session redirects to its order.
- The order status comes from stored times, not a timer. A refresh during the 3-second hold still settles at the original time.

The trade-off: the "server" lives in the app. Its one-at-a-time rule holds within one app instance, and clearing all site data removes it.

## Optional item

I chose tests over a web performance change. The most meaningful are the resolver test "two confirms at once create one order" and the checkout journey, which double-taps Confirm on three platforms and finds one stored order.

## AI usage

- **Tools:** Claude Code with OpenSpec.
  - The Opus main session handled planning, specs and orchestration.
  - Opus and Sonnet subagents handled implementation, blind verification and chores.
  - I used my own run-patrol-test skill for recordings.
- **Planning:** a "grill me" session turned my stack choices into answered questions. ADRs and the oracle record the answers.
- **Implementation:** one subagent per slice built from the OpenSpec change.
- **Review:** a separate Sonnet verifier saw only the spec and the branch, never the implementer's notes. It recorded each journey and opened the PR.
- **Debugging:** agents found and fixed issues: a browser history entry left behind by go_router's `replace`, a Melos prompt that crashed once a second package joined, and a page flash on "Back to bags".

### Agent suggestions

**Accepted:**
- The server-issued checkout session design.
- The verifier's trace of every duplicate-order path, under double taps, concurrent requests, refresh and Back.
- The history fix that keeps sign-in out of Back.

**Changed:**
- I rewrote the bad-link notice text and moved it to the error colours.
- I turned a silent stale-window clean-up into a visible notice.
- I asked for the "Back to bags" transition to be fixed after I saw it flash in local testing.
- I moved the declined-payment coverage into the order slice when the checkout videos had no failing case.

**Rejected:**
- A suggestion to accept unknown sessions from the URL.
- Putting the card token in the URL.
- Agent README edits I had not asked for.
- Twenty ADRs, which I cut to thirteen and moved the rest into the oracle.

## Verification

- Every slice passed `openspec validate --strict`, analyze, format and tests, and CI on its PR.
- The blind verifier agent re-ran every patrol journey on web, Android and iOS.
- I watched the recordings of each slice and tested locally on Web before signing off.
- I tested breakpoints and dark mode locally.
