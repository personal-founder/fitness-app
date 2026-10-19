---
metadata_version: 1
purpose: Record the decision to require evidence and enforcement status for mandatory rules.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0006
title: "Require evidence and enforcement status for mandatory rules"
status: accepted
date: "2026-10-19"
decision_basis: "Direct implementation request and confirmed planning choices."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0006: Require evidence and enforcement status for mandatory rules

## Decision

A documented requirement is not implemented by documentation alone. Track its verification method, evidence, enforcement, and unverified state.

## Context and drivers

The user requested an evidence rule and durable tracking of eight improvements.

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

Maintain a source-linked requirement inventory and eight-item tracker. Existing unknowns remain unverified; inventory completeness is distinct from compliance.

## Verification

- Acceptance: Review requirement inventory freshness, tracker entries, and evidence references.
- Result: Local regression and implementation evidence recorded; see [implementation evidence](../changes/verification-implementation.md).
- Limits: Native builds and hosted CI must not be claimed passing without actual evidence.

## Reversal and revisit

- Reversal: use a successor ADR; restore prior local hook configuration where applicable.
- Revisit when: evidence shows this decision prevents safe, maintainable verification.

## References

- User-approved implementation plan in this chat, 2026-10-19.
- [Verification guide](../verification.md).
