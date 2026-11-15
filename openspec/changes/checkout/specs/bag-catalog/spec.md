# Spec Delta

## MODIFIED Requirements

### Requirement: Selection summary
The Bags page SHALL show a summary with the number of picked bags and their total price. It SHALL offer a "Continue" action, enabled only with 1 or 2 bags picked.

#### Scenario: Two bags picked
- **WHEN** the user picks the Café bag at R59,99 and the Bakery bag at R49,99
- **THEN** the summary reads "2 bags" and "R109,98"

#### Scenario: Nothing picked
- **WHEN** no bag is picked
- **THEN** the summary reads "No bags picked" and the total "R0,00"

#### Scenario: Continue disabled with nothing picked
- **WHEN** no bag is picked
- **THEN** the Continue action is disabled

## ADDED Requirements

### Requirement: Continue to checkout
Continue SHALL open `/checkout/new` with the picked bags in its `bags` query. A signed-out user SHALL go to sign-in first, with `from` set to that URL, and SHALL land on checkout after signing in.

#### Scenario: Signed-in viewer continues
- **WHEN** a signed-in viewer picks the Café bag and selects Continue
- **THEN** the checkout page shows the Café bag

#### Scenario: Signed-out user continues
- **WHEN** a signed-out user picks the Café bag and selects Continue
- **THEN** the Sign in page shows with `from` set to `/checkout/new?bags=bag_cafe`

#### Scenario: Sign in after Continue
- **WHEN** that user signs in
- **THEN** the checkout page shows the Café bag and the address bar reads `/checkout/<session id>?bags=bag_cafe`

#### Scenario: Screen reader on Continue
- **WHEN** a screen reader focuses the Continue action
- **THEN** it announces "Continue" and whether it is enabled
