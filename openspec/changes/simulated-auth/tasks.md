# Tasks

## 1. Tooling for generated code and the import boundary

- [x] 1.1 Exclude `**/*.graphql.dart` and `**/*.g.dart` in `analysis_options.yaml`, and make `format:check:lib` and `format:check:test` skip them; verify `melos run format:check` still exits 0 and fails on a deliberately unformatted file
- [x] 1.2 Add `tool/check_imports.dart` and run it from `melos run analyze`; add `tool/**` to the CI `paths`; verify it exits 0 with no `modules/` directory
- [x] 1.3 Add the Melos `codegen` script with `--depends-on=build_runner`, and verify `melos run codegen` runs without a prompt

## 2. packages/storage

- [x] 2.1 Create `packages/storage` as a workspace member with `shared_preferences` and `get_it`, and verify `fvm flutter pub get` resolves and `melos run analyze` includes it
- [x] 2.2 Add `KeyValueStore`, `SharedPreferencesStore`, `MemoryStore`, `AppStorage` and `registerStorage`, and verify tests for namespaces, read, write, delete and persistence across store instances

## 3. packages/api

- [x] 3.1 Create `packages/api` as a workspace member with `storage`, `graphql`, `get_it`, `graphql_codegen` and `build_runner`, and verify it resolves
- [x] 3.2 Add the domain layer (`Viewer`, `ViewerName`, `SignInResult`, `AuthRepository`, `ApiFault`) behind `lib/domain/domain.dart`, and verify tests for `ViewerName.isValid` at 3 and 4 trimmed characters
- [x] 3.3 Add `schema.graphql`, `auth.graphql` and `build.yaml`, run `melos run codegen`, and verify the generated `*.graphql.dart` files compile under `melos run analyze`
- [x] 3.4 Add `LocalLink`, `RequestContext`, `LocalServer` and the auth resolvers, and verify tests for routing, an unknown operation, every operation having a resolver, and the name rule on the "server"
- [x] 3.5 Add `GraphqlAuthRepository` and `registerApiData` behind `lib/data/data.dart`, and verify end-to-end tests over `MemoryStore`: sign in stores the token, `currentViewer` reads it, a stale token is deleted, sign out deletes it, and an invalid name stores nothing
- [x] 3.6 Run `melos run codegen` again and verify `git status` shows no change to generated files

## 4. AppTextField

- [x] 4.1 Add the `AppTextField` row to `DESIGN.md`, then the atom and `inputDecorationTheme` in `packages/ui`; verify widget tests for the label, the error text and border in the `error` colour in both themes, and the semantics
- [x] 4.2 Re-export `material_ui` from `package:ui/ui.dart`, and verify `melos run analyze` passes

## 5. modules/auth

- [ ] 5.1 Create `modules/auth` as a workspace member with `ui`, `api`, `bloc`, `flutter_bloc`, `bloc_concurrency` and `get_it`, and verify it resolves with no `material_ui` dependency
- [ ] 5.2 Add `SessionBloc`, and verify `bloc_test` cases: a stored viewer restores, no viewer and `ApiFault` read as signed out, `ViewerSignedIn`, and sign out deleting the token
- [ ] 5.3 Add `SignInBloc` with `droppable` submit, and verify `bloc_test` cases: name too short sends nothing, spaces trim, success, the "server" invalid name, unavailable, the error clearing on edit, and a double submit calling the repository once
- [ ] 5.4 Add `AuthKeys`, `SignInPage`, `AccountPage` and `registerAuthModule`, and verify widget tests for the inline error, the submit, the back action and the Account name and Sign out action
- [ ] 5.5 Add a module that imports `package:api/data/data.dart` on purpose, verify `melos run analyze` fails and names the file, then revert

## 6. App wiring

- [ ] 6.1 Add `configureDependencies` and make `main` async; depend on `storage`, `api`, `auth`, `flutter_bloc` and `get_it`; verify `fvm flutter build web` succeeds
- [ ] 6.2 Add `authRedirect`, the `/sign-in` route, the session-driven `refreshListenable` and the loading gate; replace `AccountPlaceholderPage` with `AccountPage`; verify unit tests for every `authRedirect` case
- [ ] 6.3 Update the router and app widget tests with a fake `AuthRepository`, and verify tests for the guard, the return to `from`, a signed-in viewer on `/sign-in`, sign out to `/` and the unknown URL

## 7. Patrol

- [ ] 7.1 Update the navigation journey for the guard: Account redirects to sign-in, the back action returns to Bags; verify it passes on Chrome, the Android emulator and the iOS simulator
- [ ] 7.2 Add the sign-in journey: Account signed out, a 3-character name shows the error, a valid name lands on Account, sign out returns to Bags; check URLs on web; verify it passes on all three platforms
- [ ] 7.3 Update `README.md` for `melos run codegen` and the journey names, and verify the documented commands run as written

## 8. Verification

Sign-off: a patrol recording of the sign-in journey on web, Android and iOS. Each shows the inline name error, the signed-in Account page and sign out. The checks below support it.

- **Scripts**: `melos run analyze`, `melos run format:check` and `melos run test` all exit 0, with `storage`, `api` and `auth` included.
- **Boundary**: a deliberate `package:api/data/data.dart` import in `modules/auth` fails `melos run analyze`.
- **Codegen**: `melos run codegen` leaves no diff.
- **Bloc tests**: `SessionBloc` and `SignInBloc` cover every event, every result member and `droppable` submit.
- **Patrol, sign-in journey**: Account signed out goes to `/sign-in?from=%2Faccount`. "Bob" shows "Enter at least 4 characters". "Naledi" lands on `/account` with the name. Sign out returns to `/` signed out.
- **Patrol, navigation journey**: still passes on all three platforms.
- **Web, manual**: sign in, refresh on `/account`, and the name still shows. Sign out, refresh, and Account still asks for sign-in.
- **Web, manual**: `/sign-in?from=https://example.com` returns to `/` after sign-in.

- [ ] 8.1 Record the sign-in journey with the run-patrol-test skill on web, Android and iOS, check frames from each video for the error, the Account page and sign out, and commit the videos under `apps/web_checkout/patrol_test/recordings/`
- [ ] 8.2 Run every automated check above and paste the output in the PR description
- [ ] 8.3 User verifies the slice

## Workflow follow-up

- Open a PR from `feat/simulated-auth` to `main` after the user signs off (ADR-0019).
- Archive the change with `openspec archive simulated-auth` after the merge.
