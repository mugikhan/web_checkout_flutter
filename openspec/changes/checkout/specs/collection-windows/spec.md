# Spec Delta

## Purpose

Defines which collection windows a customer can pick at checkout, how they show in local time, and how the picked window lives in the URL.

## ADDED Requirements

### Requirement: Offered windows
The "server" SHALL offer 1-hour collection windows that start on the hour from 09:00 to 21:00, today and tomorrow, in local time. It SHALL hide every window whose start is not after the current time. Windows SHALL have no capacity limit.

#### Scenario: Morning
- **WHEN** the customer opens checkout at 08:30 local time
- **THEN** the page offers 13 windows today, 09:00–10:00 to 21:00–22:00, and 13 windows tomorrow

#### Scenario: Afternoon
- **WHEN** the customer opens checkout at 13:00 local time
- **THEN** today's first window is 14:00–15:00, and tomorrow still offers all 13 windows

#### Scenario: Late evening
- **WHEN** the customer opens checkout at 21:30 local time
- **THEN** the page offers no window today and 13 windows tomorrow

### Requirement: Windows in UTC and local time
The "server" SHALL store and send window starts as UTC instants. The page SHALL show each window in local time, grouped under "Today" and "Tomorrow".

#### Scenario: Window label
- **WHEN** the page shows the window that starts at 14:00 local time
- **THEN** it reads "14:00–15:00" under "Today" or "Tomorrow"

### Requirement: Pick a window
The customer SHALL pick one window at a time. Picking a window SHALL put its UTC start in the `slot` query and SHALL replace the current URL without a new history entry.

#### Scenario: Pick a window
- **WHEN** the customer picks the 14:00–15:00 window
- **THEN** that window shows as picked and the `slot` query holds its UTC start

#### Scenario: Pick another window
- **WHEN** the customer picks the 15:00–16:00 window after the 14:00–15:00 window
- **THEN** only the 15:00–16:00 window shows as picked and the `slot` query changes to its start

### Requirement: Slot from the URL
Opening or refreshing a checkout URL with a `slot` SHALL show that window as picked when the "server" still offers it. A slot that has passed or is not offered SHALL leave the URL with no new history entry. The page SHALL then show the error notice "That time slot is no longer available, please select another time slot and confirm your order" until the customer picks a new window.

#### Scenario: Refresh keeps the window
- **WHEN** the customer refreshes the checkout page with an offered `slot`
- **THEN** the same window shows as picked

#### Scenario: Passed slot on load
- **WHEN** the customer opens a checkout URL whose `slot` window already started
- **THEN** no window shows as picked, the `slot` query leaves the URL, and the page shows "That time slot is no longer available, please select another time slot and confirm your order" on an `errorContainer` background

#### Scenario: Unknown slot on load
- **WHEN** the customer opens a checkout URL whose `slot` is not a window start
- **THEN** no window shows as picked, the `slot` query leaves the URL, and the page shows the same notice

#### Scenario: Notice blocks Confirm
- **WHEN** the stale slot notice shows
- **THEN** Confirm is disabled and its hint asks for a collection window

#### Scenario: New window clears the notice
- **WHEN** the customer picks a window while the stale slot notice shows
- **THEN** the notice disappears and the `slot` query holds the new window's start
