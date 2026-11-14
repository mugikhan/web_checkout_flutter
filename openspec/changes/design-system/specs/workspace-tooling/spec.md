# Spec Delta

## ADDED Requirements

### Requirement: CI gate on pull requests into main
CI SHALL run workspace analysis and tests on every pull request that targets `main`, and on no other branch.

#### Scenario: Pull request to main
- **WHEN** a pull request targets `main`
- **THEN** CI runs `melos run analyze` and `melos run test` with the pinned Flutter version and reports the result on the pull request

#### Scenario: Stacked pull request
- **WHEN** a pull request targets another feature branch
- **THEN** CI does not run

## REMOVED Requirements

### Requirement: CI gate on pull requests to main
**Reason**: Its second scenario names the `develop` branch, which was removed (ADR-0019).
**Migration**: "CI gate on pull requests into main" keeps the same rule and replaces the `develop` scenario with one for stacked pull requests.
