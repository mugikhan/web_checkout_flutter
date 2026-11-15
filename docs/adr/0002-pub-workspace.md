# ADR-0002: Pub workspace: packages, modules, app

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The brief asks for an architecture suitable for a growing app. Folders in one package give no enforced boundaries.

## Decisions

- Use a pub workspace. The root `pubspec.yaml` lists every member.
- `packages/` holds shared code: `ui`, `storage`, `api`.
- `modules/` holds features: `auth`, `catalog`, `checkout`, `orders`.
- `apps/web_checkout` composes modules into journeys.
- Dependencies point one way: app → modules → packages. A module never imports another module.
- Add a member only in the slice that first uses it.

## Consequences

- One dependency resolution and one lockfile for the whole repo.
- Each package states its dependencies, so a forbidden import fails to resolve.
- More `pubspec.yaml` files to maintain than a single package.
