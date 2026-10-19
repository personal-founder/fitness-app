---
metadata_version: 1
purpose: Record the decision to share one theme-aware entry composition.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0013
title: "Share one theme-aware entry composition"
status: accepted
date: "2026-10-19"
decision_basis: "User requests first views referencing the supplied approved mockups."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0013: Share one theme-aware entry composition

## Decision

Render reusable widgets and vector waves with shared light/dark geometry and system appearance.

## Context and drivers

User requests first views referencing the supplied approved mockups.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: lib/features/welcome and lib/app/theme.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | A screenshot background would bake in phone hardware and break real forms. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

The imported UX handoff retains its original bytes, including four intentional
Markdown hard breaks. Its exact path has a Git whitespace attribute permitting
line-end spaces; whitespace checking remains enabled for repository-owned sources.

- Affected responsibility: lib/features/welcome and lib/app/theme.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Chromium screenshots and theme-preservation checks pass; registration arrangement is provisional.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Change tokens/components against newly approved references; retain responsive tests.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
