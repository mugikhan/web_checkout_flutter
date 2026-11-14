# Brief: simulated-auth

Dispatched on 2026-11-15 to an Opus subagent at medium effort. The text below is the exact brief it received. Use it as the template for later slice briefs.

---

You are implementing one roadmap slice, `simulated-auth`, of a Flutter take-home assignment, from proposal through verification. You work alone; the user will only see your final report. Do the work end to end, then report back. If anything fails or blocks you, stop and report back instead of working around it.

# Repo and branch

- Repo: /Users/mugheesk/Documents/Personal/Repositories/web_checkout_flutter
- You are on branch `feat/simulated-auth`, cut from `main`. It already has one commit: ADR-0020. Stay on this branch. Commit in small logical steps with Conventional Commits. Do NOT push, open PRs, merge, or archive the OpenSpec change. Do NOT start the next roadmap slice.

# Read first (required)

- `AGENTS.md`: prose and code-comment rules. Follow them strictly. Default to no comments; doc comments start with the identifier name, one line.
- `openspec/config.yaml`: project context, workspace rules, roadmap.
- `DESIGN.md`: design rules. Use `packages/ui` tokens and widgets; never raw colours, text styles, EdgeInsets values or radii in apps or modules.
- `docs/GLOSSARY.md`: domain terms.
- ADRs in `docs/adr/`, especially 0003 (workspace layering), 0005 (clean architecture in packages/api, domain and data barrels), 0006 (graphql_codegen + LocalLink), 0007 (typed result unions), 0008 (bloc + bloc_concurrency), 0009 (go_router), 0011 (simulated auth through GraphQL signIn and request context), 0012 (plain get_it with per-module registration), 0015 and 0017 (patrol), 0018 (unknown URLs), 0019 (branch to main), 0020 (commit generated code).
- `openspec/specs/` (current main specs) and the archived changes in `openspec/changes/archive/` as examples of the expected artifact quality and task/verification format.
- Current code: `packages/ui`, `apps/web_checkout` (router in `lib/router/`, shell, placeholder pages, `AppKeys`, patrol journey in `patrol_test/navigation_test.dart`), root `pubspec.yaml` (workspace + Melos scripts), `analysis_options.yaml`, `.github/workflows/ci.yml`.

# Settled decisions for this slice (do not re-decide)

1. Packages added in this slice: `packages/storage` (key-value persistence over shared_preferences, with separate client and "server" namespaces) and `packages/api` (clean architecture per ADR-0005: `lib/domain/domain.dart` barrel with entities, repository interfaces, sealed failures; `lib/data/data.dart` barrel with GraphQL client, LocalLink, local server/resolvers, repository implementations). Module added: `modules/auth` (blocs and pages only).
2. GraphQL: `schema.graphql` and `.graphql` operations live in `packages/api`; graphql_codegen + build_runner generate typed code for the `graphql` package client. A custom `LocalLink` routes each request by operation name to typed resolvers. JSON maps stay inside `packages/api` data layer only.
3. Auth (ADR-0011): `signIn(name)` mutation returns a Viewer and a token; a `viewer` query returns the signed-in viewer. The name is trimmed and must be MORE THAN 3 characters (4+). Validate on the client (form shows an inline error) AND on the "server" resolver. Expected failures are typed GraphQL result unions (ADR-0007), e.g. `union SignInResult = SignInSuccess | InvalidName`, mapped by the repository to sealed domain failures; blocs use exhaustive switch. The client stores the token in storage's client namespace; LocalLink reads it from the request context like an Authorization header. Sign out deletes the token. `AuthRepository` interface in api domain, implementation in api data. Session survives browser refresh.
4. Generated code is COMMITTED (ADR-0020). Add a Melos `codegen` script that runs build_runner in packages that depend on it. Exclude generated files (`**/*.graphql.dart`, `**/*.g.dart`) from the analyzer and from the format check. CI must NOT run build_runner.
5. Import boundary (ADR-0005): add a check, run as part of `melos run analyze` (or a script it calls), that fails if any `modules/**` file imports `package:api/data/...` or any `package:api/src/...`.
6. Routing: guard `/account`. A signed-out user opening `/account` goes to `/sign-in?from=/account` and returns there after sign-in. `/sign-in` sits outside the nav shell. A signed-in user opening `/sign-in` goes to `from` (or `/`). Bags (`/`) stays public. The Account page (from `modules/auth`, replacing `AccountPlaceholderPage`) shows the signed-in name and a Sign out action; sign out returns the user to `/` (or re-triggers the guard). Use go_router `redirect` with a `refreshListenable` driven by auth state. Unknown URLs keep showing the not-found view (ADR-0018).
7. DI (ADR-0012): plain get_it. Each module/package exports a registration function; the app's composition root registers data implementations from `package:api/data/data.dart` and calls module registration. Blocs get dependencies via `BlocProvider(create: ...)` at route/app level; widgets never call the service locator directly.
8. State (ADR-0008): bloc with bloc_concurrency. Sign-in submit uses `droppable`. Add `bloc_test` tests for every bloc.
9. UI: add an `AppTextField` atom to `packages/ui` (DESIGN.md first, then code, same change). Every interactive widget gets a key (constants per module, e.g. `AuthKeys`) and a semantic label.
10. Melos rules: put package filters on `melos exec` flags (`--flutter`, `--dir-exists`), never script-level `packageFilters` (they prompt and crash without a terminal). Keep `-c 1` on Flutter analyze/test. If `packages/storage` or `packages/api` are pure Dart (no Flutter), add matching `dart analyze`/`dart test` scripts with `--no-flutter`; otherwise they fall under the existing Flutter scripts. Make sure the CI `paths` filter in `.github/workflows/ci.yml` still covers every new directory (it already covers apps/, packages/, modules/).
11. New workspace members must be added to the root `pubspec.yaml` workspace list. Use path dependencies between members, as `apps/web_checkout` does for `ui`.

