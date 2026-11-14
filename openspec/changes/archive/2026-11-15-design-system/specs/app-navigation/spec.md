# Spec Delta

## Purpose

Defines how users move between the app's top-level destinations on every screen size, and how each destination maps to a URL.

## ADDED Requirements

### Requirement: Top-level destinations
The app SHALL offer two top-level destinations, Bags and Account. Each SHALL have its own URL: Bags at `/` and Account at `/account`.

#### Scenario: Open Account
- **WHEN** the user selects Account in the navigation
- **THEN** the Account page shows and the address bar reads `/account`

#### Scenario: Return to Bags
- **WHEN** the user selects Bags in the navigation
- **THEN** the Bags page shows and the address bar reads `/`

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
Opening a destination URL directly, or refreshing on it, SHALL show that destination.

#### Scenario: Direct link to Account
- **WHEN** the user opens `/account` in a new tab
- **THEN** the Account page shows with Account selected in the navigation

#### Scenario: Refresh on Account
- **WHEN** the user refreshes the browser on `/account`
- **THEN** the Account page shows again

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
