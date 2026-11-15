# checkout-session Specification

## Purpose
Lets a customer start a checkout session from the catalog picks, keeps the session id in the URL as the idempotency key, and handles sessions that are unknown, foreign, expired or completed.

## Requirements

### Requirement: Start a checkout session
Opening `/checkout/new?bags=…` SHALL create a checkout session on the "server" for the signed-in viewer. The app SHALL then replace the URL with `/checkout/:sessionId`, keeping the `bags` and `slot` queries. `/checkout/new` SHALL NOT stay in browser history.

#### Scenario: Signed-in customer starts checkout
- **WHEN** a signed-in viewer opens `/checkout/new?bags=bag_cafe`
- **THEN** the checkout page shows the Café bag and the address bar reads `/checkout/<session id>?bags=bag_cafe`

#### Scenario: Back after starting checkout
- **WHEN** a signed-in viewer on `/?bags=bag_cafe` selects Continue and then goes back in the browser
- **THEN** the Bags page shows `/?bags=bag_cafe`, with no stop at `/checkout/new`

#### Scenario: Start without bags
- **WHEN** a signed-in viewer opens `/checkout/new` with no `bags` query
- **THEN** the Bags page shows and the address bar reads `/`

#### Scenario: Session cannot start
- **WHEN** the "server" cannot create a session
- **THEN** the page shows "Checkout could not start" with a "Try again" action

### Requirement: Session owner comes from the viewer
Creating a session SHALL take no arguments. The "server" SHALL take the session owner from the request's viewer token.

#### Scenario: Create a session
- **WHEN** the viewer "Naledi" creates a checkout session
- **THEN** the "server" stores a session owned by "Naledi", with the status `OPEN`

### Requirement: Session status
A session SHALL be `OPEN`, `COMPLETED` with an order id, or `EXPIRED`. A session SHALL expire 15 minutes after creation unless it is completed.

#### Scenario: Fresh session
- **WHEN** the viewer reads a session created 5 minutes ago with no order
- **THEN** its status is `OPEN`

#### Scenario: Old session
- **WHEN** the viewer reads a session created 15 minutes ago with no order
- **THEN** its status is `EXPIRED`

#### Scenario: Completed session
- **WHEN** the viewer reads a session whose confirm created an order
- **THEN** its status is `COMPLETED` and it carries that order's id

### Requirement: Unknown and foreign sessions
The "server" SHALL report a session id that does not exist, or that another viewer owns, as not found. The checkout page SHALL then show "Checkout not found" with a "Start again" action.

#### Scenario: Unknown session id
- **WHEN** a signed-in viewer opens `/checkout/cs_unknown?bags=bag_cafe`
- **THEN** the page shows "Checkout not found" and a "Start again" action

#### Scenario: Another viewer's session
- **WHEN** the viewer "Thabo" opens a checkout URL with a session that "Naledi" created
- **THEN** the page shows "Checkout not found"

#### Scenario: Start again from not found
- **WHEN** the viewer selects "Start again" on `/checkout/cs_unknown?bags=bag_cafe`
- **THEN** a new session starts and the address bar reads `/checkout/<new session id>?bags=bag_cafe`

### Requirement: Expired session
An expired session SHALL show "This checkout expired" with a "Start again" action. Start again SHALL start a new session with the same bags. It SHALL keep the slot only while that window is still offered.

#### Scenario: Open an expired session
- **WHEN** the viewer opens a checkout URL whose session expired
- **THEN** the page shows "This checkout expired" and a "Start again" action

#### Scenario: Start again keeps the bags
- **WHEN** the viewer selects "Start again" on an expired session with `bags=bag_cafe,bag_bakery`
- **THEN** a new checkout page shows the Café and Bakery bags

#### Scenario: Start again drops a passed slot
- **WHEN** the viewer selects "Start again" on an expired session whose `slot` window already started
- **THEN** the new checkout page shows no picked window and the address bar has no `slot`

#### Scenario: Session expires during checkout
- **WHEN** the viewer confirms after the session expired
- **THEN** the page shows "This checkout expired" and no order is created

### Requirement: Completed session moves to its order
Opening a completed session SHALL move to its order page with replace, so the checkout URL leaves browser history.

#### Scenario: Open a completed session
- **WHEN** the viewer opens the checkout URL of a session that already created order `ord_1`
- **THEN** the order page for `ord_1` shows and the address bar reads `/orders/ord_1`

#### Scenario: Refresh after confirm
- **WHEN** the viewer refreshes the browser on a checkout URL just after confirm created an order
- **THEN** the order page for that order shows and no second order exists
