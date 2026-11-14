# Spec Delta

## Purpose

Gives developers and CI one set of commands that check every workspace member with the pinned toolchain.

## ADDED Requirements

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

### Requirement: CI gate on pull requests to main
CI SHALL run workspace analysis and tests on every pull request that targets `main`, and on no other branch.

#### Scenario: Pull request to main
- **WHEN** a pull request targets `main`
- **THEN** CI runs `melos run analyze` and `melos run test` with the pinned Flutter version and reports the result on the pull request

#### Scenario: Pull request to develop
- **WHEN** a pull request targets `develop`
- **THEN** CI does not run
