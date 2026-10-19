---
metadata_version: 1
purpose: Record the decision to limit this milestone to authentication entry views.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0024
title: "Limit this milestone to authentication entry views"
status: superseded
date: "2026-10-19"
decision_basis: "User explicitly narrows the package roadmap to three entry states."
implementation: implemented
supersedes: []
superseded_by: [ADR-0045]
---
# ADR-0024: Limit this milestone to authentication entry views

## Decision

Build login, provisional signup and local lock with a minimal unlocked completion message.

## Context and drivers

User explicitly narrows the package roadmap to three entry states.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: Current application routes and setup documentation.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Invented dashboards would exceed current visual approval and scope. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: Current application routes and setup documentation.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: No dashboard/tracker routes or fictional metrics exist.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Add feature modules only against a later approved milestone.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).


The blank post-unlock destination is now authorized by [ADR-0045](0045-blank-dashboard.md).
