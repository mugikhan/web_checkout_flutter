# Spec Delta

## MODIFIED Requirements

### Requirement: Patrol journeys on every target platform
The same patrol journeys SHALL run on Chrome, an Android emulator and an iOS simulator.

#### Scenario: Run on each platform
- **WHEN** a developer runs the navigation and sign-in journeys on Chrome, an Android emulator or an iOS simulator
- **THEN** the journeys pass on each of them

### Requirement: Recorded patrol runs
A developer SHALL be able to record a video of a patrol run, and the video SHALL be kept in the repository.

#### Scenario: Record a run
- **WHEN** a developer records the sign-in journey with the run-patrol-test skill on any target platform
- **THEN** a video file appears in `apps/web_checkout/patrol_test/recordings/`

#### Scenario: Videos are tracked
- **WHEN** a recording exists in `apps/web_checkout/patrol_test/recordings/`
- **THEN** git shows it as a file to commit, not an ignored file

## ADDED Requirements

### Requirement: Committed generated code
One command SHALL regenerate the typed GraphQL code in every member that uses code generation. The generated files SHALL be committed, and analysis and the format check SHALL skip them.

#### Scenario: Regenerate after a schema change
- **WHEN** a developer changes a `.graphql` file and runs `melos run codegen`
- **THEN** the matching generated Dart files update, ready to commit

#### Scenario: Fresh checkout
- **WHEN** a developer runs `melos run analyze` and `melos run test` on a fresh checkout without running codegen
- **THEN** both commands exit with code 0

#### Scenario: Generated files skip the checks
- **WHEN** a generated file differs from `dart format` output or has analyzer hints
- **THEN** `melos run analyze` and `melos run format:check` still exit with code 0

### Requirement: Import boundary check
`melos run analyze` SHALL fail when a file under `modules/` imports the api data layer or any api `src/` file.

#### Scenario: Module imports the data barrel
- **WHEN** a file under `modules/` imports `package:api/data/data.dart`
- **THEN** `melos run analyze` exits with a non-zero code and names the file and line

#### Scenario: Module imports a src file
- **WHEN** a file under `modules/` imports a `package:api/src/` path
- **THEN** `melos run analyze` exits with a non-zero code and names the file and line

#### Scenario: Module imports the domain barrel
- **WHEN** modules import only `package:api/domain/domain.dart` from api
- **THEN** the boundary check passes
