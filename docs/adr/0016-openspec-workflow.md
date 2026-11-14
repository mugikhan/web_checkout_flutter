# ADR-0016: OpenSpec spec-first workflow with user-verified slices

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The work is done with agentic tools. Each step needs a reviewable spec and a human gate.

## Decisions

- Use OpenSpec with one change per slice.
- Flow per slice: propose, user review, apply, user verification, archive.
- Each `tasks.md` ends with a drafted Verification section and the task "User verifies the slice". The user decides what counts as sign-off.
- Write the next proposal only after the previous slice is signed off.
- Ask the user before any new foundational decision, then record it as an ADR here.
- Branch `feat/<change-name>` off `develop`, PR back to `develop`. Use Conventional Commits in small logical steps.

## Consequences

- Every slice has a spec, a test plan and a sign-off.
- The workflow exceeds the brief's 6–8 hour estimate. With agentic development, wall-clock hours are a different measure. SOLUTION.md records this.
