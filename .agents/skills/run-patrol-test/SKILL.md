---
name: run-patrol-test
description: Run a Patrol integration test and record a video of it, on an Android device, an iOS simulator, or the web. A bundled script plans the run, picks the recorder from the installed Patrol CLI version, and prints the exact command. Use when asked to run Patrol tests, run integration tests, record a test run, or check Patrol test output.
disable-model-invocation: true
---

# Run a Patrol test with a video

Follow these steps in order. Do not skip a step. Do not add steps.

The script makes every decision that has one right answer. You decide only
when the script prints `PLAN_STATUS=ask`, and then the user decides, not you.

All commands run from the repository root. The script is
`.agents/skills/run-patrol-test/scripts/run_patrol_test.dart`.

> **Project patch (see docs/ORACLE.md):** this repo pins Dart through FVM, and the global
> `dart` is too old for the workspace. Run every script command with
> `fvm dart`, and put `fvm exec ` in front of the `COMMAND=` value. A
> reinstall with `--force` drops this patch, so add it again.

## Step 1 — Build the request

Map the user's words to flags. Add a flag only when the user said it. Leave
out everything else: the script fills the gaps or asks.

| The user says | Flag |
| ------------- | ---- |
| An app, package or folder | `--project <path>` |
| A test name or file | `--test <name-or-path>` |
| A device, emulator or simulator | `--device <id-or-name>` |
| "Android", "iOS" or "web" | `--platform android`, `ios` or `web` |
| "Without video" or "no recording" | `--no-record` |
| A flavor, dart-define or other Patrol option | after `--`, for example `-- --flavor dev` |

## Step 2 — Plan the run

```bash
fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart plan <flags from Step 1>
```

Read the `PLAN_STATUS=` line and do exactly one of these:

| `PLAN_STATUS` | Action |
| ------------- | ------ |
| `ask` | Go to Step 3. |
| `blocked` | Tell the user the `REASON=` line word for word. Stop. |
| `ready` | Go to Step 4. |

If the command itself fails (no `PLAN_STATUS=` line), show the user the error
and stop. The shell probably cannot reach `dart`, `adb` or `xcrun`.

## Step 3 — Ask the one question

The output has one `QUESTION=`, one `ASK_FLAG=` and one or more `OPTION=`
lines. Each option reads `OPTION=<value> :: <label>`.

1. Ask the user the `QUESTION=` text. Offer each label as a choice. If there
   are more than 4 options, list them all in your message and ask the user to
   name one.
2. Show a `HINT=` line, if there is one, under the question.
3. Never choose for the user, even when one option looks likely.
4. Add `<ASK_FLAG> <value>` for the chosen option to the flags.
5. Go back to Step 2.

## Step 4 — Hand the run to the user

1. Tell the user every `WARNING=` line, if there are any.
2. Tell the user the `RECORDER=` and `RECORDER_REASON=` lines.
3. If the user asked you to run the test yourself, go to Step 5.
4. Otherwise, give the user `fvm exec ` plus the `COMMAND=` value, in a `bash` code
   block. Say: "Run this in your terminal, then paste the lines from `RESULT=`
   to the end."
5. Stop. Wait for the pasted output, then go to Step 6.

The user's terminal is the default because a Patrol run takes 1 to 15 minutes
and needs device access and warm build caches. Agent shells often have none of
these.

## Step 5 — Run it yourself (only when the user asked)

1. Run `fvm exec ` plus the `COMMAND=` value, in the background, with the shell
   sandbox off.
2. Wait for a line that starts with `RESULT=`.
3. If the output stops changing for 10 minutes, stop the command. Then do
   Step 4, items 4 and 5.

## Step 6 — Report the result

Read the block that starts with `RESULT=` and report these lines:

| Line | Report |
| ---- | ------ |
| `RESULT=` | Passed or failed |
| `Test summary:` block | The pass and fail counts |
| `RECORDING=` (one per video) | Each video path |
| `REPORT=` | The HTML report path |
| `RECORDING_MISSING=` | No video was saved; give the path to check |
| `PATROL_LOG=`, `WEB_RESULTS_DIR=` | Logs kept for a failed run |

Then match the output to this table. Say the matching action. If nothing
matches, report the last 20 lines before `RESULT=` and stop.

| Output contains | Action to tell the user |
| --------------- | ----------------------- |
| `401`, `Unauthorized`, or `API key` | A test secret is missing or expired. Ask the user to update it (often in `.patrol.env` or a `--dart-define`). Never read or print a `.env` file. |
| `Building apk` for more than 10 minutes | The Gradle cache is cold. Run again from the user's own terminal. |
| `is not compatible` or `compatibility` | The Patrol CLI and the patrol package versions do not match. See the Patrol compatibility table. |
| `No device` or `device not found` | Start the emulator or boot the simulator, then go back to Step 2. |

## Reference

### Recorder choice

The script reads `patrol --version` before each run and picks the recorder.

| Platform | Patrol CLI | `RECORDER` | How |
| -------- | ---------- | ---------- | --- |
| Android | 4.7.0 or later | `patrol-cli` | `patrol test --record-video`, one video per test case |
| Android | before 4.7.0 | `watcher-adb` | `adb screenrecord` from the first `🧪` line; Android stops it after 180 s |
| iOS simulator | 4.7.0 or later | `patrol-cli` | `patrol test --record-video` |
| iOS simulator | before 4.7.0 | `watcher-simctl` | `xcrun simctl io <udid> recordVideo` from launch to the end |
| iOS device | any | `none` | Not supported |
| Web | 4.0.0 or later | `playwright` | `--web-video on`, converted to MP4 when ffmpeg is installed |
| Web | before 4.0.0 | blocked | Patrol has no web support |

Patrol CLI 4.7.0 and later need the patrol package 4.9.0 or later. The plan
prints a `WARNING=` when the project resolves an older package.

### Project config

`.patrol-runner.json` at the repository root removes questions that have the
same answer every time. `init` writes a starter file. All paths are relative to
the file.

| Key | Effect |
| --- | ------ |
| `defaultProject` | Project to use when `--project` is not given |
| `platform` | Platform to use when `--platform` is not given |
| `outputDir` | Video folder for every project |
| `flutterCommand` | Flutter command, for example `fvm flutter` |
| `projects.<path>.testDir` | Patrol test folder for that project |
| `projects.<path>.patrolArgs.all` | Arguments added to every `patrol test` run |
| `projects.<path>.patrolArgs.android` / `ios` / `web` | Arguments added for that platform |

When `projects` is set, only those projects are offered.

### Other commands

```bash
fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart list
fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart init
fvm dart run .agents/skills/run-patrol-test/scripts/run_patrol_test.dart --help
```

Exit codes: `0` ready or passed, `1` blocked or failed, `2` a question to ask,
`64` bad arguments.
