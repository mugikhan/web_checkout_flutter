# user-session Specification

## Purpose
Lets a viewer sign in with a name, keeps the session across browser refreshes and app restarts, and lets the viewer sign out.

## Requirements

### Requirement: Sign in with a name
A signed-out user SHALL be able to sign in by entering a name. The app SHALL trim spaces from both ends of the name before it uses it.

#### Scenario: Valid name
- **WHEN** a signed-out user enters "Naledi" and submits the sign-in form
- **THEN** the user is signed in as the viewer "Naledi"

#### Scenario: Name with spaces
- **WHEN** a signed-out user enters "  Naledi  " and submits the sign-in form
- **THEN** the user is signed in as the viewer "Naledi"

### Requirement: Name length on the client
The sign-in form SHALL reject a name with 3 or fewer characters after trimming. It SHALL show an inline error under the field and SHALL NOT send the sign-in request.

#### Scenario: Name too short
- **WHEN** a signed-out user enters "Bob" and submits the sign-in form
- **THEN** the form shows "Enter at least 4 characters" under the name field and the user stays signed out

#### Scenario: Only spaces
- **WHEN** a signed-out user enters "     " and submits the sign-in form
- **THEN** the form shows "Enter at least 4 characters" under the name field and the user stays signed out

#### Scenario: Error clears on edit
- **WHEN** the form shows the name error and the user changes the name
- **THEN** the error disappears

### Requirement: Name length on the "server"
The "server" SHALL reject a sign-in request whose name has 3 or fewer characters after trimming, even when the client skips its own check. It SHALL report the rejection as an invalid-name result that states the minimum length, and SHALL issue no token.

#### Scenario: Client check skipped
- **WHEN** a sign-in request with the name "Bob" reaches the "server"
- **THEN** the result is an invalid name with a minimum length of 4, and no token is stored

#### Scenario: Form shows the server rejection
- **WHEN** the "server" rejects a name the form accepted
- **THEN** the form shows "Enter at least 4 characters" under the name field

### Requirement: Sign-in failure
When sign-in fails for an unexpected reason, the form SHALL show an error and SHALL let the user try again.

#### Scenario: Unexpected failure
- **WHEN** the "server" cannot complete a sign-in request
- **THEN** the form shows "Sign-in failed. Try again." and the submit action works again

### Requirement: Repeated submits
While a sign-in request runs, the form SHALL ignore further submits.

#### Scenario: Double tap
- **WHEN** the user taps the sign-in action twice in quick succession
- **THEN** the app sends one sign-in request

### Requirement: Session survives refresh
A signed-in viewer SHALL stay signed in after a browser refresh or an app restart, until the viewer signs out.

#### Scenario: Refresh while signed in
- **WHEN** a signed-in viewer refreshes the browser on `/account`
- **THEN** the Account page shows the same viewer's name

#### Scenario: Stale token
- **WHEN** the app starts with a stored token that the "server" does not recognise
- **THEN** the user is signed out and the stored token is deleted

### Requirement: Viewer from the request
The "server" SHALL identify the viewer from the token that travels with each request. No request SHALL name the viewer in its arguments.

#### Scenario: Viewer query with a token
- **WHEN** the client asks for the viewer with a valid stored token
- **THEN** the "server" returns the viewer that token belongs to

#### Scenario: Viewer query without a token
- **WHEN** the client asks for the viewer and no token is stored
- **THEN** the "server" returns no viewer

### Requirement: Account shows the viewer
The Account page SHALL show the signed-in viewer's name and a Sign out action.

#### Scenario: Signed-in Account page
- **WHEN** the viewer "Naledi" opens Account
- **THEN** the page shows "Naledi" and a "Sign out" action

### Requirement: Sign out
Signing out SHALL delete the stored token and SHALL return the user to Bags, signed out.

#### Scenario: Sign out from Account
- **WHEN** a signed-in viewer selects "Sign out" on the Account page
- **THEN** Bags shows, the address bar reads `/`, and opening Account asks the user to sign in

#### Scenario: Refresh after sign out
- **WHEN** the user refreshes the browser after signing out
- **THEN** the user is still signed out

### Requirement: Accessible sign-in form
The name field, the sign-in action, the back action and the Sign out action SHALL each expose a label to screen readers and SHALL carry a stable test key.

#### Scenario: Screen reader on the form
- **WHEN** a screen reader focuses the name field or the sign-in action
- **THEN** it announces "Name" or "Sign in"
