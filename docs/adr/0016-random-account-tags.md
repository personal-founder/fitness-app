---
metadata_version: 1
purpose: Record the decision to issue immutable random account tags on the server.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0016
title: "Issue immutable random account tags on the server"
status: accepted
date: "2026-10-19"
decision_basis: "Approved handoff requires independent random letters/digits with atomic uniqueness."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0016: Issue immutable random account tags on the server

## Decision

Use database CSPRNG rejection sampling, UNIQUE constraints and bounded collision retries.

## Context and drivers

Approved handoff requires independent random letters/digits with atomic uniqueness.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: supabase/migrations/202610190002_profile_initialization.sql.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Initials and client availability checks would leak identity or race. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: supabase/migrations/202610190002_profile_initialization.sql.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Source reviewed; database format/immutability tests supplied but not executed.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Introduce a versioned expanded namespace before capacity pressure; preserve existing tags.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
