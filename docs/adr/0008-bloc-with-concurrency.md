# ADR-0008: bloc with bloc_concurrency transformers

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The brief asks for a clear split between UI and state, and safe handling of repeated actions.

## Decisions

- Use bloc for all feature state, with sealed events and states.
- Set an event transformer from bloc_concurrency on each handler:
  - Confirm: `droppable`, so repeated taps do nothing while a confirm runs.
  - `setPaymentMethod`: `restartable`, so the last card picked wins.
  - Page loads: `restartable`.
  - Order status subscription: `restartable`, cancelled when the bloc closes.

## Consequences

- Concurrency rules sit next to the handler, not in widgets.
- `bloc_test` covers each rule.
- The client guard complements the server guard in ADR-0010; it does not replace it.
