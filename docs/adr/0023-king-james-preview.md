---
metadata_version: 1
purpose: Record the decision to isolate King James in a labeled design preview.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0023
title: "Isolate King James in a labeled design preview"
status: superseded
date: "2026-10-19"
decision_basis: "User names King James as the demo account without supplying account credentials."
implementation: implemented
supersedes: []
superseded_by: [ADR-0034]
---
# ADR-0023: Isolate King James in a labeled design preview

## Decision

A compile-time design fixture renders King James with all authentication/unlock disabled.

## Context and drivers

User names King James as the demo account without supplying account credentials.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: design_preview.dart and PREVIEW_STATE configuration.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | A permanent production identity or shared password is not authorized. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: design_preview.dart and PREVIEW_STATE configuration.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Default signed-out tests prove no private demo identity leaks; preview is visibly labeled.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Remove the fixture or replace it with an explicitly provisioned test account; never migrate fixture credentials.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
