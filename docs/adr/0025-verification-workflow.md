---
metadata_version: 1
purpose: Record the decision to verify the entry milestone with repeatable checks.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0025
title: "Verify the entry milestone with repeatable checks"
status: accepted
date: "2026-10-19"
decision_basis: "User requires actual source, tests and available builds."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0025: Verify the entry milestone with repeatable checks

## Decision

Provide Flutter checks, synthetic integration journey and local browser verification without deployment.

## Context and drivers

User requires actual source, tests and available builds.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: test, integration_test, scripts/verify-web.cjs and .github/workflows/flutter.yml.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | A plan-only or screenshot-only deliverable would not establish executable behavior. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: test, integration_test, scripts/verify-web.cjs and .github/workflows/flutter.yml.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Local tests and web checks run; CI has not run remotely and native integration is environment-blocked.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Update checks with behavior changes; preserve failure visibility and separate live service/native evidence.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
