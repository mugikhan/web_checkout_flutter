# Tasks

## 1. DESIGN.md

- [x] 1.1 Write `DESIGN.md` at the repo root: source and pull date, light and dark colour tables (role, hex, reason for any change), DM Sans type scale, spacing, radius, elevation, motion, breakpoints, component rules and rules for agents; verify every hex matches the design.md colour-role table
- [x] 1.2 Link `DESIGN.md` from `AGENTS.md` and `openspec/config.yaml`, and verify both links resolve

## 2. Tokens and themes in packages/ui

- [x] 2.1 Create `packages/ui` as a workspace member with `material_ui` and `google_fonts`, and verify `fvm flutter pub get` resolves and `melos run analyze` includes it
- [x] 2.2 Add `AppColors` (light and dark), `AppSpacing`, `AppRadius` and `AppBreakpoints`, and verify a test parses the `DESIGN.md` colour tables and matches every row to `AppColors`
- [x] 2.3 Add `AppTheme.light` and `AppTheme.dark` with the colour roles, DM Sans text theme and `AppTokens` extension, and verify a test checks every `on*`/base pair in both schemes at 4.5:1 or more
- [x] 2.4 Add `WindowSizeClass.fromWidth`, and verify tests at 599, 600, 839 and 840

## 3. Atoms

- [x] 3.1 Add `AppButton` (primary, secondary, ghost, loading), and verify widget tests for each variant's colours in both themes and for taps ignored while loading
- [x] 3.2 Add `AppCard` and `StateView` (empty, error, loading, optional action), and verify widget tests render each state and fire the action
- [x] 3.3 Add `AdaptiveScaffold` with `AdaptiveDestination`, and verify widget tests show a bottom bar at 599px, an icon rail at 600px and 839px, and an extended rail with labels at 840px, each with semantic labels

## 4. Routing and pages

- [x] 4.1 Add `go_router` and `ui` to the app, build `buildRouter` with the Bags and Account shell branches and the not-found view, and switch `BagCheckoutApp` to `MaterialApp.router` with both themes and `ThemeMode.system`; verify `fvm flutter build web` succeeds
- [x] 4.2 Add `BagsPlaceholderPage`, `AccountPlaceholderPage`, `NotFoundPage` and `AppKeys`, and verify widget tests for `/`, `/account`, `/does-not-exist`, and "Go to Bags" returning to `/`
- [x] 4.3 Update `test/app_test.dart` for the new shell, and verify `melos run test` passes in both members

## 5. Patrol

- [x] 5.1 Replace the smoke journey with a navigation journey: Bags to Account and back, checking the URL on web; verify it passes on Chrome, the Android emulator and the iOS simulator
- [x] 5.2 On web, extend the journey to resize the window to 500, 700 and 1200px and to turn on dark mode, checking the layout and theme at each step; verify it passes on Chrome

## 6. Verification

Draft checks for the user to accept, change or replace:

- **Scripts**: `melos run analyze`, `melos run format:check` and `melos run test` all exit 0, with `packages/ui` included.
- **Patrol**: the navigation journey passes on Chrome, the Android emulator and the iOS simulator.
- **Design source**: the parity test and the contrast test pass, and `DESIGN.md` lists each contrast fix.
- **Web, manual**: at `/`, the cream background, forest text and DM Sans show. Account updates the URL to `/account`. Refresh on `/account` keeps Account. `/does-not-exist` shows "Page not found".
- **Web, manual**: dragging the window from narrow to wide switches bar → rail → extended rail and keeps the page.
- **Dark mode, manual**: switching the OS to dark mode switches the app live.
- **Mobile, manual**: iOS and Android show the bottom bar, both destinations work, and dark mode follows the device.

- [ ] 6.1 Run every automated check above and paste the output in the PR description
- [ ] 6.2 User verifies the slice

## Workflow follow-up

- Open a PR from `feat/design-system` to `develop` after the user signs off.
- Archive the change with `openspec archive design-system` after the merge.
