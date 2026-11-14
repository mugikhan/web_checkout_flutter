# Spec Delta

## ADDED Requirements

### Requirement: Text fields
Every text field SHALL show its label, SHALL use the `md` radius and the `outline` border, and SHALL show an inline error under the field in the theme's error colour.

#### Scenario: Field with an error
- **WHEN** a text field has an error to show
- **THEN** the error text shows under the field in the `error` colour, and its border turns `error`

#### Scenario: Screen reader on a field
- **WHEN** a screen reader focuses a text field
- **THEN** it announces the field's label and, when present, its error
