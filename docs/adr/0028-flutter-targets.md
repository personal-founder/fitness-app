---
metadata_version: 1
purpose: Record the decision to use Flutter for six application targets.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0028
title: "Use Flutter for six application targets"
status: accepted
date: "2026-10-19"
decision_basis: "User requires Flutter/Dart on iOS, Android, Web, Windows, macOS and Linux."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0028: Use Flutter for six application targets

## Decision

Generate one Flutter project and platform runners with the pinned stable SDK.

## Context and drivers

User requires Flutter/Dart on iOS, Android, Web, Windows, macOS and Linux.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: native runner directories and lib/main.dart.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | A React/web-only application would miss the explicit native stack. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: native runner directories and lib/main.dart.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Web release compiled; Windows compilation blocked by missing ATL headers; other hosts unavailable.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Replace the application runtime only through an approved migration; revisit if a required platform becomes unsupported.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
