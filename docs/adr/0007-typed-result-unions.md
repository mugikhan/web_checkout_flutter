# ADR-0007: Typed result unions for mutation failures

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

Checkout can fail in several expected ways. GraphQL `errors` carry codes in `extensions`, which is a dynamic map.

## Decisions

- Model expected failures as union members in the schema, for example `union ConfirmCheckoutResult = Order | SessionExpired | SlotUnavailable | PaymentMethodMissing | InvalidBags | SessionNotFound`.
- Repositories map each member to a sealed domain failure.
- Blocs handle failures with an exhaustive `switch`.
- Keep GraphQL `errors` for unexpected faults only.

## Consequences

- The compiler flags an unhandled failure.
- The schema documents every expected outcome.
- Operations need `__typename` fragments, which adds some verbosity.
