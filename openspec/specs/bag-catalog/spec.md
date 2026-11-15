# bag-catalog Specification

## Purpose
Lets a customer see the store's bags, pick up to 2 of them as a draft that lives in the URL, and see what the picks cost.

## Requirements

### Requirement: Bag list
The Bags page SHALL list every bag the store sells, with its name, short description, price and worth. Prices and worths SHALL show in ZAR, formatted for `en_ZA`. The bags SHALL come from the "server" through a typed GraphQL query.

#### Scenario: Open Bags
- **WHEN** the user opens `/`
- **THEN** the page lists the Grocery, Café, Bakery and Surprise bags from Corner Pantry, each with its price and its worth crossed out

#### Scenario: Money format
- **WHEN** a bag costs 5999 cents
- **THEN** its price reads "R59,99" in the `en_ZA` format

### Requirement: Pick bags
The user SHALL pick a bag by selecting its tile and SHALL remove it by selecting the tile again. Each bag SHALL be picked at most once.

#### Scenario: Pick a bag
- **WHEN** the user selects the Café bag on Bags with nothing picked
- **THEN** the Café tile shows as picked

#### Scenario: Remove a bag
- **WHEN** the user selects the picked Café tile again
- **THEN** the Café tile shows as not picked

### Requirement: Bag limit
The user SHALL pick at most 2 bags. With 2 bags picked, every other tile SHALL be disabled and SHALL show the hint "You can pick up to 2 bags". Removing a pick SHALL enable the other tiles again.

#### Scenario: Limit reached
- **WHEN** the user picks the Café and Bakery bags
- **THEN** the Grocery and Surprise tiles are disabled and each shows "You can pick up to 2 bags"

#### Scenario: Disabled tile ignores taps
- **WHEN** the user selects the disabled Grocery tile with 2 bags picked
- **THEN** the picks stay Café and Bakery

#### Scenario: Limit released
- **WHEN** the user removes the Bakery bag while Café and Bakery are picked
- **THEN** the Grocery, Bakery and Surprise tiles are enabled and no tile shows the hint

### Requirement: Selection in the URL
The picks SHALL live in the `bags` query of the Bags URL, as bag ids in pick order, separated by commas. A pick or a removal SHALL replace the current URL and SHALL NOT add a browser history entry. With no picks, the URL SHALL be `/`.

#### Scenario: URL after two picks
- **WHEN** the user picks the Café bag and then the Bakery bag
- **THEN** the address bar reads `/?bags=bag_cafe,bag_bakery`

#### Scenario: URL after removing every pick
- **WHEN** the user removes the last picked bag
- **THEN** the address bar reads `/`

#### Scenario: Back after picks
- **WHEN** a signed-in viewer opens Account, selects Bags, picks two bags and goes back in the browser
- **THEN** the Account page shows, with no step back through each pick

### Requirement: Deep links and refresh keep the picks
Opening a Bags URL with a valid `bags` query, or refreshing on it, SHALL show the same picks.

#### Scenario: Direct link with picks
- **WHEN** the user opens `/?bags=bag_cafe,bag_bakery` in a new tab
- **THEN** the Café and Bakery tiles show as picked and the summary shows 2 bags

#### Scenario: Refresh with picks
- **WHEN** the user refreshes the browser on `/?bags=bag_grocery`
- **THEN** the Grocery tile shows as picked

### Requirement: Selection summary
The Bags page SHALL show a summary with the number of picked bags and their total price. It SHALL offer a "Continue" action, enabled only with 1 or 2 bags picked.

#### Scenario: Two bags picked
- **WHEN** the user picks the Café bag at R59,99 and the Bakery bag at R49,99
- **THEN** the summary reads "2 bags" and "R109,98"

#### Scenario: Nothing picked
- **WHEN** no bag is picked
- **THEN** the summary reads "No bags picked" and the total "R0,00"

