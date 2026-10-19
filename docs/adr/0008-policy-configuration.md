---
metadata_version: 1
purpose: Record the decision to define machine-readable policy values once.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0008
title: "Define machine-readable policy values once"
status: accepted
date: "2026-10-19"
decision_basis: "Direct implementation request and confirmed planning choices."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0008: Define machine-readable policy values once

## Decision

Use a JSON policy entry point and referenced registries as the executable source for limits, schemas, pins, commands, targets, and exceptions.

## Context and drivers

The user requested machine-readable configuration rather than repeated validator constants.

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

Use standard-library JSON bootstrap; promote locked yaml 3.1.4 to a direct development dependency for real YAML parsing. Retain existing cryptography for digests.

## Verification

- Acceptance: Reject missing/unknown keys, unsupported versions, wrong types, bad references, and invalid commands.
- Result: Local regression and implementation evidence recorded; see [implementation evidence](../changes/verification-implementation.md).
- Limits: Native builds and hosted CI must not be claimed passing without actual evidence.

## Reversal and revisit

- Reversal: use a successor ADR; restore prior local hook configuration where applicable.
- Revisit when: evidence shows this decision prevents safe, maintainable verification.

## References

- User-approved implementation plan in this chat, 2026-10-19.
- [Verification guide](../verification.md).
