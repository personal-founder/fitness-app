---
metadata_version: 1
purpose: Record automatic ADR coverage for every independent choice or change.
owner: unassigned
related_adrs: [ADR-0002, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0003
title: "Capture every decision and change automatically"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user requirement; implementation details within this documentation task."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0003: Capture every decision and change automatically

## Decision

Agents must automatically record every new decision or independent change in
its own ADR. Applying an existing decision requires an explicit coverage link.

## Context and drivers

- The user requested automatic ADRs for every decision/change, not only architecture.
- Earlier guidance excluded small choices and could leave rationale unrecorded.

## Scope

- Applies to code, tests, docs, dependencies, policy, operations, and deferrals.
- Excludes duplicate records for mechanical applications of existing decisions.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Automatic coverage for all choices | Complete traceability | More documentation | Selected by direct requirement |
| Capture only major architecture | Lower overhead | Omits requested small decisions | Rejected |

## Consequences

- Benefits: every change has a traceable governing rationale.
- Costs and risks: automatic capture can produce duplicate or invented decisions.
- Mitigation: search first, reuse decisions explicitly, and avoid recursive ADR creation.

## Implementation and traceability

- docs/atomic-and-adr-policy.md defines capture, reuse, authority, and status rules.
- docs/commit-standard.md and .gitmessage require per-file ADR coverage.
- docs/adr/README.md indexes new records, current coverage, and legacy gaps.
- No packages or deliberate external artifacts were acquired.

## Verification

- Acceptance: Every file in this policy change maps to one or more actual ADRs.
- Result: PASS for metadata parsing, required sections, line limits, and local
  references; see [the recorded review](README.md#policy-validation).
- Limits: Legacy decisions are not automatically reconstructed; unknown history stays unknown.

## Reversal and revisit

- Reversal: Supersede this capture rule; retain prior records and revise commit requirements.
- Revisit when: Duplicate records or uncovered work show that capture boundaries need clarification.

## References

- Direct user request in this chat, 2026-10-19: create ADRs automatically for all decisions/changes.
- [MADR](https://adr.github.io/madr/), checked 2026-10-19.
- [Coverage index](README.md).
