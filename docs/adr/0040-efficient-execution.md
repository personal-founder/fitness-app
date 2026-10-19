---
metadata_version: 1
purpose: Record the decision to avoid redundant and competing engineering work.
owner: unassigned
related_adrs: [ADR-0002, ADR-0039]
template_version: 1
id: ADR-0040
title: "Avoid redundant and competing engineering work"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user request to validate at the end, fix failures, and work efficiently."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0040: Avoid redundant and competing engineering work

## Decision

Batch related work, reuse valid evidence, serialize competing expensive jobs, and stop retrying unchanged blockers.

## Context and drivers

Concurrent builds and repeated checks consumed time without establishing usable new evidence.
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
- Costs and risks: Reduced repetition requires careful tracking of changed inputs and invalidated evidence.
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
