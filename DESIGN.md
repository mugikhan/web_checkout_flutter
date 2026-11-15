# Design

The design language for Bag Checkout. It applies on web, iOS and Android. `packages/ui` implements it, and tests keep the two in step.

## Source

- Reference: the refreshi.co.za home page, pulled on 2026-11-14.
- Taken from the site: colours, button and text roles, the body font, and the corner radius.
- Inferred here: spacing, elevation, motion, breakpoints and the contrast fixes below.
- The app uses its own name and no Refreshi name or logo.

## Colour

Colours map onto Material 3 `ColorScheme` roles. The brand colours sit in the `AppTokens` theme extension.

Keep this table's format: one row per role, the role and hex values in backticks. A test in `packages/ui` parses it and fails when `AppColors` differs.

| Role | Light | Dark | Note |
|---|---|---|---|
| `surface` | `#F6F3EE` | `#101814` | Site background |
| `surfaceContainer` | `#F6F3EE` | `#18251F` | Site card |
| `onSurface` | `#1D2B24` | `#F6F3EE` | Site foreground |
| `onSurfaceVariant` | `#5C7066` | `#9DADAF` | Site muted text |
| `primary` | `#1D2B24` | `#E7F54D` | Site primary |
| `onPrimary` | `#E7F54D` | `#1D2B24` | Site primary text |
| `secondary` | `#BCCBCD` | `#2B3B33` | Site secondary |
| `onSecondary` | `#1D2B24` | `#F6F3EE` | Site secondary text |
| `tertiary` | `#E7F54D` | `#FF791A` | Site accent |
| `onTertiary` | `#1D2B24` | `#1D2B24` | Site accent text; dark changed from white for contrast |
| `error` | `#AD4800` | `#DE6E6E` | Changed for contrast; see below |
| `onError` | `#FFFFFF` | `#1D2B24` | Changed for contrast; see below |
| `errorContainer` | `#FF791A` | `#7F1D1D` | Site destructive |
| `onErrorContainer` | `#1D2B24` | `#FAFAFA` | Light changed from white for contrast |
| `outline` | `#C7D1CC` | `#2B3B33` | Site border |
| `outlineVariant` | `#C7D1CC` | `#2B3B33` | Site border |
| `brandLime` | `#E7F54D` | `#E7F54D` | Brand accent; navigation indicator |
| `onBrandLime` | `#1D2B24` | `#1D2B24` | Icons and text on lime |
| `brandSage` | `#BCCBCD` | `#BCCBCD` | Brand secondary |
| `brandOrange` | `#FF791A` | `#FF791A` | Brand highlight |

### Contrast fixes

Every text and background pair meets WCAG AA: 4.5:1 for body text, 3:1 for large text and icons. A test checks every `on*` pair in both themes.

The site breaks AA in three places:

- Light, white on orange `#FF791A`: 2.62:1. Error text on cream in the same orange: 2.37:1. `error` becomes `#AD4800`, the same hue at 34% lightness. It reads 5.12:1 on cream and 5.67:1 under white. The bright orange moves to `errorContainer` with forest text (5.62:1).
- Dark, red `#7F1D1D` as text on the dark background: 1.80:1. It moves to `errorContainer`. `error` becomes `#DE6E6E` (5.64:1).
- Dark, white on the orange accent: 2.62:1. `onTertiary` becomes forest (5.62:1).

## Type

DM Sans for all text, loaded through `google_fonts`. No other typeface.

| Style | Size / line height | Weight | Use |
|---|---|---|---|
| `displaySmall` | 36 / 44 | 600 | Rare hero numbers |
| `headlineMedium` | 28 / 36 | 600 | Page titles |
| `titleLarge` | 22 / 28 | 600 | Section titles, app bar |
| `titleMedium` | 16 / 24 | 600 | Card titles |
| `bodyLarge` | 16 / 24 | 400 | Body text |
| `bodyMedium` | 14 / 20 | 400 | Secondary text |
| `labelLarge` | 14 / 20 | 600 | Buttons |
| `labelMedium` | 12 / 16 | 500 | Navigation labels, chips |

