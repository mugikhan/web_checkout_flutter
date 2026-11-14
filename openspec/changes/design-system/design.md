# Design

## Context

The app is one `MaterialApp` with a placeholder home and `usePathUrlStrategy()` (see `openspec/specs/app-platforms`). There is no router, no theme and no `packages/` directory yet.

The reference site, refreshi.co.za, uses shadcn-style HSL tokens in light and dark sets. Its body font is DM Sans. Pulled from its home page stylesheet on 2026-11-14:

| Site token | Light HSL | Light hex | Dark HSL | Dark hex |
|---|---|---|---|---|
| background | 37 33% 95% | `#F6F3EE` | 150 20% 8% | `#101814` |
| card | 37 33% 95% | `#F6F3EE` | 150 20% 12% | `#18251F` |
| foreground | 150 20% 14% | `#1D2B24` | 37 33% 95% | `#F6F3EE` |
| primary | 150 20% 14% | `#1D2B24` | 65 89% 63% | `#E7F54D` |
| primary-foreground | 65 89% 63% | `#E7F54D` | 150 20% 14% | `#1D2B24` |
| secondary | 187 15% 77% | `#BCCBCD` | 150 15% 20% | `#2B3B33` |
| muted-foreground | 150 10% 40% | `#5C7066` | 187 10% 65% | `#9DADAF` |
| accent | 65 89% 63% | `#E7F54D` | 25 100% 55% | `#FF791A` |
| destructive | 25 100% 55% | `#FF791A` | 0 62.8% 30.6% | `#7F1D1D` |
| border | 150 10% 80% | `#C7D1CC` | 150 15% 20% | `#2B3B33` |
| radius | .75rem (12px) | | | |

## Goals / Non-Goals

**Goals:**
- One package, `packages/ui`, that owns every token, both themes and every shared widget.
- A router in the app that later slices extend with routes and guards, without touching the shell.

**Non-Goals:**
- No module directories. Placeholder pages live in the app until `bag-catalog` and `simulated-auth` replace them.
- No go_router dependency in `packages/ui`. The shell widget takes plain callbacks.

## Decisions

### Package layout

```text
packages/ui/
├── lib/ui.dart                 # barrel
├── lib/src/tokens/             # AppColors (light, dark), AppSpacing, AppRadius, AppBreakpoints
├── lib/src/theme/              # AppTheme.light/dark, AppTokens ThemeExtension
├── lib/src/layout/             # WindowSizeClass from width
└── lib/src/widgets/            # AdaptiveScaffold, AppButton, AppCard, StateView
```

`ui` depends on `flutter`, `material_ui` and `google_fonts`. The app depends on `ui` and `go_router`.

### Colour roles

Map the site tokens onto Material 3 `ColorScheme` roles, so Material widgets pick them up without per-widget styling:

| `ColorScheme` role | Light | Dark | Source |
|---|---|---|---|
| `surface` | `#F6F3EE` | `#101814` | background |
| `surfaceContainer` | `#F6F3EE` | `#18251F` | card |
| `onSurface` | `#1D2B24` | `#F6F3EE` | foreground |
| `onSurfaceVariant` | `#5C7066` | `#9DADAF` | muted-foreground |
| `primary` / `onPrimary` | `#1D2B24` / `#E7F54D` | `#E7F54D` / `#1D2B24` | primary pair |
| `secondary` / `onSecondary` | `#BCCBCD` / `#1D2B24` | `#2B3B33` / `#F6F3EE` | secondary pair |
| `tertiary` / `onTertiary` | `#E7F54D` / `#1D2B24` | `#FF791A` / `#1D2B24` | accent |
| `error` / `onError` | `#AD4800` / `#FFFFFF` | `#DE6E6E` / `#1D2B24` | destructive, adjusted |
| `errorContainer` / `onErrorContainer` | `#FF791A` / `#1D2B24` | `#7F1D1D` / `#FAFAFA` | destructive, original |
| `outline` / `outlineVariant` | `#C7D1CC` | `#2B3B33` | border |

Contrast fixes, recorded in `DESIGN.md`:
- Light: the site puts white on `#FF791A` (2.62:1) and uses that orange as error text on cream (2.37:1). `error` becomes `#AD4800`, the same hue at 34% lightness: 5.12:1 on cream, 5.67:1 under white. The bright orange stays as `errorContainer`, with forest text on it (5.62:1).
- Dark: `#7F1D1D` as text on the dark background reads at 1.80:1. It becomes `errorContainer`, and `error` becomes `#DE6E6E` (5.64:1).

