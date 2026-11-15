# design-language Specification

## Purpose
Keeps every screen on one visual language across web, iOS and Android, with `DESIGN.md` as the single source of its rules.

## Requirements

### Requirement: One design source
`DESIGN.md` at the repo root SHALL define every colour token, for light and dark, with its role and hex value. The values the app renders SHALL match it.

#### Scenario: Token drift
- **WHEN** a colour value in the app differs from its row in `DESIGN.md`
- **THEN** the workspace tests fail and name the token

### Requirement: Brand colours
The light theme SHALL use cream backgrounds, forest text and forest primary buttons with lime labels. The dark theme SHALL use forest backgrounds, cream text and lime primary buttons with forest labels.

#### Scenario: Light primary button
- **WHEN** the system is in light mode and a primary button shows
- **THEN** the button is forest (`#1D2B24`) with a lime (`#E7F54D`) label

#### Scenario: Dark primary button
- **WHEN** the system is in dark mode and a primary button shows
- **THEN** the button is lime (`#E7F54D`) with a forest (`#1D2B24`) label

### Requirement: Follow the system theme
The app SHALL follow the device or browser light and dark setting, and SHALL switch while running.

#### Scenario: Switch to dark
- **WHEN** the user switches the system to dark mode while the app runs
- **THEN** the app switches to the dark theme without a restart

### Requirement: One typeface
All text SHALL use DM Sans on every platform.

#### Scenario: Text on any platform
- **WHEN** any screen shows text on web, iOS or Android
- **THEN** the text uses DM Sans

### Requirement: Readable contrast
Every text and background pair in both themes SHALL meet WCAG AA contrast: 4.5:1 for body text and 3:1 for large text and icons.

#### Scenario: Contrast check
- **WHEN** the workspace tests run
- **THEN** they check every on-colour and colour pair in both themes and fail on any pair below 4.5:1

#### Scenario: Reference pair fails
- **WHEN** a pair taken from the reference site fails AA
- **THEN** `DESIGN.md` records the replacement value and the reason

### Requirement: Text fields
Every text field SHALL show its label and SHALL show an inline error under the field in the theme's error colour. Its border SHALL meet 3:1 contrast against the background.

#### Scenario: Field with an error
- **WHEN** a text field has an error to show
- **THEN** the error text shows under the field in the `error` colour, and its border turns `error`

#### Scenario: Field border contrast
- **WHEN** a text field shows without an error in either theme
- **THEN** its border reads at 3:1 or more against the page background

#### Scenario: Screen reader on a field
- **WHEN** a screen reader focuses a text field
- **THEN** it announces the field's label and, when present, its error

### Requirement: Prices
A price SHALL show in ZAR, formatted for `en_ZA`. When a worth is known, it SHALL show next to the price, crossed out, in a muted colour that still meets 4.5:1 contrast.

#### Scenario: Price with a worth
- **WHEN** a bag costs 5999 cents and is worth 18000 cents
- **THEN** "R59,99" shows next to a crossed-out "R180,00"

#### Scenario: Screen reader on a price
- **WHEN** a screen reader reads a price with a worth
- **THEN** it announces the price and then "worth" and the worth, with no strike-through mark

### Requirement: Selectable tiles
A selectable tile SHALL show whether it is picked, and SHALL support a disabled state with a visible hint. A picked tile's border SHALL meet 3:1 contrast against the page in both themes.

#### Scenario: Picked tile
- **WHEN** a tile is picked
- **THEN** it shows a check mark and a `primary` border

#### Scenario: Disabled tile with a hint
- **WHEN** a tile is disabled with a hint
- **THEN** it ignores taps and shows the hint text in a colour that meets 4.5:1 contrast

### Requirement: Inline notices
An inline notice SHALL show a short message on the page, SHALL meet 4.5:1 contrast in both themes, and SHALL offer a dismiss action. A notice SHALL use either the info colours (`secondary` with `onSecondary`) or the error colours (`errorContainer` with `onErrorContainer`). Screen readers SHALL announce the notice when it appears.

#### Scenario: Notice appears
- **WHEN** a page shows an inline notice
- **THEN** a screen reader announces its message

#### Scenario: Error notice
- **WHEN** a page shows an inline notice with the error tone
- **THEN** its container is `errorContainer` and its text and icons are `onErrorContainer`, in both themes

#### Scenario: Dismiss a notice
- **WHEN** the user selects the notice's dismiss action
- **THEN** the page's dismiss callback runs
