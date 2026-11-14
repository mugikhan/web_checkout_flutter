# ADR-0004: Melos 7 as the workspace task runner

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

Pub workspaces resolve dependencies but do not run scripts across members. We need analyze, test, format, codegen and an import-boundary check across the repo.

## Decisions

- Use Melos 7 (`^7.8.2`), configured in the root `pubspec.yaml`. Stay on 7 even though 8 exists.
- Define scripts for analyze, test, format, codegen (build_runner in `packages/api`) and the import-boundary check.

## Consequences

- One command runs a task across all members, locally and in CI.
- Reviewers need `dart pub global activate melos 7.8.2`, or they run the scripts' commands by hand.
- A `Makefile` was rejected because Melos understands the workspace graph.
