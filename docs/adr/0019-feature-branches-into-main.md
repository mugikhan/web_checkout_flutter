# ADR-0019: Merge feature branches straight into main

**Status:** Accepted  
**Date:** 2026-11-15  
**Deciders:** Mughees Khan

## Context

ADR-0016 had each slice branch off `develop` and reach `main` through a second release PR. For a single-developer assignment, that doubles the PRs per slice and delays CI, which runs only on PRs to `main`. The `develop` branch has been deleted.

## Decisions

- Branch `feat/<change-name>` off `main`.
- Open one PR per slice from that branch to `main`.
- CI runs analyze and unit tests on that PR.
- Merge after the user signs off the slice.
- This supersedes the branching line of ADR-0016. The rest of ADR-0016 stands.

## Consequences

- One PR per slice, and CI checks every slice before it merges.
- `main` always holds the latest signed-off slice.
- No integration branch exists to batch slices. A slice that needs another must wait for it to merge, or stack its PR on the other branch.
