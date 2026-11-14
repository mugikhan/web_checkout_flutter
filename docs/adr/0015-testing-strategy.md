# ADR-0015: Testing with bloc_test and patrol per slice

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

Each slice must be verified before the next starts.

## Decisions

- Write `bloc_test` tests for every bloc.
- Write a patrol journey for every slice. Run it on Chrome, and on one mobile target before delivery.
- Give every interactive widget a key, defined as a constant per module, and a semantic label.
- CI runs analyze and unit tests on pull requests to `main` that change code, tooling or `DESIGN.md`. Docs, ADR and OpenSpec changes skip CI. Patrol runs locally only.

## Consequences

- Keys keep patrol tests stable when wording changes. Semantics give screen-reader support.
- Patrol stays out of CI, so slice verification depends on local runs.
