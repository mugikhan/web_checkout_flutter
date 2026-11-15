# Spec Delta

## Purpose

Shows a customer everything about one order they placed, on its own URL, and leads them back to Bags once the order is settled.

## ADDED Requirements

### Requirement: Order details content
`/orders/:orderId` SHALL show, inside the navigation shell with Bags selected: the heading "Order placed", the order id, the store, each bag with its name and its price at confirm time, the total, the collection window in local time, the masked card, and the status timeline. Every interactive widget SHALL carry a test key and a semantic label.

#### Scenario: Visa order details
- **WHEN** a signed-in viewer opens the order they placed for the Café and Bakery bags with "Visa •••• 4242"
- **THEN** the page shows "Order placed", the order id, "Corner Pantry", "Café bag" at R59,99, "Bakery bag" at R49,99, the total R109,98, the collection window in local time and "Visa •••• 4242"

#### Scenario: Prices stay as confirmed
- **WHEN** the order page loads after the catalog prices change
- **THEN** it shows the prices stored at confirm time

#### Scenario: Refresh on the order page
- **WHEN** the viewer refreshes the browser on `/orders/<order id>`
- **THEN** the same order shows again with Bags selected

### Requirement: Order not found
An order id that does not exist, or that belongs to another viewer, SHALL show "Order not found" with a "Back to bags" action. The page SHALL NOT reveal whether the order exists.

#### Scenario: Unknown order id
- **WHEN** a signed-in viewer opens `/orders/ord_missing`
- **THEN** the page shows "Order not found" and "Back to bags"

#### Scenario: Another viewer's order
- **WHEN** a signed-in viewer opens an order another viewer placed
- **THEN** the page shows "Order not found", exactly as for an unknown id

#### Scenario: Leave the not-found state
- **WHEN** the viewer selects "Back to bags" on "Order not found"
- **THEN** the Bags page shows and the address bar reads `/`

### Requirement: Back to bags on a settled order
A Confirmed or Failed order SHALL end with one "Back to bags" action that opens `/` with no bags picked. A Pending order SHALL show no action.

#### Scenario: Pending order
- **WHEN** the order is Pending
- **THEN** the page shows no "Back to bags" action

#### Scenario: Settled order
- **WHEN** the order turns Confirmed or Failed
- **THEN** a "Back to bags" action appears

#### Scenario: Leave a settled order
- **WHEN** the viewer selects "Back to bags" on a settled order
- **THEN** the Bags page shows with no bags picked and the address bar reads `/`
