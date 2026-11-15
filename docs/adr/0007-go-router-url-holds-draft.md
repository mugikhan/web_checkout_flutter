# ADR-0007: go_router with path URLs; the URL holds the draft

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The brief requires deep links and browser refresh that never break the flow.

## Decisions

- Use go_router with `usePathUrlStrategy`.
- Routes:
  - `/sign-in?from=<location>`: public.
  - `/?bags=…`: catalog, public.
  - `/checkout/:sessionId?bags=…&slot=…`: guarded, full screen, outside the nav shell.
  - `/orders/:orderId`: guarded, inside the shell under the Bags branch.
- A `StatefulShellRoute` holds two branches: Bags and Account.
- A signed-out user on a guarded route goes to `/sign-in?from=…` and returns after sign-in.
- The URL holds the draft (bags, slot). Confirmed facts live on the "server".
- Confirm moves to the order with replace, so Back never returns to a confirmable checkout.

## Consequences

- Refresh rebuilds every screen from the URL plus "server" queries.
- Static hosts need an SPA fallback to `index.html`. README says so.
- Users can edit the URL, so the "server" validates every draft value.
