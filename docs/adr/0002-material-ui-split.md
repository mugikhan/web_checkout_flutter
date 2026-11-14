# ADR-0002: Opt in to the material/cupertino split and use material_ui only

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

Flutter now ships Material and Cupertino as separate packages that a project can opt in to. The app must keep one design language on web, iOS and Android.

## Decisions

- Opt in to the split.
- Depend on `material_ui` only. Do not add `cupertino_ui`.
- Only `packages/ui` and the app shell import `material_ui`. Modules import `packages/ui`, which may re-export selected Material symbols.
- Verify the exact package names and opt-in steps in the `bootstrap-workspace` slice.

## Consequences

- One theme drives every platform. iOS gets no native Cupertino look.
- We keep Material's accessibility, text input and pickers.
- Swapping the design layer later touches `packages/ui` only.
