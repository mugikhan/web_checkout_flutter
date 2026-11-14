# ADR-0018: Show "Page not found" for unknown URLs

**Status:** Accepted  
**Date:** 2026-11-15  
**Deciders:** Mughees Khan

## Context

Path URLs (ADR-0009) let users type or paste any address. A mistyped or outdated link matches no route. go_router shows a bare error screen by default, which breaks the design language and leaves the user stuck.

## Decisions

- A URL that matches no route shows a "Page not found" view, built from the `StateView` atom in `packages/ui`.
- The view offers one action, "Go to Bags", which navigates to `/`.
- The address bar keeps the unknown URL, so the user can see what went wrong.
- The view sits outside the navigation shell, because it belongs to no destination.
- A route that exists but points at a missing record, such as an unknown order id, is not covered here. Each slice handles its own "not found" record inside its page.

## Consequences

- Unknown URLs never crash or show a framework error screen.
- One path back to the app covers every case, without guessing what the user meant.
- Silent redirects to `/` were rejected: they hide broken links and confuse users who typed an address.
