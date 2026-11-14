# ADR-0014: Adaptive navigation on Material 3 window sizes

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The app is web first and must also work on phones.

## Decisions

- Compact, under 600px: bottom `NavigationBar`.
- Medium, 600 to 839px: `NavigationRail`.
- Expanded, 840px and up: extended rail with labels.
- Destinations: Bags and Account.
- `AdaptiveScaffold` in `packages/ui` owns the switch. Breakpoints are tokens.
- Checkout shows no nav at any size.

## Consequences

- One shell serves every screen size.
- Two destinations keep the nav meaningful without an orders list.
