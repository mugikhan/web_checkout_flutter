# Design

## Context

The app has a go_router shell with Bags and Account branches, placeholder pages and a not-found view (see `openspec/specs/app-navigation`). `packages/ui` holds the tokens, themes and four atoms. There is no data layer, no persistence, no module and no dependency injection yet. See proposal.md for why this slice adds them.

## Goals / Non-Goals

**Goals:**
- A data layer that later slices extend with operations and resolvers, without changes to the link or the client.
- A route guard that later slices reuse for `/checkout/:sessionId` and `/orders/:orderId` by adding a path to one list.
- Tooling that keeps generated code and the import boundary honest from the first module.

**Non-Goals:**
- No caching of GraphQL results. Every request goes to `LocalLink`.
- No shared `Result` type across features. Each operation gets its own sealed result.

## Decisions

### New members and why this slice needs them

| Member | Why now |
|---|---|
| `packages/storage` | The token and the "server" sessions must survive a refresh. |
| `packages/api` | `AuthRepository`, the schema and `LocalLink` live here (ADR-0005, ADR-0011). |
| `modules/auth` | The first feature module: the session and sign-in blocs and the Sign in and Account pages. |
| `AppTextField` (ui atom) | The sign-in form is the first screen with text input. |

### Layout

```text
packages/storage/lib/
├── storage.dart                 # barrel
└── src/
    ├── key_value_store.dart     # KeyValueStore interface
    ├── shared_preferences_store.dart  # namespaced store over shared_preferences
    ├── memory_store.dart        # in-memory store for tests
    ├── app_storage.dart         # AppStorage(client, server)
    └── register_storage.dart    # registerStorage(GetIt)

packages/api/lib/
├── domain/domain.dart           # barrel: entities, AuthRepository, sealed results
├── data/data.dart               # barrel: registerApiData, LocalLink, LocalServer, GraphqlAuthRepository
└── src/
    ├── domain/auth/             # Viewer, ViewerName, SignInResult, AuthRepository, ApiFault
    └── data/
        ├── graphql/             # schema.graphql, auth.graphql and their *.graphql.dart
        ├── link/                # LocalLink, Resolver, RequestContext
        ├── server/              # LocalServer, AuthResolvers, SessionStore
        └── repositories/        # GraphqlAuthRepository

modules/auth/lib/
├── auth.dart                    # barrel
└── src/
    ├── auth_keys.dart
    ├── register_auth_module.dart
    ├── session/                 # SessionBloc
    ├── sign_in/                 # SignInBloc, SignInPage
    └── account/                 # AccountPage
```

`storage` depends on `shared_preferences`, so it is a Flutter package. `api` depends on `storage`, so it is one too. Both fall under the existing Flutter Melos scripts, and no `--no-flutter` scripts are needed.

### Storage namespaces

`KeyValueStore` reads, writes and deletes strings by key. `SharedPreferencesStore` prefixes every key with its namespace: `client.` or `server.`. `AppStorage` holds one store per namespace. The client side of `packages/api` touches only `client`; the resolvers touch only `server`. `MemoryStore` implements the same interface for tests.

Alternative: `SharedPreferencesAsync`. Rejected for now, because the legacy API has `setMockInitialValues` for tests and one synchronous cache on every platform.

### Schema and result union

```graphql
type Viewer { id: ID!  name: String! }
type SignInSuccess { viewer: Viewer!  token: String! }
type InvalidName { minLength: Int! }
union SignInResult = SignInSuccess | InvalidName
type Query { viewer: Viewer }
type Mutation { signIn(name: String!): SignInResult! }
```

`InvalidName.minLength` tells the client the rule, so the message never drifts from the "server". The viewer id derives from the trimmed, lower-cased name, because the glossary identifies a viewer by name.

### LocalLink and the request context

The client's link chain is `AuthLink → LocalLink`. `AuthLink` comes from the `graphql` package. It reads the token from the client namespace and sets `Authorization: Bearer <token>` in the request context's `HttpLinkHeaders` entry, as it would for an `HttpLink`. `LocalLink` reads that header into a `RequestContext`, then routes the request by operation name to a `Resolver`. An unknown operation returns a GraphQL error.

Resolvers parse variables with the generated `Variables$…fromJson`, and build their responses with the generated response classes and `toJson()`. The response shape therefore always matches the operation. Maps stay inside `LocalLink` and the resolver adapters.