If you hit a decision that is genuinely foundational and not covered above or by the ADRs, do not decide it silently: pick the least committal option that unblocks you only if it is trivially reversible, record it in the change's design.md under an "Open for sign-off" heading, and call it out in your report. If it is not reversible, stop and report back.

# Workflow

1. Propose: create the OpenSpec change `simulated-auth` (`openspec new change simulated-auth`, then `openspec instructions <artifact> --change simulated-auth --json` for each artifact: proposal, specs, design, tasks). Follow the instructions and templates, and the rules in `openspec/config.yaml`. New capabilities likely `user-session` (sign-in, session persistence, sign-out) and changes to `app-navigation` (guarded Account route, sign-in route). Modifying an existing requirement: a MODIFIED block must carry every existing scenario; to drop a scenario use REMOVED + ADDED. Also: the `workspace-tooling` spec still describes the bootstrap "smoke journey", replaced by the navigation journey; fix that drift with a delta in this change. Run `openspec validate simulated-auth --strict` until it passes. Commit the proposal.
2. Implement every task in tasks.md in order, marking each `- [ ]` -> `- [x]` only when fully done and verified. Commit as you go.
3. Verify. Verification for this slice = the slice works as expected PLUS an error case. Concretely:
   - `fvm exec melos run analyze`, `fvm exec melos run format:check`, `fvm exec melos run test` all exit 0 (prove the import-boundary check fails on a deliberate bad import, then revert).
   - A patrol journey that covers: open `/account` signed out -> redirected to sign-in; submit a too-short name (3 chars) -> inline error, no sign-in (the error case); submit a valid name -> lands back on Account showing the name; sign out -> back to signed-out state. On web also check URLs (`/sign-in?from=%2Faccount` or equivalent, then `/account`). Keep the existing navigation journey passing.
   - Run the journeys on Chrome, the Android emulator and the iOS simulator.
   - Record the auth journey with the run-patrol-test skill on all three platforms and commit the videos under `apps/web_checkout/patrol_test/recordings/`. Extract frames (ffmpeg) and look at them to confirm each video shows the sign-in error, the signed-in Account page and sign-out. Journeys under ~1s film nothing; if a mobile clip misses a screen, report it rather than adding artificial waits.
4. Leave the final tasks ("paste output in PR description" and "User verifies the slice") unchecked for the main session.

# Environment facts (verified)

- Flutter 3.47.9 via FVM. Run every flutter/dart command through `fvm` (`fvm flutter ...`, `fvm dart ...`). The global Dart is 3.10 and fails on this workspace.
- Melos 7.8.2: run as `fvm exec melos run <script>` (plain `melos` uses the wrong Flutter).
- Patrol: run from `apps/web_checkout` as `fvm exec patrol test --device <id>` (add `--web-headless` for Chrome). Devices: `chrome`, Android emulator `emulator-5554` (Pixel 10 Pro AVD, boot with `~/Library/Android/sdk/emulator/emulator -avd Pixel_10_Pro -no-snapshot-save -no-boot-anim &` if `adb devices` shows none), iOS simulator `A6427AE9-F4D1-423F-AB20-16AC259F4452` (iPhone 18 Pro, `xcrun simctl boot <udid>` if shut down).
- Recording skill, run from repo root:
  `fvm exec dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart run --project apps/web_checkout --test <file>.dart --device <id> --platform <web|android|ios>`
  It prints `RESULT=` and `RECORDING=<path>` lines; videos land in `apps/web_checkout/patrol_test/recordings/`.
- In this shell (zsh), unquoted `$var` does not word-split; use `bash -c` for loops that rely on splitting. Quote globs passed to grep `--include`.
- Widget tests must not let google_fonts fetch: `AppTheme.light/dark` and `BagCheckoutApp` accept a plain `textTheme` for tests (see existing `test/support/`). Keep that pattern.
- shared_preferences in widget/unit tests: use `SharedPreferences.setMockInitialValues` or an in-memory fake behind the storage interface.
- One patrolTest per file calls `app.main()`; calling `usePathUrlStrategy()` twice in one run is unsafe, so keep each journey file to one `app.main()` call. Make journeys independent of leftover state (patrol on Android clears package data; on web/iOS sign out or clear storage at the start if needed).
- `**/build/` and patrol's `**/test_bundle.dart` are already ignored/excluded. Check `git status` before each commit for stray generated or build output.

# Report back (your final message)

Keep it concise and factual:
- Outcome: completed, or stopped (with the exact failing command/output and what you tried).
- OpenSpec: change name, capabilities added/modified, `openspec validate --strict` result, task progress N/M.
- What was built: packages/modules/files added, key design choices, anything recorded under "Open for sign-off".
- Verification: exact results of analyze/format/test (test counts per package), boundary-check proof, patrol results per platform, recording file paths and what the frames show (including the error case).
- Commits: `git log --oneline main..HEAD`.
- Anything the main session must know before sign-off (deviations, risks, follow-ups).