## Spacing

A 4px grid. Use only these steps.

| Token | Value |
|---|---|
| `xs` | 4 |
| `sm` | 8 |
| `md` | 12 |
| `lg` | 16 |
| `xl` | 24 |
| `xxl` | 32 |
| `xxxl` | 48 |

Page padding: `lg` on compact windows, `xl` on medium and expanded.

## Radius

| Token | Value | Use |
|---|---|---|
| `sm` | 8 | Chips, small controls |
| `md` | 12 | Cards, buttons, inputs. The site's `.75rem`. |
| `pill` | 999 | Badges, status pills |

## Elevation

The site is flat. Separate surfaces with colour and a 1px `outline` border, not shadows.

- Cards: elevation 0, `outline` border, `md` radius.
- Navigation bar and rail: elevation 0, on `surface`.
- Dialogs and menus: elevation 3, the only shadows in the app.

## Motion

| Token | Duration | Curve | Use |
|---|---|---|---|
| `short` | 150ms | `easeOut` | Hover, press, small fades |
| `medium` | 300ms | `easeInOutCubic` | Page and layout changes |
| `long` | 500ms | `easeInOutCubic` | Timeline progress |

Respect the platform's reduce-motion setting: skip non-essential animation when it is on.

## Breakpoints

Material 3 window size classes, by window width.

| Class | Width | Navigation |
|---|---|---|
| Compact | under 600 | Bottom `NavigationBar`, app bar with the title |
| Medium | 600 to 839 | `NavigationRail`, icons only |
| Expanded | 840 and up | Extended `NavigationRail` with labels and the title |

## Components

| Component | Use | Rules |
|---|---|---|
| `AdaptiveScaffold` | Every page inside the navigation shell | Pass destinations; never build a bar or rail by hand. |
| `AppButton` | Every button | `primary` for the main action, one per view. `secondary` for alternatives. `ghost` for low-emphasis actions. Show `loading` while an action runs; the button ignores taps then. |
| `AppCard` | Grouped content | Flat, `outline` border, `md` radius, `lg` padding. |
| `StateView` | Empty, error and loading states | Always offer an action on error. Use `error` colours for the icon only. |
| `AppTextField` | Every text input | Always pass a visible `label`; it is also the semantic label. Show validation errors inline through `errorText`, under the field in `error`. `md` radius. `onSurfaceVariant` border, because `outline` falls below 3:1 for a field edge. `primary` border on focus, `error` border on error. |
| `PriceText` | Every price | Format with `formatZar` (`en_ZA`, such as "R59,99"). Price in `titleMedium` `onSurface`. The worth follows in `bodyMedium` `onSurfaceVariant`, crossed out. Screen readers hear "R59,99, worth R180,00". |
| `BagTile` | Every bag a customer can pick | Flat, `surfaceContainer`, `outline` border, `md` radius, `lg` padding. Picked: 2px `primary` border and a check icon in `primary`. Disabled: ignores taps, dims only the icon, and shows its hint in `bodyMedium` `onSurfaceVariant`. One semantics node carries the name, price, checked and enabled state, and the hint. |
| `InlineNotice` | A short page message, such as a cleaned link | `secondary` background, `onSecondary` text and icons, `md` radius. A close icon button with the tooltip "Dismiss". Screen readers announce it as a live region. |

Later slices add components here when they first use them.

## Rules for agents

- Use `packages/ui` widgets and tokens. Never write a raw `Color`, `TextStyle`, `EdgeInsets` value or `BorderRadius` in an app or module.
- Read colours from `Theme.of(context).colorScheme` and brand colours from `context.tokens`. Use `AppSpacing` and `AppRadius` constants for spacing and radius.
- Add a token or component here first, then in `packages/ui`, in the same change.
- Check any new colour pair against AA before adding it.
- Give every interactive widget a key and a semantic label.
