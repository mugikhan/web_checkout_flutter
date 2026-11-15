# Spec Delta

## ADDED Requirements

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

## REMOVED Requirements

### Requirement: CI gate on pull requests to main
**Reason**: Its second scenario names the `develop` branch, which was removed (ADR-0019 (since folded into docs/ORACLE.md)).
**Migration**: "CI gate on pull requests into main" keeps the same rule and replaces the `develop` scenario with one for stacked pull requests.
