---
metadata_version: 1
purpose: Supply the mandatory structure for one focused decision record.
owner: unassigned
related_adrs: [ADR-0004]
template_version: 1
id: ADR-NNNN
title: "<One specific decision>"
status: proposed
date: "<YYYY-MM-DD>"
decision_basis: "<Direct requirement, delegated authority, or pending approval>"
implementation: planned
supersedes: []
superseded_by: []
---
# ADR-NNNN: <One specific decision>

## Decision

<State exactly one choice and its boundary in one or two sentences.>

## Context and drivers

- <Problem/current behavior and evidence.>
- <Requirements, constraints, and why this choice is needed.>

## Scope

- Applies to: <Precise responsibility and affected surfaces.>
- Excludes: <Adjacent choices covered elsewhere.>

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| <Selected approach> | <Concrete benefit> | <Tradeoff> | <Why selected> |
| <Real alternative or status quo> | <Benefit> | <Tradeoff> | <Why not selected> |

<If a direct requirement leaves no permitted alternative, say so honestly.>

## Consequences

- Benefits: <Expected gains, distinguished from measured results.>
- Costs and risks: <Maintenance, compatibility, security/privacy, or N/A with reason.>
- Mitigation: <How relevant risks are controlled.>

## Implementation and traceability

- <Affected paths/contracts and implementation status; link detailed work evidence.>
- <Related ADRs, dependency/download records, or N/A with reason.>

## Verification

- Acceptance: <Observable evidence that would confirm this decision is followed.>
- Result: <Actual command/review outcome and evidence location, or pending/blocked.>
- Limits: <What has not been verified; do not equate acceptance with completion.>

## Reversal and revisit

- Reversal: <Safe undo/replacement path and consequences.>
- Revisit when: <Concrete condition that would justify reconsideration.>

## References

- <Existing request/specification/source/evidence links and relevant dates.>

<!-- Authoring instructions: remove this block from completed records.
Follow ../atomic-and-adr-policy.md. Keep every heading and required metadata key.
Change purpose to describe this decision; set template_version: 1 and a unique ID.
Set related_adrs to real related records; do not retain a self-reference by accident.
Use a truthful owner or unassigned, actual date, status, authority and implementation.
Fill every section; concise N/A with a reason is valid. Do not invent evidence.
Exactly one decision; at most 249 physical lines including front matter and blanks.
Link long supporting evidence; retain the core choice and rationale in this record.
Update README.md with the same ID/title/status; add change-to-ADR coverage.
-->
