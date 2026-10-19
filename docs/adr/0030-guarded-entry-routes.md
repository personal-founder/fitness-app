---
metadata_version: 1
purpose: Record the decision to derive GoRouter routes from session phase.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0030
title: "Derive GoRouter routes from session phase"
status: accepted
date: "2026-10-19"
decision_basis: "User explicitly requires GoRouter and consistent signed-in/locked routing."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0030: Derive GoRouter routes from session phase

## Decision

Redirect entry paths from verified session phase rather than trusting requested URLs.

## Context and drivers

User explicitly requires GoRouter and consistent signed-in/locked routing.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: lib/app/router.dart.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Unprotected direct URLs could expose the unlocked shell. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: lib/app/router.dart.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Widget navigation tests pass; no tracker routes exist.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Replace routing while retaining session guards; revisit when approved feature routes exist.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
