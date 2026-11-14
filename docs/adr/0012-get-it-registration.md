# ADR-0012: Plain get_it with per-module registration

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The app needs dependency management that supports testing and growth.

## Decisions

- Use plain get_it, with no injectable codegen.
- Each module exports one `registerXModule(GetIt sl)` function.
- The app's composition root registers the data implementations from `packages/api`, then calls each module's function.
- Blocs get dependencies in `BlocProvider(create: …)` at route level. Widgets never call `sl`.

## Consequences

- Wiring is explicit and readable in one place.
- Tests build blocs with fakes and never touch get_it.
- injectable was rejected because it adds a second codegen step on top of graphql_codegen.
