# ADR-0010: Server-issued checkout session as the idempotency key

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

Double clicks, refreshes and Back must never create duplicate financial outcomes.

## Decisions

- `createCheckoutSession` returns a session id that goes into the URL. Sessions expire 15 minutes after creation.
- `setPaymentMethod(sessionId, cardId)` stores the card against the session on the "server". The card never goes into the URL.
- `confirmCheckout(sessionId, bagIds, slotStart)` creates at most one order per session. A repeat call returns the existing order.
- The resolver rejects unknown sessions, expired sessions and sessions owned by another user.
- A session is `OPEN`, `COMPLETED` or `EXPIRED`. Opening a completed session redirects to its order.
- Orders snapshot bag names and prices at confirm time.

## Consequences

- Duplicate protection lives on the "server", as it would in production. The client `droppable` guard only reduces noise.
- Wiping all browser storage also wipes the in-app "server". The session then reads as not found, and the user starts again.
