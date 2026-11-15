# ADR-0003: Clean architecture in packages/api

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

Modules need typed data without depending on GraphQL or generated code. The brief bans dynamic maps in app code.

## Decisions

- `packages/api` has a domain layer and a data layer.
- Domain: entities, repository interfaces and sealed failures. Barrel: `lib/domain/domain.dart`.
- Data: GraphQL client, LocalLink, local server and repository implementations that map generated types to entities. Barrel: `lib/data/data.dart`.
- Modules import `package:api/domain/domain.dart` only. Only the app imports `package:api/data/data.dart`.
- A Melos script fails when a module imports the data barrel or `src/`.
- Blocs call repositories directly. We add no use-case layer.

## Consequences

- Blocs test against fake repositories with no GraphQL setup.
- Generated types never leak into modules.
- All repositories live in one package, so modules share entities.
- Use cases were rejected as ceremony for this scope.
