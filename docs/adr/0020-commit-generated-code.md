# ADR-0020: Commit generated GraphQL code

**Status:** Accepted  
**Date:** 2026-11-15  
**Deciders:** Mughees Khan

## Context

graphql_codegen writes typed `*.graphql.dart` files through build_runner (ADR-0006). CI runs analyze and unit tests only (ADR-0015). Without the generated files, both fail.

## Decisions

- Commit the generated `*.graphql.dart` files next to their `.graphql` sources in `packages/api`.
- A Melos `codegen` script runs build_runner in every package that depends on it. Run it after any schema or operation change, and commit the output in the same commit.
- CI does not run build_runner.
- The analyzer and the format check skip generated files.

## Consequences

- Reviewers and CI need no build_runner step, and every run stays fast.
- Schema and operation changes show up as reviewable diffs of the generated types.
- A stale generated file can slip in if someone forgets `melos run codegen`. CI does not catch it.
