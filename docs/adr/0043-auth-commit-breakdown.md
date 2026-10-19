---
metadata_version: 1
purpose: Record the decision to group the authentication milestone into five application commits.
owner: unassigned
related_adrs: [ADR-0034, ADR-0025]
template_version: 1
id: ADR-0043
title: "Group the authentication milestone into five application commits"
status: superseded
date: "2026-10-19"
decision_basis: "Direct user approval of the demo credential workflow implementation plan."
implementation: implemented
supersedes: []
superseded_by: [ADR-0046]
---
# ADR-0043: Group the authentication milestone into five application commits

## Decision

Recommend five logical application changesets, each with supporting tests/docs, without staging or committing any work.

## Context and drivers

The user requested a commit count covering UI/UX, sign-in/sign-up and related screen behavior. App files are currently untracked; prerequisite tooling is a separate concern.

## Scope

- Applies to: Commit recommendation in the demo work record; excludes authorization or readiness to commit.
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
