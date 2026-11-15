# Bag Checkout

A web-first checkout slice in Flutter. It runs on web, iOS and Android from one codebase.

## Demo

[Download the demo video](https://github.com/mugikhan/web_checkout_flutter/raw/main/demo_video_web.mp4) (14 min, web, 89 MB). GitHub serves it as a download; any browser or video player plays the saved file.

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

### Try it

- Sign in with any name of 4 or more characters. No password.
- Pick up to 2 bags, then Continue to checkout. Pick a collection window and a card.
- "Visa •••• 4242" confirms the order 3 seconds after you place it. "Mastercard •••• 0002" declines it.
- Data lives in an in-app "server" in browser or device storage. Clear site data to start fresh.
- To see the bad-link handling, open `/?bags=bag_cafe,bag_cafe,bag_unknown`.

### Check the workspace

Run Melos through `fvm exec`, so it uses the pinned Flutter even when another version is on your PATH.

```sh
fvm exec melos run analyze
fvm exec melos run format:check
fvm exec melos run test
```

`analyze` also fails when a module imports `package:api/data/` or `package:api/src/` ([ADR-0003](docs/adr/0003-clean-architecture-in-api.md)).

### Regenerate GraphQL code

The generated `*.graphql.dart` files are committed ([ADR-0013](docs/adr/0013-commit-generated-code.md)). After you change a `.graphql` file in `packages/api`, run this and commit the output:

```sh
fvm exec melos run codegen
```

### Run patrol tests

```sh
cd apps/web_checkout
fvm exec patrol test --device chrome
```

This runs every journey in `patrol_test/`: navigation, sign-in, catalog, checkout and order. Add `--target patrol_test/order_test.dart` to run one. Add `--web-headless` to run without a browser window. The first run installs Playwright.

For Android or iOS, pass the emulator id from `adb devices` or the simulator UDID from `xcrun simctl list devices` to `--device`.

### Record patrol tests

In Claude Code, run `/run-patrol-test` and name the test and device. Without an agent, run these from the repo root:

```sh
fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart plan --test sign_in_test.dart
fvm exec dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart run --test sign_in_test.dart --device chrome
```

Videos land in `apps/web_checkout/patrol_test/recordings/`. Commit them. [the oracle](docs/ORACLE.md) covers the details. Install ffmpeg to convert web videos to MP4.

## Docs

- [SOLUTION.md](SOLUTION.md): design, trade-offs and AI usage
- [Architecture decisions](docs/adr/README.md)
- [Oracle](docs/ORACLE.md): every product and process decision
- [Specs](openspec/specs/): current behaviour, one folder per capability
- [Design language](DESIGN.md) and [glossary](docs/GLOSSARY.md)
- [Assignment brief](docs/assignment-brief.pdf)
