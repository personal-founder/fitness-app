---
metadata_version: 1
purpose: Record the decision to remember only the synthetic demo signed-in flag.
owner: unassigned
related_adrs: [ADR-0034, ADR-0025]
template_version: 1
id: ADR-0042
title: "Remember only the synthetic demo signed-in flag"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user approval of the demo credential workflow implementation plan."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0042: Remember only the synthetic demo signed-in flag

## Decision

Use the existing SharedPreferencesAsync dependency for one namespaced boolean. Persist before publishing sign-in/sign-out success; restore signed-in demos into the PIN phase.

## Context and drivers

The user selected Return to PIN on reopening. First use starts at login and sign-out must survive refresh. No password, PIN, token or real session is persisted here.

## Scope

- Applies to: DemoSessionStore, main bootstrap, read/write failure and restoration tests.
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
