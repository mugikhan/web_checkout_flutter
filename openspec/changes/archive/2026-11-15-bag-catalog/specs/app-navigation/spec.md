# Spec Delta

## MODIFIED Requirements

### Requirement: Top-level destinations
The app SHALL offer two top-level destinations, Bags and Account. Each SHALL have its own URL: Bags at `/` and Account at `/account`. The Bags URL MAY carry a `bags` query with the picked bags. Bags SHALL be public. Account SHALL require a signed-in viewer.

#### Scenario: Open Account
- **WHEN** a signed-in viewer selects Account in the navigation
- **THEN** the Account page shows and the address bar reads `/account`

#### Scenario: Return to Bags
- **WHEN** the user has no bags picked and selects Bags in the navigation
- **THEN** the Bags page shows and the address bar reads `/`

#### Scenario: Open Account signed out
- **WHEN** a signed-out user selects Account in the navigation
- **THEN** the Sign in page shows and the address bar reads `/sign-in` with `from` set to `/account`

#### Scenario: Return to Bags keeps the picks
- **WHEN** a signed-in viewer picks the Café bag, opens Account and selects Bags in the navigation
- **THEN** the Bags page shows the Café bag picked and the address bar reads `/?bags=bag_cafe`
