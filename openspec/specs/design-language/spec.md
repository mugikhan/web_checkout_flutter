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