#### Scenario: Continue disabled with nothing picked
- **WHEN** no bag is picked
- **THEN** the Continue action is disabled

### Requirement: Bad bag links
When the `bags` query holds unknown ids, duplicates or more than 2 ids, the catalog SHALL drop the unknown ids and duplicates and keep the first 2 valid ids in link order. It SHALL replace the URL with the clean one, without a new history entry, and SHALL show the notice "A max of 2 bags can be selected, some bags were removed" in the error colours.

#### Scenario: Unknown, duplicate and extra ids
- **WHEN** the user opens `/?bags=bag_unknown,bag_cafe,bag_cafe,bag_bakery,bag_grocery`
- **THEN** only Café and Bakery show as picked, the address bar reads `/?bags=bag_cafe,bag_bakery`, and the page shows "A max of 2 bags can be selected, some bags were removed" on an `errorContainer` background

#### Scenario: Only unknown ids
- **WHEN** the user opens `/?bags=bag_unknown`
- **THEN** no bag shows as picked, the address bar reads `/`, and the page shows the notice

#### Scenario: Clean link shows no notice
- **WHEN** the user opens `/?bags=bag_cafe`
- **THEN** the Café tile shows as picked and the page shows no notice

#### Scenario: Dismiss the notice
- **WHEN** the notice shows and the user selects its dismiss action
- **THEN** the notice disappears and the picks stay the same

### Requirement: Loading and failure
While the bags load, the Bags page SHALL show a loading view. When the bags cannot load, it SHALL show an error view with a "Try again" action that loads them again.

#### Scenario: Slow load
- **WHEN** the bags have not arrived yet
- **THEN** the page shows "Loading bags"

#### Scenario: Load fails
- **WHEN** the "server" cannot return the bags
- **THEN** the page shows "Bags could not load" and a "Try again" action

#### Scenario: Retry after a failure
- **WHEN** the user selects "Try again" and the bags load
- **THEN** the page lists the bags

### Requirement: Layout on every window size
The bag list SHALL fit the window: one column on compact windows, and two columns on medium and expanded windows. The summary SHALL stay visible below the list.

#### Scenario: Compact window
- **WHEN** the window is narrower than 600px
- **THEN** the bags show in one column, with the summary below them

#### Scenario: Wide window
- **WHEN** the window is 600px wide or wider
- **THEN** the bags show in two columns, with the summary below them

### Requirement: Accessible catalog
Each bag tile, the notice's dismiss action and the retry action SHALL carry a stable test key and SHALL expose a label to screen readers. A bag tile SHALL announce its name, price, worth, whether it is picked and whether it is disabled.

#### Scenario: Screen reader on a tile
- **WHEN** a screen reader focuses the picked Café tile
- **THEN** it announces "Café bag", its price and worth, and that it is checked

#### Scenario: Screen reader on a disabled tile
- **WHEN** a screen reader focuses a tile disabled by the bag limit
- **THEN** it announces the tile as disabled with the hint "You can pick up to 2 bags"

### Requirement: Continue to checkout
Continue SHALL open `/checkout/new` with the picked bags in its `bags` query. A signed-out user SHALL go to sign-in first, with `from` set to that URL, and SHALL land on checkout after signing in.

#### Scenario: Signed-in viewer continues
- **WHEN** a signed-in viewer picks the Café bag and selects Continue
- **THEN** the checkout page shows the Café bag

#### Scenario: Signed-out user continues
- **WHEN** a signed-out user picks the Café bag and selects Continue
- **THEN** the Sign in page shows with `from` set to `/checkout/new?bags=bag_cafe`

#### Scenario: Sign in after Continue
- **WHEN** that user signs in
- **THEN** the checkout page shows the Café bag and the address bar reads `/checkout/<session id>?bags=bag_cafe`

#### Scenario: Screen reader on Continue
- **WHEN** a screen reader focuses the Continue action
- **THEN** it announces "Continue" and whether it is enabled
