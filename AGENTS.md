# AGENTS.md

## Prose style

This covers all prose: docs, specs, commit bodies, PR text, comments, release notes and chat replies. It does not cover code or identifiers.

- Use ASD-STE100 Simplified Technical English as a clarity target, not a strict checklist.
- Write in the active voice, with one idea per sentence. Put conditions before the action that depends on them.
- Use one term per concept.
- Keep procedures to 20 words or fewer and descriptions to 25.
- Never change an identifier, path, command, unit, price or number when rewriting.
- Cut AI rhetoric: "not X, but Y", automatic triads, setup and payoff, throat-clearing openers, recap endings and repeated sentence shapes.
- Vary sentence length. Prefer verbs to noun piles. Drop filler, corporate verbs, hedges and performed enthusiasm.
- Re-read the draft, and rewrite any paragraph that clears its throat or repeats itself.

## Code comments

- By default, write no comment. Add one only when the code cannot say it.
- Never comment on obvious names, restated lines, section banners or unexported helpers. Don't add per-line param, return or error docs.
- Comment the why: a non-obvious constraint, a deliberate choice, or a workaround and its reason.
- Keep a comment to one or two lines, with at most 15 words per sentence. Use the active voice and imperative verbs, with no phrasal verbs.
- Start a doc comment with the identifier's name, in the third person, on one line, with no `@param`, `@returns` or `@throws` tags.
  - Use each language's own form: `//` in Go, `/** */` in TypeScript and NestJS, `///` in Dart.
  - Skip the doc comment when decorators or types already say it.
- Delete commented-out code.
- Write a TODO with an owner, not a ticket: `// TODO (<git config user.name>):`.
- When you change code, update its comment or delete it.
- Re-read the comments you added and delete any that repeat the code. Confusing code needs a rename or a split, not a comment.

## Project workflow

- Work spec first with OpenSpec. Project rules and the slice roadmap live in `openspec/config.yaml`.
- Implement one slice at a time. Do not start the next slice until the user signs off the current one.
- Read `docs/ORACLE.md` before you plan a slice. It holds every user answer from planning onward.
- Read the decisions in `docs/adr/` before you change architecture. Ask the user before a new foundational decision, then add an ADR.
- Use the terms in `docs/GLOSSARY.md`.
- Follow `DESIGN.md` for every screen. Use `packages/ui` tokens and widgets, never raw colours or text styles.
- Run every `flutter` and `dart` command through `fvm`.
