# ADR-0006: graphql_codegen with an in-app LocalLink

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The brief requires a typed GraphQL client with codegen, a schema in the repo and no separate backend.

## Decisions

- Keep `schema.graphql` and all operations as `.graphql` files in `packages/api`.
- Generate typed options and parsers with graphql_codegen and build_runner, for the `graphql` package client.
- Add a custom `LocalLink` that routes each request by operation name to a typed Dart resolver.
- Serve subscriptions as streams from the same link.
- Resolvers persist "server" state through `packages/storage`, under its own namespace.
- JSON maps exist only inside the data layer of `packages/api`.

## Consequences

- The app runs real GraphQL documents through a real client, with no server.
- Swapping `LocalLink` for an `HttpLink` replaces the backend without changes to modules.
- A test checks that every operation has a resolver.
- An in-process GraphQL executor was rejected: no maintained Dart executor exists.
