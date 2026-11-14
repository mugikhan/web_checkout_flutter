# Proposal

## Why

Orders and checkout sessions need an owner, and the order routes must sit behind a sign-in. Later slices build on the data layer, the storage and the route guard this slice adds, so they come first.

## What Changes

- Add `packages/storage`: key-value persistence over `shared_preferences`, with a client namespace and a "server" namespace ([ADR-0006](../../../docs/adr/0006-graphql-codegen-local-link.md), [ADR-0011](../../../docs/adr/0011-simulated-auth.md)).
- Add `packages/api` with a domain layer and a data layer ([ADR-0005](../../../docs/adr/0005-clean-architecture-in-api.md)). The data layer holds `schema.graphql`, the `.graphql` operations, generated typed code, a `LocalLink` and the local "server" ([ADR-0006](../../../docs/adr/0006-graphql-codegen-local-link.md)).
- Add a `signIn(name)` mutation and a `viewer` query. `signIn` returns a typed result union, so an invalid name is a schema member and not an error map ([ADR-0007](../../../docs/adr/0007-typed-result-unions.md)).
- Validate the name twice: the form rejects it inline, and the "server" rejects it again. A name needs more than 3 characters after trimming.
- Store the token in the client namespace. `LocalLink` reads it from the request context, as a server reads an `Authorization` header. Sign out deletes it. The session survives a browser refresh.
- Add `modules/auth` with the session and sign-in blocs and the Sign in and Account pages ([ADR-0008](../../../docs/adr/0008-bloc-with-concurrency.md)). The Account page replaces the placeholder and shows the viewer's name and a Sign out action.
- Guard `/account`. A signed-out user goes to `/sign-in?from=/account` and returns after sign-in. `/sign-in` sits outside the navigation shell ([ADR-0009](../../../docs/adr/0009-go-router-url-holds-draft.md)).
- Wire dependencies with plain get_it: each package and module exports one registration function, and the app's composition root calls them ([ADR-0012](../../../docs/adr/0012-get-it-registration.md)).
- Add the `AppTextField` atom to `DESIGN.md` and `packages/ui`. `packages/ui` re-exports Material, so the first module never imports `material_ui` ([ADR-0002](../../../docs/adr/0002-material-ui-split.md)).
- Add a Melos `codegen` script and commit the generated code. The analyzer and the format check skip generated files. CI does not run build_runner ([ADR-0020](../../../docs/adr/0020-commit-generated-code.md)).
- Add an import-boundary check to `melos run analyze`. It fails when a module imports the api data layer or `src/`.
- Add a patrol journey for sign-in and record it on web, Android and iOS ([ADR-0015](../../../docs/adr/0015-testing-strategy.md), [ADR-0017](../../../docs/adr/0017-running-and-recording-patrol-tests.md)).

## Out of scope

- Bags, checkout sessions, orders and their resolvers. They arrive in `bag-catalog`, `checkout` and `order-details`.
- Ownership checks on orders. The request context carries the viewer now; the order resolvers use it later.
- Passwords, real accounts, token expiry and server-side sign-out. Sign out only deletes the client token.
- Subscriptions in `LocalLink`. They arrive with the order status timeline.
- Guards on `/orders/:orderId` and `/checkout/:sessionId`. Those routes do not exist yet.

## Capabilities

### New Capabilities

- `user-session`: How a viewer signs in with a name, how the name is validated, how the session survives a refresh, and how the viewer signs out.

### Modified Capabilities

- `app-navigation`: Account becomes a guarded destination. A new public `/sign-in` route sits outside the shell and returns the user to where they came from.
- `workspace-tooling`: The patrol requirements name the navigation and sign-in journeys instead of the removed smoke journey. New requirements cover committed generated code and the import-boundary check.
- `design-language`: Text fields show their label and an inline error in the error colour.

`app-platforms` keeps its requirements.

## Impact

- New members: `packages/storage`, `packages/api`, `modules/auth`. The root `pubspec.yaml` lists them in the workspace.
- New dependencies: `shared_preferences` (storage), `graphql`, `graphql_codegen` and `build_runner` (api), `bloc`, `flutter_bloc` and `bloc_concurrency` (auth), `get_it` (storage, api, auth, app), and `bloc_test` for tests.
- Changed: the app's `main` becomes async and runs the composition root. The router gains a redirect and the sign-in route. The navigation journey now meets the sign-in page when it opens Account.
- Changed: `analysis_options.yaml` excludes generated files. Melos gains `codegen` and the boundary check. CI also runs on changes under `tool/`.