`LocalServer` keeps sessions as a JSON map from token to viewer name under one key in the `server` namespace. Tokens are 32 random hex bytes from `Random.secure()`.

Alternative: pass the token as an operation variable. Rejected by ADR-0011: no request may name its own viewer.

### Repository and failures

```dart
abstract interface class AuthRepository {
  Future<SignInResult> signIn(String name);
  Future<Viewer?> currentViewer();
  Future<void> signOut();
}

sealed class SignInResult;
final class SignedIn(Viewer viewer);
sealed class SignInFailure extends SignInResult;
final class InvalidName(int minLength);
final class SignInUnavailable;
```

`GraphqlAuthRepository` maps each union member to a domain class. A GraphQL exception maps to `SignInUnavailable`. On `SignedIn` it writes the token; on `InvalidName` it writes nothing. `currentViewer` returns `null` when no token is stored, and deletes a token the "server" does not recognise. It throws `ApiFault` on an unexpected fault. `signOut` deletes the token.

The `graphql` client uses `FetchPolicy.noCache`, so `viewer` always reflects the current token.

### Blocs

`SessionBloc` owns the app-wide session:
- States: `SessionChecking`, `SessionSignedIn(viewer)`, `SessionSignedOut`.
- `SessionCheckRequested` asks the repository for the viewer (`droppable`). An `ApiFault` reads as signed out.
- `ViewerSignedIn(viewer)` moves to signed in.
- `SignOutRequested` deletes the token and moves to signed out (`droppable`).

`SignInBloc` owns the form. One state class holds `name`, `status` (`editing`, `submitting`, `succeeded`), a `SignInError?` (`nameTooShort`, `unavailable`), `minLength` and the `viewer` after success.
- `SignInNameChanged` updates the name and clears the error.
- `SignInSubmitted` uses `droppable`. It checks `ViewerName.isValid` first and calls no repository when the name is too short. It then switches exhaustively on `SignInResult`.

`ViewerName.minLength` (4) sits in the domain. The resolver keeps its own copy of the rule, so the "server" check stays independent of the client.

The Sign in page listens to `SignInBloc` and adds `ViewerSignedIn` to `SessionBloc` on success. The router does the rest.

### Routing and the guard

```text
/sign-in                    SignInPage           outside the shell, public
StatefulShellRoute
├── /                       BagsPlaceholderPage  public
└── /account                AccountPage          guarded
errorBuilder                NotFoundPage
```

`authRedirect(session, uri)` is a pure function in the app:
- On `/sign-in`, a signed-in viewer goes to `from` when it is a local path (starts with `/`, not `//`), else to `/`.
- On a guarded path, a signed-out user goes to `/sign-in?from=<uri>`.
- Otherwise it returns `null`.

`GoRouter.refreshListenable` wraps `SessionBloc.stream` in a `ChangeNotifier`, so the redirect runs again on every session change.

`BagCheckoutApp` shows a `StateView.loading` until the first session check ends, then builds the router. The redirect therefore never sees `SessionChecking`, and a refresh on `/account` does not flash the Sign in page.

Sign out: the Account page adds `SignOutRequested` and calls `onSignOut`, which the app sets to `go('/')`. The Sign in page's back action calls `onBack`, also `go('/')`. Modules never know app routes.

### Dependency injection

- `registerStorage(GetIt)` (async) registers `AppStorage` over `SharedPreferences`.
- `registerApiData(GetIt)` registers `LocalServer`, the `GraphQLClient` and `AuthRepository` as `GraphqlAuthRepository`.
- `registerAuthModule(GetIt)` registers `SessionBloc` and `SignInBloc` as factories.
- `configureDependencies(GetIt)` in the app calls the three in order. It resets the locator first, so a second `main()` in one patrol process does not throw.

The app creates one `SessionBloc` in `BagCheckoutApp` and provides it with `BlocProvider.value`. The `/sign-in` route creates `SignInBloc` in `BlocProvider(create: …)`. Only the composition root, the app widget and route builders read get_it. Widget tests build the app with a fresh `GetIt.asNewInstance()` and a mocktail `AuthRepository`.

### Material re-export

`packages/ui` re-exports `package:material_ui/material_ui.dart` from its barrel. `modules/auth` imports `package:ui/ui.dart` and has no `material_ui` dependency, so a direct import fails to resolve (ADR-0002).

### AppTextField

