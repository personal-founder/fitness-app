---
metadata_version: 1
purpose: Record the bounded application commit and push authorization with native checks waived.
owner: unassigned
related_adrs: [ADR-0003, ADR-0025, ADR-0043]
template_version: 1
id: ADR-0046
title: "Commit the complete application milestone with a native-test waiver"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user instruction to commit and push after available verification, waiving unavailable native checks."
implementation: partial
supersedes: [ADR-0043]
superseded_by: []
---
# ADR-0046: Commit the complete application milestone with a native-test waiver

## Decision

Commit the currently interdependent application foundation and authentication
milestone together, then push to the existing origin/main. Run all available
checks; disclose unavailable native checks as BLOCKED and explicitly waived.

## Context and drivers

The earlier five-part recommendation preceded staging. The engineering standards
and verifier are already committed separately. All application sources remain new,
and their shared state, widgets, adapters and tests depend on one another. Splitting
them now into five snapshots would require constructing intermediate implementations.
The user explicitly requested actual commits and pushing after the staging request.

## Scope

- The remaining application milestone, supplied references and supporting records.
- One application commit, following the existing engineering commits.
- This execution only; no permanent weakening of the gate or native support claims.
- No deployment, paid resource, production database operation or history rewrite.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| One complete application snapshot | Tests the exact implemented state | Larger initial source commit | Selected to preserve working dependencies |
| Reconstruct five intermediate snapshots | Smaller historical steps | Extra code changes and repeated validation | Rejected for this initial import |
| Wait for all native runners | Full ordinary gate evidence | Prevents the explicitly requested action | User waived unavailable native checks |

## Consequences

- All runnable checks must pass; failures are fixed before committing.
- Native builds/integration and hardware checks remain visibly unverified.
- The installed hooks require unavailable native evidence. Only this authorized
  commit invocation may override hooks after independent staged checks and message
  validation. The permanent hooks, configuration and validators remain unchanged.
- Publish only reviewed repository inputs; ignore local secrets and build evidence.

## Implementation and traceability

- Preserve the current public noreply Git identity and existing remote.
- Generate the full message ledger from indexed blobs against the actual parent.
- Keep tree-specific reports outside the committed tree to avoid self-reference.
- Push normally without force and verify that the remote branch matches local HEAD.

## Verification

- Acceptance: available checks pass for the indexed snapshot, full message and
  ledger validate, and normal push establishes matching remote history.
- Result: actual command outcomes and candidate identity belong in the commit
  message and ignored output/application-commit/ evidence, not a forecast here.
- Limits: this exception is not release readiness or successful native testing.

## Reversal and revisit

- Reversal: an authorized ordinary revert; do not rewrite shared history.
- Revisit when: future commits need an exception or native runners become available.

## References

- User instructions on 2026-10-19: waive unavailable platform checks, ensure other
  required tests work, then make the commits and push them.
- [Commit standard](../commit-standard.md).
- [Previous recommendation](0043-auth-commit-breakdown.md).
