# Spec Delta

## Purpose

Lets a customer pick one of their saved cards as the payment method for a checkout session, stored on the "server" and never in the URL.

## ADDED Requirements

### Requirement: Saved cards
Every viewer SHALL have two saved cards: "Visa •••• 4242" and "Mastercard •••• 0002". The checkout page SHALL list both, with no card picked until the customer picks one or the session already holds one.

#### Scenario: Open checkout
- **WHEN** the customer opens a new checkout session
- **THEN** the page lists "Visa •••• 4242" and "Mastercard •••• 0002" and neither shows as picked

### Requirement: Set the payment method on the session
Picking a card SHALL store it against the session on the "server". The card SHALL NOT appear in the URL. Opening or refreshing the session SHALL show the stored card as picked.

#### Scenario: Pick the Visa card
- **WHEN** the customer picks "Visa •••• 4242"
- **THEN** the "server" stores that card on the session and the card shows as picked

#### Scenario: Refresh keeps the card
- **WHEN** the customer refreshes the checkout page after picking "Visa •••• 4242"
- **THEN** "Visa •••• 4242" shows as picked and the URL holds no card

#### Scenario: Unknown card
- **WHEN** a request sets a card id the viewer does not have
- **THEN** the "server" leaves the session unchanged and the page shows "That card could not be used. Pick another."

### Requirement: Last card picked wins
When the customer picks cards in quick succession, the card picked last SHALL end up stored and shown as picked.

#### Scenario: Two quick picks
- **WHEN** the customer picks "Visa •••• 4242" and then "Mastercard •••• 0002" before the first request finishes
- **THEN** "Mastercard •••• 0002" shows as picked and the session holds it

### Requirement: Confirm waits for a payment method and a window
The Confirm action SHALL stay disabled until the "server" has stored a card on the session and the customer has picked a window. It SHALL stay disabled while a card request runs.

#### Scenario: Window but no card
- **WHEN** the customer has picked a window and no card
- **THEN** Confirm is disabled

#### Scenario: Card and window
- **WHEN** the "server" has stored the Visa card and the customer has picked a window
- **THEN** Confirm is enabled

#### Scenario: Card request running
- **WHEN** the customer picks a card and its request has not finished
- **THEN** Confirm is disabled
