---
metadata_version: 1
purpose: Record the decision to batch routine validation at the end of coherent work.
owner: unassigned
related_adrs: [ADR-0002, ADR-0007]
template_version: 1
id: ADR-0039
title: "Batch routine validation at the end of coherent work"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user request to validate at the end, fix failures, and work efficiently."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0039: Batch routine validation at the end of coherent work

## Decision

Defer routine checks until edits are ready, then diagnose failures and rerun affected checks. Permit only justified small early checks.

## Context and drivers

Repeated full verification during unfinished edits caused avoidable rebuilds and stale results.
The user explicitly requested this process change after the verifier implementation.

## Scope

- Applies to task execution and documented agent instructions.
- Excludes changes to verifier code, mandatory targets, hooks, and release gates.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Apply the requested process | Less avoidable work is expected | Requires judgment and input tracking | Selected by direct user instruction |
| Repeat broad checks throughout edits | Frequent feedback | Rebuilds and stale evidence | Rejected as the default |

## Consequences

- Benefits: expected reduction in redundant work; no measured saving claimed.
- Costs and risks: Earlier focused checks can prevent expensive rework, but must stay narrowly justified.
- Mitigation: keep justified early checks, required final gates, and explicit blockers.

## Implementation and traceability

- AGENTS.md routes to the canonical rules in docs/core-principles.md.
- docs/verification.md links the procedure without changing executable checks.
- [Work record](../changes/2026-10-19-validation-efficiency.md) maps files and evidence.

## Verification

- Acceptance: instructions define the process and preserve mandatory gates.
- Result: focused document/policy checks recorded in the linked work record.
- Limits: scheduling is manually enforced; actual time savings remain unverified.

## Reversal and revisit

- Reversal: supersede this decision and update its instruction links.
- Revisit when: task evidence shows delayed feedback or omitted required verification.

## References

- Direct user request in this chat, 2026-10-19.
- [Core rules](../core-principles.md).
