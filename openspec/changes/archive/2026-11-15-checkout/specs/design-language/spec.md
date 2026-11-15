# Spec Delta

## ADDED Requirements

### Requirement: Window chips
A collection window SHALL show as a chip with its time range. A picked chip SHALL use `primary` with `onPrimary` text, and an unpicked chip SHALL use `surfaceContainer` with an `outline` border and `onSurface` text. Both SHALL meet 4.5:1 contrast in both themes.

#### Scenario: Picked chip
- **WHEN** a window chip is picked
- **THEN** its background is `primary` and its text is `onPrimary`

#### Scenario: Screen reader on a chip
- **WHEN** a screen reader focuses a window chip
- **THEN** it announces the chip's label and whether it is selected

### Requirement: Saved card tiles
A saved card SHALL show as a selectable tile with a card icon and its masked number. A picked tile SHALL show a check mark and a 2px `primary` border. A tile whose request runs SHALL show a small progress indicator.

#### Scenario: Picked card
- **WHEN** a saved card tile is picked
- **THEN** it shows a check mark and a `primary` border

#### Scenario: Card request running
- **WHEN** a saved card tile is busy
- **THEN** it shows a progress indicator in place of the check mark
