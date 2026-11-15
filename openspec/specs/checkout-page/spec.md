# checkout-page Specification

## Purpose
Defines how the checkout page looks and behaves on every window size: full screen, with an order summary, a close action, clean bag links and accessible controls.

## Requirements

### Requirement: Full-screen checkout
The checkout page SHALL show full screen, outside the navigation shell, with no navigation bar or rail at any window size. It SHALL offer a close action that returns to `/?bags=…` with the same bags and no confirmation dialog.

#### Scenario: No navigation
- **WHEN** the customer opens a checkout session on any window size
- **THEN** no navigation bar or rail shows

#### Scenario: Close checkout
- **WHEN** the customer selects close on `/checkout/<session id>?bags=bag_cafe`
- **THEN** the Bags page shows the Café bag picked and the address bar reads `/?bags=bag_cafe`

### Requirement: Order summary
The checkout page SHALL list each picked bag with its price, and the total price.

#### Scenario: Two bags
- **WHEN** the checkout holds the Café bag at R59,99 and the Bakery bag at R49,99
- **THEN** the summary lists both bags and the total reads "R109,98"

### Requirement: Layout by window size
From 840px wide, the page SHALL show two columns: bags, windows and cards on the left, and the order summary with Confirm on the right, fixed while the left scrolls. Below 840px, the page SHALL show one column with a bottom bar holding the total and Confirm.

#### Scenario: Expanded window
- **WHEN** the window is 840px wide or wider
- **THEN** the page shows two columns with the summary and Confirm on the right

#### Scenario: Compact or medium window
- **WHEN** the window is narrower than 840px
- **THEN** the page shows one column and a bottom bar with the total and Confirm

### Requirement: Bag links in checkout
The checkout page SHALL clean its `bags` query by the catalog rules: unknown ids and duplicates drop out, and only the first 2 valid ids stay. It SHALL replace the URL with the clean one. With no valid bag left, it SHALL show "No bags to check out" with a "Go to Bags" action.

#### Scenario: Extra bags
- **WHEN** the customer opens a checkout URL with `bags=bag_cafe,bag_cafe,bag_bakery,bag_grocery`
- **THEN** the page shows the Café and Bakery bags and the `bags` query reads `bag_cafe,bag_bakery`

#### Scenario: No valid bags
- **WHEN** the customer opens a checkout URL with `bags=bag_unknown`
- **THEN** the page shows "No bags to check out" and a "Go to Bags" action

### Requirement: Loading and failure
While the session loads, the page SHALL show a loading view. When the session or the bags cannot load, it SHALL show "Checkout could not load" with a "Try again" action.

#### Scenario: Load fails
- **WHEN** the "server" cannot return the session
- **THEN** the page shows "Checkout could not load" and a "Try again" action

### Requirement: Accessible checkout
The close action, every window, every saved card, Confirm and every state action SHALL carry a stable test key and SHALL expose a label to screen readers. A window SHALL announce its day, its time range and whether it is picked. A saved card SHALL announce its brand, its last four digits and whether it is picked.

#### Scenario: Screen reader on a window
- **WHEN** a screen reader focuses the picked 14:00–15:00 window today
- **THEN** it announces "Today, 14:00 to 15:00" and that it is selected

#### Scenario: Screen reader on a card
- **WHEN** a screen reader focuses the Visa card
- **THEN** it announces "Visa ending in 4242"
