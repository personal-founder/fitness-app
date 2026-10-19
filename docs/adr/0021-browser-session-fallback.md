---
metadata_version: 1
purpose: Record the decision to keep unsupported-platform sessions in memory.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0021
title: "Keep unsupported-platform sessions in memory"
status: accepted
date: "2026-10-19"
decision_basis: "Implementation brief permits explicit safe platform fallbacks."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0021: Keep unsupported-platform sessions in memory

## Decision

Web/Linux keep sessions in memory and require account credentials after reopening; no fake app PIN.

## Context and drivers

Implementation brief permits explicit safe platform fallbacks.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: ProtectedSessionStorage and supportsLocalLock.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Browser key/value storage cannot be described as equivalent to OS secure storage. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: ProtectedSessionStorage and supportsLocalLock.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Memory-only adapter tests pass; browser startup/login views verified.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Implement a separately reviewed platform adapter before adding persistent browser/Linux unlock.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