Alternative: `ColorScheme.fromSeed`. Rejected, because it generates tones that drift from the site's exact values.

### Theme extension

`AppTokens` is a `ThemeExtension` with spacing (4, 8, 12, 16, 24, 32, 48), radius (8, 12 from the site's `.75rem`, and 999 for pills) and the brand colours Material has no slot for: lime, sage and highlight orange. Widgets read it through `context.tokens`.

### Typography

`AppTheme` builds its `TextTheme` with `GoogleFonts.dmSansTextTheme`. Both theme builders take an optional `TextTheme`. Widget tests pass a plain one, because `google_fonts` would otherwise try to fetch over the network in tests. Patrol runs use the real font.

Alternative: bundle the DM Sans files. Rejected, because the user chose `google_fonts` loading.

### DESIGN.md and its tests

`DESIGN.md` holds one colour table per theme, with role, hex and the reason for any change from the site. A test in `packages/ui` parses those tables and compares every row to `AppColors`. A second test computes WCAG contrast for every `on*`/base pair in both schemes and fails below 4.5:1.

### Window size classes

`WindowSizeClass.fromWidth` returns `compact` (<600), `medium` (600–839) or `expanded` (≥840). `AdaptiveScaffold` reads `MediaQuery.sizeOf(context).width` and renders:
- compact: `Scaffold` with an `AppBar` titled "Bag Checkout" and a bottom `NavigationBar`.
- medium: a `NavigationRail` with icons only, beside the body.
- expanded: a `NavigationRail` with `extended: true`, labels, and "Bag Checkout" as its leading header.

Destinations come in as a list of `AdaptiveDestination(key, icon, selectedIcon, label)`. The shell passes `selectedIndex` and `onDestinationSelected` through. It knows nothing of routes.

### Routing

`apps/web_checkout/lib/router/app_router.dart` builds a `GoRouter`:

```text
StatefulShellRoute.indexedStack
├── branch Bags     → /          BagsPlaceholderPage
└── branch Account  → /account   AccountPlaceholderPage
errorBuilder        → NotFoundPage (StateView + "Go to Bags")
```

The shell builder wraps `navigationShell` in `AdaptiveScaffold` and calls `navigationShell.goBranch(index)`. `buildRouter({String initialLocation = '/'})` lets widget tests start on any URL. Later slices add `/orders/:id` under the Bags branch, and `/checkout/:id` and `/sign-in` outside the shell.

### Atoms in this slice

Only the atoms this slice renders:
- `AdaptiveScaffold`: the shell.
- `AppButton`: primary, secondary and ghost variants, with a loading state. "Go to Bags" uses it.
- `AppCard`: the Account placeholder uses it.
- `StateView`: empty, error and loading layouts with an optional action. The Bags and not-found pages use it.

### Keys and semantics

`AppKeys` in the app holds `navBags`, `navAccount` and `notFoundGoToBags`. Navigation destinations get semantic labels from their text labels. Atoms accept a `Key` and a `semanticLabel` where text alone is not enough.

### Tests

- `packages/ui/test`: DESIGN.md parity, contrast, `WindowSizeClass` boundaries (599, 600, 839, 840), and `AdaptiveScaffold` rendering each layout at those widths.
- `apps/web_checkout/test`: the router at `/`, `/account` and an unknown path, and "Go to Bags" returning to `/`.
- Patrol: one journey that switches destinations and checks the URL on web. On web it also resizes the window across both breakpoints and turns on dark mode.

## Risks / Trade-offs

- [`google_fonts` fetches DM Sans at runtime, so the first web load shows a fallback font briefly] → Accept it, as ADR-0013 records. Revisit as a web performance item later.
- [go_router pulls `cupertino_ui` in transitively] → Allowed: ADR-0002 bans it as a direct dependency only. Nothing in our code imports it.
- [Patrol's `resizeWindow` exists on web only] → Mobile runs check the compact layout. Widget tests cover the medium and expanded layouts on every platform.
- [The DESIGN.md parity test parses Markdown tables] → Keep a fixed table format, which `DESIGN.md` states. The test fails loudly on a malformed row.
