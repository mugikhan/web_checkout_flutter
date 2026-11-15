# Proposal

## Why

Every later slice builds screens. Without shared tokens, a theme and a navigation shell first, each slice would style its own widgets, and the app would drift apart across web, iOS and Android.

## What Changes

- Add `DESIGN.md` at the repo root as the one source of design rules. It covers colour, type, spacing, radius, elevation, motion, breakpoints, component rules and rules for agents ([ADR-0011](../../../../docs/adr/0011-design-tokens.md)).
- Add `packages/ui` with hand-written tokens, light and dark themes, and DM Sans for all text through `google_fonts`.
- Add the atoms this slice uses: `AdaptiveScaffold`, `AppButton`, `AppCard` and `StateView`. The other atoms wait for the slice that first needs them.
- Add go_router with path URLs and a two-branch shell for Bags and Account ([ADR-0007](../../../../docs/adr/0007-go-router-url-holds-draft.md), [the oracle](../../../../docs/ORACLE.md)).
- Switch the navigation by window size: a bottom bar under 600px, a rail from 600px to 839px, and an extended rail with labels from 840px.
- Show placeholder Bags and Account pages, and a "Page not found" view for unknown URLs ([the oracle](../../../../docs/ORACLE.md)).
- Follow the system light or dark setting.
- Fix the reference site's colour pairs that fail WCAG AA contrast, and record each fix in `DESIGN.md`.

## Out of scope

- `AppTextField`, `BagTile`, `WindowChip`, `PriceText` and `StatusTimeline`. They arrive with the slices that use them.
- Real Bags and Account content, sign-in and route guards. They arrive in `simulated-auth` and `bag-catalog`.
- Re-exporting Material symbols from `packages/ui`. That arrives with the first module.
- A widget gallery. The user ruled it out.
- Clash Display or any font other than DM Sans.

## Capabilities

### New Capabilities

- `design-language`: The visual rules every screen follows on every platform: colours, type, spacing, light and dark themes, contrast, and `DESIGN.md` as their source.
- `app-navigation`: How users move between top-level destinations: the adaptive shell, the URL for each destination, deep links, and unknown URLs.

### Modified Capabilities

- `workspace-tooling`: the CI scenario for pull requests to `develop` becomes one for stacked pull requests, because `develop` was removed ([the oracle](../../../../docs/ORACLE.md)).

`app-platforms` keeps its requirements: the app still launches showing "Bag Checkout", and path URLs and refresh still work.

## Impact

- New: `DESIGN.md`, `packages/ui/**`, router and placeholder pages in `apps/web_checkout/lib/`.
- Changed: `apps/web_checkout/lib/app.dart` moves to `MaterialApp.router`. The root `pubspec.yaml` lists `packages/ui` in the workspace.
- New dependencies: `google_fonts` (ui) and `go_router` (app). go_router brings `cupertino_ui` in as a transitive dependency. ADR-0001 bans it as a direct dependency only, so this is allowed.
- Melos scripts pick up `packages/ui` through their existing filters.
