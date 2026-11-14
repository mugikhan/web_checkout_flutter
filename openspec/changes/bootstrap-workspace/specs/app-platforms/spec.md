# Spec Delta

## Purpose

Defines how the one Flutter codebase launches on web, iOS and Android, and how it identifies itself on each platform.

## ADDED Requirements

### Requirement: Launch on every target platform
The app SHALL build and launch from one codebase on web (Chrome), iOS and Android.

#### Scenario: Web launch
- **WHEN** a developer runs the app on Chrome
- **THEN** the browser shows the home screen with the title "Bag Checkout"

#### Scenario: Mobile launch
- **WHEN** a developer runs the app on an iOS simulator or an Android emulator
- **THEN** the device shows the same home screen with the title "Bag Checkout"

### Requirement: App identity
The app SHALL use the display name "Bag Checkout" and the bundle id `dev.mugikhan.bagcheckout` on every platform that has them.

#### Scenario: Browser tab title
- **WHEN** the app loads on web
- **THEN** the browser tab title reads "Bag Checkout"

#### Scenario: Installed app name
- **WHEN** the app is installed on iOS or Android
- **THEN** the launcher shows "Bag Checkout" and the platform reports the bundle id `dev.mugikhan.bagcheckout`

### Requirement: Path URLs on web
The web app SHALL use path URLs without a `#` fragment.

#### Scenario: Root URL
- **WHEN** the app loads on web
- **THEN** the address bar shows `/` with no `#`

#### Scenario: Browser refresh
- **WHEN** the user refreshes the browser on the home screen
- **THEN** the app reloads to the same home screen
