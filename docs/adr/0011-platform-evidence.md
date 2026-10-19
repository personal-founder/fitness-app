---
metadata_version: 1
purpose: Record the decision to combine matching evidence from trusted platform runners.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0011
title: "Combine matching evidence from trusted platform runners"
status: accepted
date: "2026-10-19"
decision_basis: "Direct implementation request and confirmed planning choices."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0011: Combine matching evidence from trusted platform runners

## Decision

Combine required checks only from explicitly trusted reports matching the exact candidate identity and pinned policy/toolchain.

## Context and drivers

A single Windows host cannot build the required Linux/macOS/iOS targets.

## Scope

- Applies to this verification/policy implementation.
- Excludes unrelated application repair, publication, and remote protection changes.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Implement the selected convention | Reproducible verification | Adds maintained tooling | Selected by user-approved plan |
| Keep manual/disconnected checks | Less setup | Drift and weak evidence | Rejected |

## Consequences

- Benefits: requirements and results become inspectable.
- Costs and risks: strict checks expose existing gaps and may block commits.
- Mitigation: preserve the strict gate and record actual failures instead of weakening it.

## Implementation and traceability

Reports expire under policy, cannot claim host-incompatible builds, and must reconcile their summary with check results. Import directories are explicit trust inputs, not cryptographic attestations.

## Verification

- Acceptance: Reject stale identities, malformed reports, impossible host claims, missing targets, and failed shards.
- Result: Local regression and implementation evidence recorded; see [implementation evidence](../changes/verification-implementation.md).
- Limits: Native builds and hosted CI must not be claimed passing without actual evidence.

## Reversal and revisit

- Reversal: use a successor ADR; restore prior local hook configuration where applicable.
- Revisit when: evidence shows this decision prevents safe, maintainable verification.

## References

- User-approved implementation plan in this chat, 2026-10-19.
- [Verification guide](../verification.md).
