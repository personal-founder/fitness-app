---
metadata_version: 1
purpose: Record the decision to pin current-scope package versions and acquisition evidence.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0026
title: "Pin current-scope package versions and acquisition evidence"
status: accepted
date: "2026-10-19"
decision_basis: "Engineering policy requires reviewed downloads and reproducible dependencies."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0026: Pin current-scope package versions and acquisition evidence

## Decision

Use exact direct versions and the package lockfile; retain an acquisition record instead of installing future-only plugins.

## Context and drivers

Engineering policy requires reviewed downloads and reproducible dependencies.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: pubspec.yaml, pubspec.lock and docs/dependencies.md.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Installing the entire future stack adds unnecessary integration and permissions. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: pubspec.yaml, pubspec.lock and docs/dependencies.md.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: Official package metadata/SDK constraints checked and dependency resolution passed.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Review a deliberate version update, regenerate lockfile and rerun relevant checks.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
