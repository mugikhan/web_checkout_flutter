# Bag Checkout

A web-first checkout slice in Flutter. It runs on web, iOS and Android from one codebase.

## Run locally

### Prerequisites

- [FVM](https://fvm.app). The repo pins Flutter 3.47.9 in `.fvmrc`.
- Melos 7.8.2: `dart pub global activate melos 7.8.2`.
- Node.js, for patrol tests on Chrome.
- [patrol_cli](https://pub.dev/packages/patrol_cli) 4.9.0 or later: `dart pub global activate patrol_cli`.
- Xcode and Android Studio, for the mobile targets.

### Set up

```sh
fvm install
fvm flutter pub get
```

### Run the app

```sh
cd apps/web_checkout
fvm flutter run -d chrome
```

Use `-d` with an iOS simulator or Android emulator id to run on mobile. `fvm flutter devices` lists them.

### Check the workspace

Run Melos through `fvm exec`, so it uses the pinned Flutter even when another version is on your PATH.

```sh
fvm exec melos run analyze
fvm exec melos run format:check
fvm exec melos run test
```

`analyze` also fails when a module imports `package:api/data/` or `package:api/src/` ([ADR-0005](docs/adr/0005-clean-architecture-in-api.md)).

### Regenerate GraphQL code

The generated `*.graphql.dart` files are committed ([ADR-0020](docs/adr/0020-commit-generated-code.md)). After you change a `.graphql` file in `packages/api`, run this and commit the output:

```sh
fvm exec melos run codegen
```

### Run patrol tests

```sh
cd apps/web_checkout
fvm exec patrol test --device chrome
```

This runs every journey in `patrol_test/`: `navigation_test.dart` and `sign_in_test.dart`. Add `--target patrol_test/sign_in_test.dart` to run one. Add `--web-headless` to run without a browser window. The first run installs Playwright.

For Android or iOS, pass the emulator id from `adb devices` or the simulator UDID from `xcrun simctl list devices` to `--device`.

### Record patrol tests

In Claude Code, run `/run-patrol-test` and name the test and device. Without an agent, run these from the repo root:

```sh
fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart plan --test sign_in_test.dart
fvm exec dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart run --test sign_in_test.dart --device chrome
```

Videos land in `apps/web_checkout/patrol_test/recordings/`. Commit them. [the oracle](docs/ORACLE.md) covers the details. Install ffmpeg to convert web videos to MP4.

## Docs

- [Architecture decisions](docs/adr/README.md)
- [Glossary](docs/GLOSSARY.md)
