# Design

## Context

The repo holds only docs, the prompt-log hook and OpenSpec. FVM 3.2.1, patrol_cli 4.9.0 and OpenSpec 2.0.0 are installed. Flutter 3.47.9 is a published FVM release but is not in the local cache yet.

Package versions on pub.dev as of 2026-11-14:

| Package | Version | Constraint |
|---|---|---|
| `material_ui` | 1.11.0 | Flutter >=3.47.0, Dart ^3.13.0 |
| `patrol` | 4.11.0 | Flutter >=3.32.0 |
| `melos` | 7.8.2 (pinned major 7; 8.10.1 exists) | Dart ^3.9.0 |

## Goals / Non-Goals

**Goals:**
- A workspace that later slices extend by adding a member and one line in the root `pubspec.yaml`.
- One app member that runs on Chrome, iOS and Android.
- Patrol proven end to end on Chrome with a smoke journey.

**Non-Goals:**
- No routing library yet. The placeholder screen is the app's `home`.
- No theme beyond the `material_ui` defaults.

## Decisions

### Workspace root

The root `pubspec.yaml` declares `workspace: [apps/web_checkout]`, the Dart SDK constraint of Flutter 3.47.9, `melos: ^7.8.2` as a dev dependency, and the `melos:` script block. The app's `pubspec.yaml` sets `resolution: workspace`.

Alternative: a standalone `melos.yaml`. Melos 7 reads config from the root `pubspec.yaml` in pub workspaces, so a second file adds nothing.

### Melos scripts

| Script | Runs |
|---|---|
| `analyze` | `flutter analyze` in every member |
| `format:check` | `dart format --set-exit-if-changed .` in every member |
| `test` | `flutter test` in every member with a `test` directory |

Scripts call `fvm flutter` and `fvm dart` so the pinned version runs even when a global Flutter exists. CI has no FVM, so it sets an env var that drops the `fvm` prefix. The exact mechanism is fixed during implementation.

### Analysis options

One root `analysis_options.yaml` holds the `flutter create` default (`include: package:flutter_lints/flutter.yaml`). Members carry no own file, so the analyzer finds the root file. The `simulated-auth` slice adds excludes for generated code.

### App creation

Run `fvm flutter create --platforms web,ios,android --org dev.mugikhan --project-name web_checkout apps/web_checkout`. `flutter create` builds the bundle id from org and project name, which gives `dev.mugikhan.web_checkout`. Set `dev.mugikhan.bagcheckout` by hand in the iOS project and the Android `applicationId` and `namespace`. Set the display name in `web/index.html`, `web/manifest.json`, iOS `Info.plist` and Android `AndroidManifest.xml`.

Alternative: `--project-name bagcheckout`. Rejected, because the Dart package name should match the directory.

### Material split

Add `material_ui` to the app and import it in place of `package:flutter/material.dart`. Follow the opt-in steps in the Flutter 3.47 migration guide. Record the exact steps in the README if they need anything beyond the dependency. Do not add `cupertino_ui`.

### Path URLs

Call `usePathUrlStrategy()` from `flutter_web_plugins` in `main`. go_router reads the same strategy, so the `design-system` slice adds routing without changing this call.

### Patrol

Add `patrol` as a dev dependency of the app and the `patrol:` config block in its `pubspec.yaml`. Put one smoke journey in `apps/web_checkout/patrol_test/` that launches the app and finds the title. Check `patrol` 4.11.0 against patrol_cli 4.9.0 in patrol's compatibility table. Upgrade the CLI only if the table demands it.

### CI

`.github/workflows/ci.yml` triggers on `pull_request` with `branches: [main]`. It installs Flutter from `.fvmrc` through `subosito/flutter-action` (`flutter-version-file`), activates Melos 7.8.2, runs `flutter pub get` at the root, then `melos run analyze` and `melos run test`.

## Risks / Trade-offs

- [The material split opt-in may need steps the guide leaves unclear] → Verify with `fvm flutter build web` and both mobile builds before closing the group.
- [patrol web support is newer than mobile] → The smoke journey proves it in this slice, before any feature depends on it.
- [CI runs without FVM] → `subosito/flutter-action` reads the same `.fvmrc`, so the version cannot drift.
- [The `fvm` prefix in scripts breaks in CI] → Handle it with the env var described above, and prove it on the first pull request to `main`.
