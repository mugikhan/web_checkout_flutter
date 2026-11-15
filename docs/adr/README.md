# Architecture decision records

Write an ADR for a technical choice with lasting impact, a meaningful trade-off, or a high cost to reverse. The test: would a future engineer ask "why was this built this way?" Record every other decision in [`docs/ORACLE.md`](../ORACLE.md).

Copy the header of an existing ADR for a new one, and number it after the last.

| ADR | Decision |
|---|---|
| [0001](0001-material-ui-split.md) | Opt in to the material/cupertino split and use material_ui only |
| [0002](0002-pub-workspace.md) | Pub workspace: packages, modules, app |
| [0003](0003-clean-architecture-in-api.md) | Clean architecture in packages/api |
| [0004](0004-graphql-codegen-local-link.md) | graphql_codegen with an in-app LocalLink |
| [0005](0005-typed-result-unions.md) | Typed result unions for mutation failures |
| [0006](0006-bloc-with-concurrency.md) | bloc with bloc_concurrency transformers |
| [0007](0007-go-router-url-holds-draft.md) | go_router with path URLs; the URL holds the draft |
| [0008](0008-checkout-session-idempotency.md) | Server-issued checkout session as the idempotency key |
| [0009](0009-simulated-auth.md) | Simulated auth through GraphQL signIn and a request context |
| [0010](0010-get-it-registration.md) | Plain get_it with per-module registration |
| [0011](0011-design-tokens.md) | Design tokens from refreshi.co.za; DM Sans through google_fonts |
| [0012](0012-testing-strategy.md) | Testing with bloc_test and patrol per slice |
| [0013](0013-commit-generated-code.md) | Commit generated GraphQL code |
