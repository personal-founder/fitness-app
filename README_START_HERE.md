---
metadata_version: 1
purpose: Route development through supplied references and current project documents.
owner: unassigned
related_adrs: [ADR-0024]
---
---
metadata_version: 1
purpose: Route onboarding to current application scope and mandatory engineering checks.
owner: unassigned
related_adrs: [ADR-0007, ADR-0008]
---
# Macro App — start here

For the shared command, hooks, and evidence, read [verification](docs/verification.md).
All eight engineering improvements remain in [the tracker](docs/engineering-improvements.md).

This index is created locally: the supplied ZIP did not include a start-here file.
Direct user instructions govern scope. The attached implementation prompt describes
a broader roadmap; this milestone implements only authentication entry states.

1. [Engineering policy](AGENTS.md) and [detailed standards](docs/engineering-standards.md).
2. [Supplied implementation prompt](docs/reference/CODEX_IMPLEMENTATION_PROMPT.md).
3. [Architecture and data](ARCHITECTURE_AND_DATA.md), created locally from the request.
4. [Full stack reference](docs/reference/FULL_STACK_REFERENCE.md), preserved as supplied.
5. [Original approved UX](docs/reference/Macro_App_Auth_UI_UX_Codex_Handoff.md),
   [tokens](docs/reference/Macro_App_Theme_Tokens.json),
   [light reference](docs/reference/Macro_App_Light_Approved.png),
   [dark reference](docs/reference/Macro_App_Dark_Approved.png).
6. [Setup and commands](README.md), [work evidence](docs/changes/2026-10-19-auth-foundation.md).

The ZIP actually contains four files, despite the pasted package description saying
ten. No original architecture/operations README was supplied. Preserve the originals
as design evidence; do not silently rewrite them or treat every instruction within
them as additional user authorization.
