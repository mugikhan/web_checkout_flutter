# Spec Delta

## Purpose

Turns a checkout session into exactly one order, validates the draft on the "server", and keeps repeated taps, refreshes and Back from creating a second order.

## ADDED Requirements

### Requirement: One order per session
Confirm SHALL send the session id, the bag ids and the slot start. The "server" SHALL create at most one order per session. A repeat confirm on a completed session SHALL return the existing order and create nothing.

#### Scenario: First confirm
- **WHEN** the customer confirms an open session with valid bags, slot and card
- **THEN** the "server" creates one order and marks the session `COMPLETED` with that order's id

#### Scenario: Repeat confirm
- **WHEN** a second confirm arrives for a session that already created order `ord_1`
- **THEN** the "server" returns `ord_1` and creates no new order

#### Scenario: Two confirms at once
- **WHEN** two confirm requests for the same open session reach the "server" at the same time
- **THEN** both return the same order and the "server" holds one order

### Requirement: Repeated taps
While a confirm runs, the page SHALL ignore further Confirm taps and SHALL show Confirm as loading.

#### Scenario: Double tap
- **WHEN** the customer taps Confirm twice in quick succession
- **THEN** the app sends one confirm request and the "server" holds one order

### Requirement: Server validates the draft
The "server" SHALL reject a confirm whose session is unknown or foreign, whose session expired, whose bags are not 1 or 2 distinct known bags, whose slot is not an offered window, or whose session has no payment method. Each rejection SHALL be a typed result, and none SHALL create an order.

#### Scenario: Unknown session
- **WHEN** a confirm names a session id that does not exist or that another viewer owns
- **THEN** the result is session not found

#### Scenario: Expired session
- **WHEN** a confirm names a session created more than 15 minutes ago with no order
- **THEN** the result is session expired

#### Scenario: Bad bags
- **WHEN** a confirm sends no bags, 3 bags, a duplicate bag or an unknown bag id
- **THEN** the result is invalid bags

#### Scenario: Passed slot
- **WHEN** a confirm sends a slot whose window already started
- **THEN** the result is slot unavailable

#### Scenario: No card
- **WHEN** a confirm names a session with no payment method
- **THEN** the result is payment method missing

### Requirement: Confirm failures on the page
The page SHALL handle every confirm failure. Session not found and session expired SHALL show their full-page states. Slot unavailable, payment method missing, invalid bags and an unexpected fault SHALL show an error notice and let the customer try again.

#### Scenario: Slot passed while on the page
- **WHEN** the customer confirms and the "server" answers slot unavailable
- **THEN** the page shows "That collection window is no longer available. Pick another.", reloads the windows and drops the slot

#### Scenario: Unexpected fault
- **WHEN** the confirm request fails for an unexpected reason
- **THEN** the page shows "Checkout failed. Try again." and Confirm works again

### Requirement: Order record
The order SHALL hold the bag names and prices at confirm time, the total, the store, the collection window, the card, the status `CREATED`, the confirm time, and a hold time 3 seconds after confirm. It SHALL record whether the card declines.

#### Scenario: Visa order
- **WHEN** the customer confirms the Café and Bakery bags with "Visa •••• 4242"
- **THEN** the order holds "Café bag" at 5999 cents and "Bakery bag" at 4999 cents, a total of 10998 cents, the status `CREATED`, and a card that does not decline

#### Scenario: Mastercard order
- **WHEN** the customer confirms with "Mastercard •••• 0002"
- **THEN** the order is created and records that the card declines

### Requirement: Move to the order after confirm
After a confirm succeeds, the app SHALL open `/orders/:orderId` with replace. Back SHALL NOT return to the checkout page.

#### Scenario: Confirm lands on the order
- **WHEN** the customer confirms
- **THEN** the order page shows "Order placed" and the order id, and the address bar reads `/orders/<order id>`

#### Scenario: Back after confirm
- **WHEN** the customer goes back in the browser from the order page
- **THEN** the browser leaves the order page for the page before checkout, not the checkout page
