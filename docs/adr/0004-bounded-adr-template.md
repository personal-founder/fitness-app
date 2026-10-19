---
metadata_version: 1
purpose: Record the required structure and strict size bound for every complete ADR.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0005]
template_version: 1
id: ADR-0004
title: "Use one ADR template with a 249-line maximum"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user requirement; implementation details within this documentation task."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0004: Use one ADR template with a 249-line maximum

## Decision

Use docs/adr/adr-template.md for every new ADR and keep the complete record
at 249 physical lines or fewer, including metadata, blank lines, and comments.

## Context and drivers

- The user requested one mandatory format and a full ADR below 250 LOC.
- General Markdown limits allowed longer files; ADRs need a stricter specific rule.

## Scope

- Applies to new ADRs and records normalized under the new policy.
- Excludes long supporting evidence, which is linked rather than embedded.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Fixed concise template and strict cap | Predictable review | Requires editing | Selected per user request |
| Free-form records with general Markdown limits | Flexible | Inconsistent and too long | Rejected |

## Consequences

- Benefits: humans and tools find decision, rationale, impact, and checks consistently.
- Costs and risks: a cap can encourage missing reasoning or compressed lines.
- Mitigation: retain essential rationale, link evidence, and prohibit compression.

## Implementation and traceability

- Template front matter defines identity, status, date, authority, and relationships.
- Nine body sections separate the choice from rationale, evidence, and reversal.
- docs/engineering-standards.md makes the 249-line ADR rule override 400/800 limits.
- The format adapts ADR concepts; no third-party template text/package was installed.

## Verification

- Acceptance: All four new records match required headings/keys and contain fewer than 250 lines.
- Result: PASS for metadata parsing, required sections, line limits, and local
  references; see [the recorded review](README.md#policy-validation).
- Limits: Existing ADR-0001 is a recorded legacy gap, not silently declared compliant.

## Reversal and revisit

- Reversal: Publish a successor template decision and a truthful migration plan; preserve old IDs.
- Revisit when: Repeated omissions show the schema needs a versioned improvement within the cap.

## References

- Direct user request in this chat, 2026-10-19: a mandatory full ADR below 250 LOC.
- [Template](adr-template.md).
- [MADR structure](https://adr.github.io/madr/decisions/adr-template.html), checked 2026-10-19.
