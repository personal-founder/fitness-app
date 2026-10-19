---
metadata_version: 1
purpose: Record the decision to enforce verification through local Git hooks.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0010
title: "Enforce verification through local Git hooks"
status: accepted
date: "2026-10-19"
decision_basis: "Direct implementation request and confirmed planning choices."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0010: Enforce verification through local Git hooks

## Decision

Activate pre-commit and commit-msg hooks backed by the shared verifier, preserving the prior hooks configuration.

## Context and drivers

The user explicitly selected automatic local hooks.

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

Fail closed on failed or incomplete evidence. Store machine-specific SDK discovery only in local Git configuration; refuse to overwrite active unrelated hooks.

## Verification

- Acceptance: Temporary Git repositories must reject broken candidates and accept a valid controlled fixture; test install/removal.
- Result: Local regression and implementation evidence recorded; see [implementation evidence](../changes/verification-implementation.md).
- Limits: Native builds and hosted CI must not be claimed passing without actual evidence.

## Reversal and revisit

- Reversal: use a successor ADR; restore prior local hook configuration where applicable.
- Revisit when: evidence shows this decision prevents safe, maintainable verification.

## References

- User-approved implementation plan in this chat, 2026-10-19.
- [Verification guide](../verification.md).
