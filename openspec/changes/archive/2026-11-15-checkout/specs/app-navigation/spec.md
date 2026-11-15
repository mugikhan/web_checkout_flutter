# Spec Delta

## ADDED Requirements

### Requirement: Guarded checkout and order routes
Every URL under `/checkout/` and `/orders/` SHALL require a signed-in viewer. A signed-out user SHALL go to `/sign-in` with `from` set to the full URL, query included.

#### Scenario: Signed-out user opens a checkout URL
- **WHEN** a signed-out user opens `/checkout/cs_1?bags=bag_cafe`
- **THEN** the Sign in page shows with `from` set to `/checkout/cs_1?bags=bag_cafe`

#### Scenario: Signed-out user opens an order URL
- **WHEN** a signed-out user opens `/orders/ord_1`
- **THEN** the Sign in page shows with `from` set to `/orders/ord_1`

### Requirement: Order placeholder
`/orders/:orderId` SHALL show a placeholder page inside the navigation shell, with Bags selected. It SHALL show "Order placed" and the order id from the URL, and SHALL NOT query the order.

#### Scenario: Open an order URL
- **WHEN** a signed-in viewer opens `/orders/ord_1`
- **THEN** the page shows "Order placed" and "ord_1", with Bags selected in the navigation

### Requirement: Sign-in leaves no history entry
When a user signs in on `/sign-in?from=…`, the app SHALL replace the sign-in entry in browser history with the `from` URL.

#### Scenario: Back after sign-in
- **WHEN** a signed-out user on Bags opens Account, signs in and goes back in the browser
- **THEN** the Bags page shows, with no stop at the Sign in page
