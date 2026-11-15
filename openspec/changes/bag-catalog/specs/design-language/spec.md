# Spec Delta

## ADDED Requirements

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
