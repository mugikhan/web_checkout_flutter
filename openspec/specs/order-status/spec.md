# order-status Specification

## Purpose
Defines how an order's payment hold moves from Created to Confirmed or Failed, how the order page learns about each change live, and how it shows the history.

## Requirements

### Requirement: Status lifecycle
An order SHALL be Created and Pending from its confirm time, because the hold is placed with the order. At its hold time, 3 seconds after confirm, it SHALL turn Confirmed, or Failed when its card declines. The "server" SHALL derive the status from the stored times, so the status is right whenever it is read.

#### Scenario: During the hold
- **WHEN** the order is read before its hold time
- **THEN** its status is Pending

#### Scenario: Visa hold settles
- **WHEN** an order paid with "Visa •••• 4242" is read at or after its hold time
- **THEN** its status is Confirmed

#### Scenario: Mastercard hold settles
- **WHEN** an order paid with "Mastercard •••• 0002" is read at or after its hold time
- **THEN** its status is Failed

#### Scenario: Refresh during the hold
- **WHEN** the viewer refreshes the order page 1 second after confirm
- **THEN** the page shows Pending, then turns Confirmed or Failed at the original hold time, not 3 seconds after the refresh

#### Scenario: Open after the hold
- **WHEN** the viewer opens the order page after its hold time
- **THEN** the page shows the settled status at once, with no Pending step

### Requirement: Live status update
The order page SHALL follow the order through the `orderStatusChanged` subscription while the order is Pending, and SHALL update without a reload when the status changes. The subscription SHALL end once the status is final, and SHALL stop when the viewer leaves the page.

#### Scenario: Pending turns Confirmed on screen
- **WHEN** the viewer stays on a Pending Visa order
- **THEN** the page changes to Confirmed about 3 seconds after confirm, without a reload

#### Scenario: Leave during the hold
- **WHEN** the viewer leaves the order page while the order is Pending
- **THEN** the subscription stops

### Requirement: Decline reason
A Failed order SHALL show the reason "The payment was declined and you were not charged. Try placing the order again" in the error tone. It SHALL offer no retry action.

#### Scenario: Mastercard order fails on screen
- **WHEN** the viewer stays on a Pending Mastercard order
- **THEN** the order turns Failed, the reason shows in the error tone, and "Back to bags" appears

### Requirement: Status timeline
The order page SHALL show a timeline of Created, Pending and the final step. Each reached step SHALL show its local time. The step reached next SHALL animate in, unless the platform asks to reduce motion. Confirmed and Failed SHALL look different, and Failed SHALL use the error colours.

#### Scenario: Pending timeline
- **WHEN** the order is Pending
- **THEN** Created and Pending show as reached with their times, and the final step shows as not reached yet

#### Scenario: Confirmed timeline
- **WHEN** the order turns Confirmed
- **THEN** the final step reads Confirmed, shows its time and animates in

#### Scenario: Failed timeline
- **WHEN** the order turns Failed
- **THEN** the final step reads Failed in the error colours and shows its time

#### Scenario: Reduced motion
- **WHEN** the platform asks to reduce motion
- **THEN** the timeline changes without animation
