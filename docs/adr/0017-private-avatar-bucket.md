---
metadata_version: 1
purpose: Record the decision to keep avatar objects private and owner-scoped.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0017
title: "Keep avatar objects private and owner-scoped"
status: accepted
date: "2026-10-19"
decision_basis: "User requires private profile images; editor UI is outside the narrowed milestone."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0017: Keep avatar objects private and owner-scoped

## Decision

Prepare a private storage bucket with size/type limits and owner-folder policies.

## Context and drivers

User requires private profile images; editor UI is outside the narrowed milestone.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: supabase/migrations/202610190003_private_avatars.sql.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Public image URLs defeat the stated private default. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: supabase/migrations/202610190003_private_avatars.sql.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Storage policy SQL tests supplied; live storage API validation is blocked.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Migrate objects and policies through a reviewed path; revisit before avatar upload UI.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
