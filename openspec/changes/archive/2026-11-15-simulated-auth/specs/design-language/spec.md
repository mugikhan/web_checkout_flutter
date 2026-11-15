# Spec Delta

## ADDED Requirements

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
