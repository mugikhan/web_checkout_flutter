# ADR-0017: Running and recording patrol tests

**Status:** Accepted  
**Date:** 2026-11-15  
**Deciders:** Mughees Khan

## Context

ADR-0015 calls for one patrol journey per slice, verified by the user before the next slice starts. Every run must use the pinned Flutter. A video of each journey gives the user evidence for sign-off and material for the demo.

## Decisions

### Running journeys

- Run journeys from `apps/web_checkout` with `fvm exec patrol test --device <device>`. `fvm exec` puts the pinned SDK first on PATH.
- Device ids:
  - Web: `chrome`. Add `--web-headless` to hide the browser.
  - Android: the emulator id from `adb devices`, for example `emulator-5554`.
  - iOS: the simulator UDID from `xcrun simctl list devices`.
- One journey file runs on every platform. Web-only checks sit behind `kIsWeb`.
- Android runs through `PatrolJUnitRunner` with the test orchestrator.
- iOS runs through the `RunnerUITests` target. It links `FlutterGeneratedPluginSwiftPackage`, because the project uses Swift Package Manager. Parallel testing is off in the `Runner` scheme.
- Web runs through Playwright and needs Node.js.

### Recording journeys

- Record with the run-patrol-test skill, installed at `.agents/skills/run-patrol-test` and linked from `.claude/skills`.
- Start it with `/run-patrol-test`, plus the test, device or platform in plain words. The skill never starts by itself.
- The skill plans the run and asks when a choice is ambiguous. It then gives you the command to run in your terminal. It runs the command itself only when you ask.
- Without an agent, plan and run from the repo root:
  ```sh
  fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart plan --test <name>
  fvm exec dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart run --test <name> --device <device>
  ```
- `.patrol-runner.json` sets `defaultProject` to `apps/web_checkout` and `flutterCommand` to `fvm flutter`.
- Recorders: Playwright on web, converted to MP4 when ffmpeg is installed. `patrol test --record-video` on Android and the iOS simulator.
- Videos land in `apps/web_checkout/patrol_test/recordings/`. Commit them; git does not ignore them.
- Record a journey only when it lasts long enough to show the app. The bootstrap smoke journey ends in under a second, so it has no video. Recording starts with `simulated-auth`.

### Project patch to the skill

The skill's scripts and printed command use plain `dart`. The global Dart is older than the workspace's language version and fails. The installed `SKILL.md` therefore carries a marked patch: script commands use `fvm dart`, and the printed command runs under `fvm exec`. A reinstall with `install.sh --force` drops the patch, so apply it again.

## Consequences

- One journey file and one command shape cover web, Android and iOS.
- Videos grow the repository with every recording. Move them to Git LFS if the size becomes a problem.
- Physical iOS devices are out: patrol needs extra signing setup, and the skill cannot record them.
- Patrol stays out of CI (ADR-0015), so recordings come from local runs.
