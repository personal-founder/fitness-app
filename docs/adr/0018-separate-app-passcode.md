---
metadata_version: 1
purpose: Record the decision to use a protected verifier for the separate app passcode.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0018
title: "Use a protected verifier for the separate app passcode"
status: superseded
date: "2026-10-19"
decision_basis: "User selected a separate app passcode after sign-in."
implementation: partial
supersedes: []
superseded_by: [ADR-0032]
---
# ADR-0018: Use a protected verifier for the separate app passcode

## Decision

Enroll a six-digit PIN with confirmation; store salted PBKDF2 verifier and persistent retry state in the OS vault.

## Context and drivers

User selected a separate app passcode after sign-in.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: lib/core/security/pin_*.dart, app_lock.dart and lock_card.dart.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | A hard-coded PIN or plaintext preference value is an insecure shortcut. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: lib/core/security/pin_*.dart, app_lock.dart and lock_card.dart.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Real KDF and persisted throttle tests pass; native secure-store/hardware validation is blocked.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

After fresh account login remove the device record; revisit length/cooldown with usability and device evidence.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
