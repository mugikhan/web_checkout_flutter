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

Each row is a choice I made or confirmed: what I chose, what I rejected, and what it cost.

| Area | Chose | Rejected | Cost |
|---|---|---|---|
| Toolchain | Flutter 3.47.9 pinned with FVM, Melos 7 | A global Flutter; Melos 8 | Reviewers need FVM, and Melos must run through `fvm exec` |
| UI layer | The material/cupertino split, `material_ui` only | Adaptive Cupertino widgets | No native iOS look |
| Structure | Pub workspace: packages → modules → app | One package with folders | More pubspecs and wiring per feature |
| Data | Clean architecture in `packages/api`; blocs call repositories | Use cases; a repository per module | The api package grows with every feature |
| GraphQL | graphql_codegen with an in-app `LocalLink` and a fake "server" | An in-process GraphQL executor; a real backend | Hand-written resolvers repeat the schema's rules |
| Generated code | Committed to the repo | Generating it in CI | A stale generated file can slip through |
| Failures | Typed result unions in the schema | Error codes in `extensions` | Wordier operations |
| State and DI | bloc with bloc_concurrency; plain get_it | injectable | Manual wiring in one composition root |
| Routing | go_router, path URLs; the URL holds the draft (bags, window) | Hash URLs; a draft in local storage | Every URL value needs validating |
| Idempotency | A server-issued checkout session as the key; unknown and expired sessions are rejected; the card is stored on the "server", never in the URL | Accepting unknown sessions from the URL | Wiping all browser storage also wipes the "server" |
| Auth | Simulated `signIn(name)`, token in a request header, ownership checked by the "server" | Passing the user in each mutation | Extra plumbing for a fake login |
| Design | Tokens from refreshi.co.za in `DESIGN.md`, DM Sans via google_fonts, light and dark, AA contrast fixes | Bundled fonts; `ColorScheme.fromSeed` | A short font swap on the first web load |
| Navigation | Material 3 window sizes: bar, rail, extended rail; Bags and Account only | An orders list | No order history |
| Product rules | Up to 2 different bags; windows 09:00–22:00, today and tomorrow; 15-minute sessions; one declining card; no retry | Quantities; a retry button | A failed payment means a new checkout |
| Error states | Visible notices for a bad bag link, a stale window and a declined payment; "Page not found" and "Order not found" pages | Silent clean-ups and redirects | More states to build and test |
| Testing | A patrol journey per slice on web, Android and iOS; bloc_test; mocked repositories in module tests; recordings committed | integration_test; patrol in CI | Slower local verification, and the repo grows with videos |
| CI | Analyze and unit tests on PRs to `main`, only when code changes | Running codegen or patrol in CI | No device tests in CI |
| Process | OpenSpec slices, each signed off from recordings; ADRs only for architecture; one PR per slice into `main` | A `develop` branch; twenty ADRs | More ceremony than the brief's 6–8 hours. With agentic development, hours are a different measure |

## Repeated actions and refresh

The brief asks that double clicks and refreshes never create duplicate financial outcomes.

- Continue creates a checkout session on the "server". Its id goes into the URL and acts as the idempotency key.
- `confirmCheckout` checks the session before anything else. A completed session returns its existing order, so a repeat never creates a second one. Confirms run one at a time, so two concurrent requests still create one order.
- On the client, confirm uses a `droppable` transformer, and the button stays busy until the route changes.
- After confirm, the app replaces the URL with the order. Back never returns to a confirmable checkout, and a refresh on a completed session redirects to its order.
- The order status comes from stored times, not a timer. A refresh during the 3-second hold still settles at the original time.

The trade-off: the "server" lives in the app. Its one-at-a-time rule holds within one app instance, and clearing all site data removes it.

## Optional item

I chose tests over a web performance change. The most meaningful are the resolver test "two confirms at once create one order" and the checkout journey, which double-taps Confirm on three platforms and finds one stored order. I deferred the performance work, such as deferred loading or bundled fonts.

## AI usage

- **Tools:** Claude Code with OpenSpec. A local, gitignored prompt log keeps every prompt.
  - The Opus main session handled planning, specs and orchestration.
  - Opus, Sonnet and Fable subagents handled implementation, blind verification and chores.
  - I used my own run-patrol-test skill for recordings.
- **Planning:** a "grill me" session turned my stack choices into answered questions. ADRs and the oracle record the answers.
- **Implementation:** one subagent per slice built from the OpenSpec change. Implementation later moved from Opus to Sonnet to cut usage after an Opus agent hit its limit.
- **Review:** a separate Sonnet verifier saw only the spec and the branch, never the implementer's notes. It recorded each journey and opened the PR.
- **Debugging:** agents found and fixed issues: a browser history entry left behind by go_router's `replace`, a Melos prompt that crashed once a second package joined, and a page flash on "Back to bags". I spotted the Flutter startup lock that failed CI, and an agent fixed it.

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
- A `develop` branch.
- Melos 8.
- Agent README edits I had not asked for.
- Twenty ADRs, which I cut to thirteen and moved the rest into the oracle.

**How I verified:**
- Every slice passed `openspec validate --strict`, analyze, format and tests, and CI on its PR.
- The blind verifier re-ran every patrol journey on web, Android and iOS.
- I watched the recordings of each slice before signing off.
- I tested breakpoints and dark mode locally.
