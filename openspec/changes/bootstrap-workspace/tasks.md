# Tasks

## 1. Toolchain and workspace root

- [x] 1.1 Create branch `feat/bootstrap-workspace` off `develop` and verify with `git branch --show-current`
- [x] 1.2 Run `fvm install 3.47.9` and `fvm use 3.47.9`, add `.fvm/` to `.gitignore`, and verify `fvm flutter --version` reports 3.47.9
- [x] 1.3 Add the root `pubspec.yaml` with the workspace block, SDK constraint and `melos: ^7.8.2`, and verify `fvm dart pub get` succeeds at the root
- [x] 1.4 Add the root `analysis_options.yaml` with the `flutter create` default, and verify `fvm dart analyze` finds no issues

## 2. App member

- [x] 2.1 Create `apps/web_checkout` for web, iOS and Android, add it to the workspace, and verify `fvm flutter pub get` resolves one lockfile at the root
- [x] 2.2 Opt in to the material split: add `material_ui`, replace every `package:flutter/material.dart` import, and verify `grep -r "flutter/material.dart" apps/` returns nothing
- [x] 2.3 Replace the counter app with a placeholder home screen titled "Bag Checkout", and replace the default widget test with one that finds the title; verify `fvm flutter test` passes
- [ ] 2.4 Call `usePathUrlStrategy()` in `main`, and verify the Chrome address bar shows `/` with no `#`
- [x] 2.5 Set the display name "Bag Checkout" and bundle id `dev.mugikhan.bagcheckout` on web, iOS and Android, and verify with `grep` across the platform files
- [ ] 2.6 Verify `fvm flutter build web`, `fvm flutter build ios --simulator --no-codesign` and `fvm flutter build apk --debug` all succeed

## 3. Melos scripts

- [ ] 3.1 Add the `analyze`, `format:check` and `test` scripts to the root `pubspec.yaml`, and verify each one exits 0
- [ ] 3.2 Break formatting in one file on purpose, verify `melos run format:check` fails and names it, then revert

## 4. Patrol

- [ ] 4.1 Check `patrol` 4.11.0 against patrol_cli 4.9.0 in patrol's compatibility table, and record the result in design.md
- [ ] 4.2 Add `patrol` and its config to the app, write the smoke journey in `patrol_test/`, and verify `patrol test --device chrome` passes

## 5. CI and docs

- [ ] 5.1 Add `.github/workflows/ci.yml` triggered only on pull requests to `main`, and verify the YAML with `actionlint` or a dry review
- [ ] 5.2 Add a "Run locally" section to `README.md` covering FVM, Melos 7.8.2, `melos run` scripts and `patrol test`, and verify each documented command runs as written

## 6. Verification

Draft checks for the user to accept, change or replace:

- **Toolchain**: `fvm flutter --version` shows 3.47.9.
- **Scripts**: `melos run analyze`, `melos run format:check` and `melos run test` all exit 0.
- **Patrol**: `patrol test --device chrome` passes the smoke journey.
- **Web, manual**: `fvm flutter run -d chrome` shows "Bag Checkout" at `/`, the tab title reads "Bag Checkout", and a refresh reloads the same screen.
- **Mobile, manual**: the app launches on an iOS simulator and an Android emulator with the launcher name "Bag Checkout".
- **Scope**: no `packages/` or `modules/` directory exists, and `grep -r "flutter/material.dart" apps/` returns nothing.
- **CI**: the workflow triggers only on pull requests to `main`. Its first real run happens on the first release PR.

- [ ] 6.1 Run every automated check above and paste the output in the PR description
- [ ] 6.2 User verifies the slice

## Workflow follow-up

- Open a PR from `feat/bootstrap-workspace` to `develop` after the user signs off.
- Archive the change with `openspec archive bootstrap-workspace` after the merge.
