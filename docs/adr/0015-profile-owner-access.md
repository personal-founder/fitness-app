---
metadata_version: 1
purpose: Record the decision to restrict profile records to their owners.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0015
title: "Restrict profile records to their owners"
status: accepted
date: "2026-10-19"
decision_basis: "User requires PostgreSQL RLS and private account profiles."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0015: Restrict profile records to their owners

## Decision

Enable profile RLS and limit client updates to safe fields.

## Context and drivers

User requires PostgreSQL RLS and private account profiles.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: supabase/migrations/202610190001_profiles.sql.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | UI-only filtering permits direct API cross-user access. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: supabase/migrations/202610190001_profiles.sql.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Two-user pgTAP tests supplied; execution blocked by absent PostgreSQL/Supabase tooling.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Use a reviewed forward migration; never disable RLS to recover access.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
