---
metadata_version: 1
purpose: Record the decision to use documented line extensions for cohesive entry units.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0027
title: "Use documented line extensions for cohesive entry units"
status: accepted
date: "2026-10-19"
decision_basis: "Engineering policy allows justified code extensions up to 150 physical lines."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0027: Use documented line extensions for cohesive entry units

## Decision

Keep cohesive stateful views/security tests together where splitting would obscure their lifecycle responsibility.

## Context and drivers

Engineering policy allows justified code extensions up to 150 physical lines.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: Files listed with actual counts in the authentication work record.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Arbitrary fragment files create navigation overhead without a responsibility boundary. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: Files listed with actual counts in the authentication work record.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Counts and reasons recorded after formatting; generated templates have separate provenance constraints.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Split when a new responsibility emerges or a file would exceed 150; rerun size/behavior checks.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
