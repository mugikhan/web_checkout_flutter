# Glossary

Use these terms in code, UI, specs and docs. Use one term per concept.

| Term | Meaning | Not |
|---|---|---|
| **Bag** | A surplus-food item a customer buys, such as the Grocery, Café, Bakery or Surprise bag. Each bag has a price and a higher worth. The brief calls these "services". | service, product, item |
| **Price** | The amount the customer pays for a bag, in ZAR cents. | cost |
| **Worth** | The retail value of a bag's contents, shown crossed out next to the price. | original price, value |
| **Store** | The fictional seller of all bags: Corner Pantry. | vendor, merchant |
| **Draft** | The customer's picks before confirm: bags and slot. The URL holds the draft. | cart, basket |
| **Collection window** | A 1-hour period between 09:00 and 22:00, today or tomorrow, when the customer collects bags. `slot` in the URL holds the window's start. | schedule, time slot, delivery time |
| **Checkout session** | A "server" record created when the customer starts checkout. Its id is the idempotency key. It is `OPEN`, `COMPLETED` or `EXPIRED`, and it expires after 15 minutes. | cart session |
| **Saved card** | A seeded payment method, shown masked, with an opaque card id. | card token, payment card |
| **Payment method** | The saved card set on a checkout session through `setPaymentMethod`. | |
| **Order** | The record `confirmCheckout` creates. It holds snapshot bag names and prices, the collection window, the payment method and the status. | booking, purchase |
| **Hold** | A temporary reservation of funds on the payment method. The order status tracks it. | charge, payment |
| **Order status** | `Created`, `Pending`, then `Confirmed` or `Failed`. | state |
| **Viewer** | The signed-in user, identified by name. | customer account, profile |
| **"Server"** | The in-app data source behind `LocalLink`. It acts as the backend. | backend service, mock |