`AppTextField` wraps `TextField` with a required `label`, an optional `errorText`, and `onChanged` and `onSubmitted` callbacks. `AppTheme` gains an `inputDecorationTheme`: `md` radius, `onSurfaceVariant` border, `primary` focused border, `error` border and error text. `DESIGN.md` gets the component row first.

### Generated code and tooling

- `packages/api/build.yaml` configures graphql_codegen for the `graphql` client and writes `*.graphql.dart` next to each source.
- Melos `codegen`: `melos exec -c 1 --depends-on=build_runner -- dart run build_runner build`.
- `analysis_options.yaml` excludes `**/*.graphql.dart` and `**/*.g.dart`.
- `format:check:lib` and `format:check:test` list files with `find` and skip the same two patterns, because `dart format` has no exclude flag.
- `tool/check_imports.dart` scans `modules/**/*.dart` for imports or exports of `package:api/data/` or `package:api/src/`, and for relative paths into `packages/api/lib/`. It prints `file:line` for each hit and exits 1. `melos run analyze` runs it after the Flutter analysis. CI `paths` gains `tool/**`.

### Keys and semantics

`AuthKeys` holds `signInName`, `signInSubmit`, `signInBack` and `signOut`. The field's label and the buttons' text give the semantic labels.

### Tests

- `packages/storage`: namespaces stay apart, read, write and delete, and values survive a new store over the same preferences.
- `packages/api`: resolvers (valid, trimmed, too short, viewer with and without a token), `LocalLink` (routing, unknown operation, every operation in the `.graphql` files has a resolver), and `GraphqlAuthRepository` end to end over `MemoryStore`.
- `modules/auth`: `bloc_test` for `SessionBloc` and `SignInBloc`, including `droppable` on submit, with mocktail mocks of `AuthRepository`. Widget tests for the inline error and the Account page.
- `packages/ui`: `AppTextField` label, error colour and semantics.
- `apps/web_checkout`: `authRedirect` cases, and router tests with a mocktail repository for the guard, the return to `from` and sign out.
- Patrol: a new sign-in journey, and the navigation journey updated for the guard.

## Risks / Trade-offs

- [`AuthLink` writes to `HttpLinkHeaders`, an HTTP type] → Accept it. It makes `LocalLink` read the token exactly as a real server would, and an `HttpLink` swap needs no change.
- [A stale generated file can pass CI] → ADR-0020 accepts this. Task 3.6 checks that `codegen` leaves no diff before commit.
- [Patrol may run both journeys in one process on some platforms] → `configureDependencies` resets get_it. Each journey clears preferences before `main()`.
- [The navigation journey now meets the guard] → It checks the sign-in redirect and returns to Bags through the back action. Its web-only resize and dark-mode checks stay on `/`.
- [`find`-based format check differs from the plain `dart format lib`] → It checks the same files minus generated ones. A test-run failure on purpose proves it still names a bad file.

## Found during implementation

- `graphql_codegen` 3.0.2 needs `build` 4, and `bloc_test` pulls in `test`, which caps the analyzer. The solver settles on build_runner 2.16.1, so `packages/api` pins `build_runner: ^2.16.1`.
- build_runner 2.16 removed `--delete-conflicting-outputs`, so the `codegen` script drops it.
- The text field border uses `onSurfaceVariant`. `outline` reads about 1.4:1 on cream, below the 3:1 a field edge needs. `DESIGN.md` and the `design-language` delta say so, and a contrast test checks it.
- The browser shows `/sign-in?from=/account`, not `%2Faccount`, because `/` is legal in a query. The `app-navigation` scenarios name the decoded `from` value.
- On web, patrol skips its fix for typing into the same field twice (flutter#134604). The sign-in journey types through `EditableTextState` on web only.
- `Bloc.close()` never completes when awaited inside a widget test's fake-async zone. Widget tests let a `BlocProvider` own the bloc, or close it in a plain `tearDown`.
- The user asked for mocktail mid-slice. Module and app tests mock `AuthRepository` with it. The api tests stay end to end over `MemoryStore`, with no mocks.

## Open for sign-off

- `packages/ui` re-exports all of `material_ui`, not a selected list. ADR-0002 allows "selected Material symbols". A `show` list can replace the full export later without touching modules that use only listed symbols.
- Sign out deletes the client token only. The "server" keeps the old session entry. A `signOut` mutation can revoke it in a later slice.
- The viewer id derives from the lower-cased name, so "Naledi" and "naledi" are the same viewer. Orders will hang off this id.
