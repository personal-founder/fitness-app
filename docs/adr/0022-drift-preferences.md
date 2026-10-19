---
metadata_version: 1
purpose: Record the decision to limit the initial Drift database to non-sensitive preferences.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0022
title: "Limit the initial Drift database to non-sensitive preferences"
status: accepted
date: "2026-10-19"
decision_basis: "User selected Drift/SQLite, while tracking/sync UI is deferred."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0022: Limit the initial Drift database to non-sensitive preferences

## Decision

Provide a native Drift preference adapter; web database assets and health caches remain deferred.

## Context and drivers

User selected Drift/SQLite, while tracking/sync UI is deferred.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: lib/core/database and domain_database_test.dart.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Premature tracking tables and sync queues add unapproved data handling. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: lib/core/database and domain_database_test.dart.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Real SQLite upsert, parameterization and clear tests pass; runtime app integration is deferred.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Version future schemas with tested migrations; revisit when an approved module needs offline data.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
