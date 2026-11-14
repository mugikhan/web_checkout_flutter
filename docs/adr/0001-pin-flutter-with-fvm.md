# ADR-0001: Pin Flutter 3.47.9 with FVM

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The brief requires Flutter 3.35+ and Dart 3.5+. Reviewers must build the app with the same toolchain we used. A global Flutter install drifts between machines.

## Decisions

- Pin Flutter 3.47.9 (stable, released 2026-10-29) in `.fvmrc`.
- Run every `flutter` and `dart` command through `fvm`.
- Set the workspace SDK constraints to match the pinned version.

## Consequences

- Builds are reproducible on any machine with FVM.
- Reviewers without FVM must install Flutter 3.47.9 themselves. README explains both paths.
- An upgrade is a deliberate change to `.fvmrc`, not a side effect.
