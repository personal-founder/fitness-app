---
metadata_version: 1
purpose: Record the decision to use Riverpod for injected session state.
owner: unassigned
related_adrs: [ADR-0001]
template_version: 1
id: ADR-0029
title: "Use Riverpod for injected session state"
status: accepted
date: "2026-10-19"
decision_basis: "User explicitly requires Riverpod state management."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0029: Use Riverpod for injected session state

## Decision

Inject auth/lock adapters through Riverpod and serialize account transitions in a Notifier.

## Context and drivers

User explicitly requires Riverpod state management.
This focused record extracts the corresponding boundary from the original
[foundation record](0001-auth-foundation.md); it does not assert new product approval.

## Scope

- Applies to: lib/features/auth/session_controller.dart and adapter providers.
- Excludes: independent choices indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Selected approach | Follows the documented requirement | Requires scoped verification and maintenance | Adopted within the user's implementation authority |
| Alternative | May reduce initial implementation work | Widget-local authentication state would duplicate ownership and complicate race tests. | Rejected for this milestone |

## Consequences

- Benefit: a concrete, reviewable boundary for this responsibility.
- Risk: implementation evidence is narrower than intended cross-platform support.
- Mitigation: retain explicit limitations in the [work record](../changes/2026-10-19-auth-foundation.md).

## Implementation and traceability

- Affected responsibility: lib/features/auth/session_controller.dart and adapter providers.
- [Work evidence](../changes/2026-10-19-auth-foundation.md) maps files and results.
- [Dependencies](../dependencies.md) records package/tool acquisition; no paid activation.

## Verification

- Acceptance: behavior and files follow the decision stated above.
- Result: State, duplicate submission, background and recovery regression tests pass.
- Limits: no store, production, security-certification or unrun-platform claim.

## Reversal and revisit

Replace provider wiring behind the same gateway contracts and rerun state/race tests.

## References

- [Architecture](../../ARCHITECTURE_AND_DATA.md).
- [Approved UI handoff](../reference/Macro_App_Auth_UI_UX_Codex_Handoff.md).
- [Narrowed task and verification evidence](../changes/2026-10-19-auth-foundation.md).
