---
metadata_version: 1
purpose: Record the decision to require credentials before entering the King James demo.
owner: unassigned
related_adrs: [ADR-0034, ADR-0025]
template_version: 1
id: ADR-0044
title: "Require credentials before entering the King James demo"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user approval of the demo credential workflow implementation plan."
implementation: implemented
supersedes: [ADR-0034]
superseded_by: []
---
# ADR-0044: Require credentials before entering the King James demo

## Decision

Require demo@gmail.com / demo123 before King James #QF4821 reaches the existing 1234 PIN screen. Keep the adapter isolated from Supabase and production authentication.

## Context and drivers

The prior adapter started signed in and inherited an unavailable sign-in method. The user explicitly approved an actual repeatable demo login/PIN/logout journey.

## Scope

- Applies to: DemoAuth, bootstrap notice, sign-in status and route/controller tests.
- Excludes: other decisions indexed in [the decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Approved plan | Matches requested behavior | Requires scoped checks | Selected by direct user authorization |
| Keep current behavior | No changes needed | Does not meet the approved requirement | Rejected |

## Consequences

- Benefit: coherent login, device reopening and sign-out behavior.
- Risk: public demo credentials and a synthetic flag are not real authentication.
- Mitigation: select demo adapters only in explicit preview configuration.

## Implementation and traceability

- [Work evidence](../changes/2026-10-19-demo-sign-in.md) records changes and checks.
- No new dependency or tool acquisition; existing packages and adapters reused.

## Verification

- Acceptance: tests prove the decision and denied/failure paths within its scope.
- Result: final checks recorded in the linked work evidence.
- Limits: no live backend, native biometric or release certification claim.

## Reversal and revisit

- Reversal: replace by a focused successor; clear only the namespaced demo flag.
- Revisit when: a real hosted demo or an authorized commit-preparation task is requested.

## References

- Approved user implementation plan and reopening preference, 2026-10-19.
- [Project rules](../../AGENTS.md).
