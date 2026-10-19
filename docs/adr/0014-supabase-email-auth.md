---
metadata_version: 1
purpose: Record the decision to use genuine Supabase email authentication.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0014
title: "Use genuine Supabase email authentication"
status: accepted
date: "2026-10-19"
decision_basis: "User requires real sign-up, sign-in, verification, recovery and sign-out."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0014: Use genuine Supabase email authentication

## Decision

Send account operations through the official Supabase SDK; missing configuration cannot create a session.

## Context and drivers

User requires real sign-up, sign-in, verification, recovery and sign-out.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: lib/core/auth and credential forms.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | A demo authentication shortcut would fail the requested security boundary. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: lib/core/auth and credential forms.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Official SDK requests exercised over loopback HTTP; hosted email/session tests need credentials.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Replace the gateway with an approved backend and migrate identities without handling raw passwords.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
