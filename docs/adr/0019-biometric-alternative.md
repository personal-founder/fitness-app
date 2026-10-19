---
metadata_version: 1
purpose: Record the decision to delegate alternate unlock to device authentication.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0019
title: "Delegate alternate unlock to device authentication"
status: accepted
date: "2026-10-19"
decision_basis: "User allows device fingerprint/Face ID instead of entering the app passcode."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0019: Delegate alternate unlock to device authentication

## Decision

Use local_auth; mobile/Apple request biometrics and Windows delegates factors to Windows Hello.

## Context and drivers

User allows device fingerprint/Face ID instead of entering the app passcode.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: NativeAppLock.biometric and platform configuration.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | A simulated biometric flag provides no device authentication. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: NativeAppLock.biometric and platform configuration.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Denial paths tested through adapters; physical biometric success not tested.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Remove the alternate button while preserving PIN recovery; revisit per-platform capability evidence.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
