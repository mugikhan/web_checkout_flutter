# ADR-0013: Design tokens from refreshi.co.za; DM Sans through google_fonts

**Status:** Accepted  
**Date:** 2026-11-14  
**Deciders:** Mughees Khan

## Context

The app needs one consistent design language on every platform, based on a reference website.

## Decisions

- Take colours, button and text roles from the refreshi.co.za home page. Infer the remaining tokens.
- Record every token in `DESIGN.md` at the repo root.
- Write tokens by hand in Dart: a `ColorScheme` per theme plus `ThemeExtension`s for spacing, radius and brand colours.
- Ship light and dark themes, following the system setting.
- Load DM Sans through `google_fonts` and use it for all text.
- A unit test checks that the Dart hex values match `DESIGN.md`.
- Use a neutral app name ("Bag Checkout") and a fictional store ("Corner Pantry"). Do not use the Refreshi name or logo.

## Consequences

- Agents and humans read one source for design rules.
- Web may show a short font swap on first load. Tests disable runtime font fetching.
- A JSON token generator was rejected as a third codegen step for few tokens.
