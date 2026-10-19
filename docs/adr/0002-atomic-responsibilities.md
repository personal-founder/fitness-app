---
metadata_version: 1
purpose: Record the choice to organize work around one cohesive responsibility.
owner: unassigned
related_adrs: [ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0002
title: "Use atomic responsibility boundaries"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user requirement; implementation details within this documentation task."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0002: Use atomic responsibility boundaries

## Decision

Use one independently understandable responsibility per unit and exactly one
independent decision per ADR. Reusable units may support multiple callers.

## Context and drivers

- The user explicitly requested ATOMIC behavior, especially one decision per ADR.
- Existing root guidance had grown; it mixed routing with detailed reusable rules.

## Scope

- Applies to functions, modules, changes, ADRs, and documentation boundaries.
- Excludes artificial one-function files and duplication of shared components.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Cohesive units with explicit boundaries | Reviewable, reusable | Requires judgment | Selected per user requirement |
| Broad multi-decision bundles | Fewer artifacts | Coupled review and replacement | Rejected for new ADRs |

## Consequences

- Benefits: decisions can be understood and replaced independently.
- Costs and risks: over-splitting can create indirection and duplicated logic.
- Mitigation: group cohesive reusable behavior; allow indexes to link focused records.

## Implementation and traceability

- Root AGENTS.md routes to docs/atomic-and-adr-policy.md.
- Existing DRY/KISS/Boy Scout/craftsmanship/testing detail is preserved in
  docs/core-principles.md to keep root instructions loadable.
- ADR-0001 remains historical; its bundled decisions need evidence-based migration.

## Verification

- Acceptance: Each new ADR answers one question; moved guidance remains intact and linked.
- Result: PASS for metadata parsing, required sections, line limits, and local
  references; see [the recorded review](README.md#policy-validation).
- Limits: No application refactor or retrospective ADR migration is performed.

## Reversal and revisit

- Reversal: Replace this policy with a successor ADR and update routing; no data migration.
- Revisit when: Boundaries create repeated fragmentation or make a decision impossible to review.

## References

- Direct user request in this chat, 2026-10-19: ATOMIC and one ADR per decision.
- [ADR community](https://adr.github.io/), checked 2026-10-19.
- [Policy](../atomic-and-adr-policy.md).
