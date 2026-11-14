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

### Run patrol tests

```sh
cd apps/web_checkout
fvm exec patrol test --device chrome
```

Add `--web-headless` to run without a browser window. The first run installs Playwright.

## Docs

- [Architecture decisions](docs/adr/README.md)
- [Glossary](docs/GLOSSARY.md)
