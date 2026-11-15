# app-navigation Specification

## Purpose
Defines how users move between the app's top-level destinations on every screen size, and how each destination maps to a URL.

## Requirements

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

### Requirement: Navigation by window size
The navigation SHALL change with the window width, using Material 3 window size classes.

#### Scenario: Compact window
- **WHEN** the window is narrower than 600px
- **THEN** a bottom navigation bar shows the destinations

#### Scenario: Medium window
- **WHEN** the window is 600px to 839px wide
- **THEN** a navigation rail shows the destinations, with icons only

#### Scenario: Expanded window
- **WHEN** the window is 840px wide or wider
- **THEN** an extended navigation rail shows the destinations with labels

#### Scenario: Resize keeps the page
- **WHEN** the user resizes the window across a breakpoint
- **THEN** the current destination and URL stay the same

### Requirement: Deep links and refresh
Opening a destination URL directly, or refreshing on it, SHALL show that destination when the user may see it.

#### Scenario: Direct link to Account
- **WHEN** a signed-in viewer opens `/account` in a new tab
- **THEN** the Account page shows with Account selected in the navigation

#### Scenario: Refresh on Account
- **WHEN** a signed-in viewer refreshes the browser on `/account`
- **THEN** the Account page shows again

#### Scenario: Direct link to Account signed out
- **WHEN** a signed-out user opens `/account` in a new tab
- **THEN** the Sign in page shows and the address bar reads `/sign-in` with `from` set to `/account`

### Requirement: Unknown URLs
A URL that matches no route SHALL show a "Page not found" view with an action that returns to Bags.

#### Scenario: Mistyped URL
- **WHEN** the user opens `/does-not-exist`
- **THEN** the app shows "Page not found" and a "Go to Bags" action

#### Scenario: Leave the not-found view
- **WHEN** the user selects "Go to Bags" on the not-found view
- **THEN** the Bags page shows and the address bar reads `/`

### Requirement: Accessible navigation
Each navigation destination SHALL expose its label to screen readers and SHALL carry a stable test key.

#### Scenario: Screen reader
- **WHEN** a screen reader focuses a navigation destination
- **THEN** it announces the destination label, "Bags" or "Account"

### Requirement: Return after sign-in
After a signed-out user signs in from a guarded route, the app SHALL return the user to the URL in `from`.

#### Scenario: Sign in from Account
- **WHEN** a signed-out user opens `/account`, lands on the Sign in page and signs in
- **THEN** the Account page shows and the address bar reads `/account`

#### Scenario: No from parameter
- **WHEN** a signed-out user opens `/sign-in` with no `from` and signs in
- **THEN** the Bags page shows and the address bar reads `/`

#### Scenario: External from
- **WHEN** a signed-out user opens `/sign-in?from=https://example.com` and signs in
- **THEN** the Bags page shows and the address bar reads `/`

### Requirement: Sign-in route
The Sign in page SHALL live at `/sign-in`, outside the navigation shell. A signed-in viewer who opens it SHALL go to the URL in `from`, or to `/`.

#### Scenario: Sign in page has no navigation
- **WHEN** a signed-out user opens `/sign-in`
- **THEN** the Sign in page shows with no navigation bar or rail

#### Scenario: Signed-in viewer opens sign-in
- **WHEN** a signed-in viewer opens `/sign-in?from=%2Faccount`
- **THEN** the Account page shows and the address bar reads `/account`

#### Scenario: Leave the Sign in page
- **WHEN** a signed-out user selects the back action on the Sign in page
- **THEN** the Bags page shows and the address bar reads `/`
