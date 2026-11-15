# ADR-0009: Simulated auth through GraphQL signIn and a request context

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

Order routes must sit behind a simulated sign-in. Sessions and orders need an owner.

## Decisions

- `signIn(name)` returns a `Viewer` and a token. The name must be longer than 3 characters after trimming.
- The client stores the token through `packages/storage`, in a client namespace.
- `LocalLink` reads the token from the request context, as a server reads an `Authorization` header.
- Resolvers check ownership. Another user's order reads as not found.
- Sign out deletes the token.
- `AuthRepository` lives in `packages/api`. `modules/auth` holds only the bloc and pages.

## Consequences

- No mutation takes a user argument the client could fake.
- The session survives refresh.
- Swapping in real auth changes the link and the repository, not the modules.
