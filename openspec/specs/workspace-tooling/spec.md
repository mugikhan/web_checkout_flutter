# workspace-tooling Specification

## Purpose
Gives developers and CI one set of commands that check every workspace member with the pinned toolchain.

## Requirements

### Requirement: Pinned toolchain
The repository SHALL pin one Flutter version, and every documented command SHALL run with that version.

#### Scenario: Developer uses the pinned version
- **WHEN** a developer runs `fvm flutter --version` at the repo root
- **THEN** the output reports Flutter 3.47.9

### Requirement: Workspace-wide analysis
One command SHALL run static analysis on every workspace member and fail when any member has an issue.

#### Scenario: Clean workspace
- **WHEN** a developer runs `melos run analyze` on a clean checkout
- **THEN** the command exits with code 0

#### Scenario: Analysis issue in a member
- **WHEN** any member contains an analyzer warning or error
- **THEN** `melos run analyze` exits with a non-zero code and names the file

### Requirement: Workspace-wide tests
One command SHALL run the unit and widget tests of every member that has a `test` directory.

#### Scenario: All tests pass
- **WHEN** a developer runs `melos run test` and every test passes
- **THEN** the command exits with code 0

#### Scenario: A test fails
- **WHEN** any member has a failing test
- **THEN** `melos run test` exits with a non-zero code

### Requirement: Workspace-wide formatting
One command SHALL report unformatted Dart files in every member.

#### Scenario: Unformatted file
- **WHEN** a member contains a Dart file that `dart format` would change
- **THEN** `melos run format:check` exits with a non-zero code and names the file

### Requirement: Patrol journeys on every target platform
The same patrol journeys SHALL run on Chrome, an Android emulator and an iOS simulator.

#### Scenario: Run on each platform
- **WHEN** a developer runs the smoke journey on Chrome, an Android emulator or an iOS simulator
- **THEN** the journey passes on each of them

### Requirement: Recorded patrol runs
A developer SHALL be able to record a video of a patrol run, and the video SHALL be kept in the repository.

#### Scenario: Record a run
- **WHEN** a developer records the smoke journey with the run-patrol-test skill on any target platform
- **THEN** a video file appears in `apps/web_checkout/patrol_test/recordings/`

#### Scenario: Videos are tracked
- **WHEN** a recording exists in `apps/web_checkout/patrol_test/recordings/`
- **THEN** git shows it as a file to commit, not an ignored file

### Requirement: CI gate on pull requests into main
CI SHALL run workspace analysis and tests on pull requests that target `main` and change code, tooling or design tokens. It SHALL NOT run on any other branch.

#### Scenario: Pull request to main
- **WHEN** a pull request targets `main` and changes a file under `apps/`, `packages/` or `modules/`, a root pubspec, `analysis_options.yaml`, `.fvmrc`, `DESIGN.md` or the CI workflow
- **THEN** CI runs `melos run analyze` and `melos run test` with the pinned Flutter version and reports the result on the pull request

#### Scenario: Docs-only pull request
- **WHEN** a pull request targets `main` and changes only docs, ADRs, OpenSpec files or agent skills
- **THEN** CI does not run, and nothing blocks the merge

#### Scenario: Stacked pull request
- **WHEN** a pull request targets another feature branch
- **THEN** CI does not run
