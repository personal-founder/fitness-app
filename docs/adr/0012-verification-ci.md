---
metadata_version: 1
purpose: Record the decision to run the shared gate across suitable CI hosts.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0012
title: "Run the shared gate across suitable CI hosts"
status: accepted
date: "2026-10-19"
decision_basis: "Direct implementation request and confirmed planning choices."
implementation: partial
supersedes: []
superseded_by: []
---
# ADR-0012: Run the shared gate across suitable CI hosts

## Decision

Replace duplicated Flutter workflow checks with Linux, Windows, and macOS shards and a strict aggregate job.

## Context and drivers

All six targets remain required, and existing CI covered only Ubuntu/web.

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

Workers may finish with BLOCKED for other hosts; only the complete aggregate can pass. No publication, signing credentials, or branch-protection change is included.

## Verification

- Acceptance: Parse workflow configuration locally and test shard aggregation with fixtures; hosted runs remain unverified until executed.
- Result: Pending final task validation; see [implementation evidence](../changes/verification-implementation.md).
- Limits: Native builds and hosted CI must not be claimed passing without actual evidence.

## Reversal and revisit

- Reversal: use a successor ADR; restore prior local hook configuration where applicable.
- Revisit when: evidence shows this decision prevents safe, maintainable verification.

## References

- User-approved implementation plan in this chat, 2026-10-19.
- [Verification guide](../verification.md).
