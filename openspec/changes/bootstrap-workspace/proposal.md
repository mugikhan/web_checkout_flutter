# Proposal

## Why

The repo has no Flutter code yet. Every later slice needs a pinned toolchain, a pub workspace, shared scripts and a running app on web, iOS and Android.

## What Changes

- Pin Flutter 3.47.9 with FVM in `.fvmrc` ([ADR-0001](../../../docs/adr/0001-pin-flutter-with-fvm.md)).
- Add the workspace root `pubspec.yaml` with Melos 7 scripts for analyze, format and test ([ADR-0003](../../../docs/adr/0003-pub-workspace.md), [ADR-0004](../../../docs/adr/0004-melos-task-runner.md)).
- Create `apps/web_checkout` for web, iOS and Android, opted in to the material/cupertino split with `material_ui` only ([ADR-0002](../../../docs/adr/0002-material-ui-split.md)).
- Show a placeholder home screen titled "Bag Checkout", with path URLs on web.
- Set the bundle id `dev.mugikhan.bagcheckout` and the display name "Bag Checkout" on every platform.
- Set up patrol with one smoke journey on Chrome ([ADR-0015](../../../docs/adr/0015-testing-strategy.md)).
- Add a GitHub Actions workflow that runs analyze and unit tests on pull requests to `main`.
- Add a minimal README section on running the app locally.

## Out of scope

- Every package and module: `ui`, `storage`, `api`, `auth`, `catalog`, `checkout`, `orders`. Each arrives with its slice.
- go_router, get_it, bloc and graphql_codegen. They arrive with the slices that use them.
- The codegen script and the import-boundary check. Both arrive with `packages/api` in `simulated-auth`.
- Theme, tokens and `DESIGN.md`. They arrive in `design-system`.
- Patrol in CI.

## Capabilities

### New Capabilities

- `workspace-tooling`: Developer commands that analyze, format and test every workspace member, and the CI gate on pull requests to `main`.
- `app-platforms`: The app builds and launches from one codebase on web, iOS and Android, with its name and bundle id.

### Modified Capabilities

None.

## Impact

- New files: `.fvmrc`, root `pubspec.yaml`, `analysis_options.yaml`, `apps/web_checkout/**`, `.github/workflows/ci.yml`, `README.md`.
- `.gitignore` gains FVM entries.
- New dependencies: `material_ui`, `melos` (dev), `patrol` (dev), `flutter_lints` (dev).
- Reviewers need FVM and Melos 7.8.2 installed.
