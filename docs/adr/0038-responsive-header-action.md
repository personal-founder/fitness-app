---
metadata_version: 1
purpose: Record the narrow-screen large-text header action correction.
owner: unassigned
related_adrs: [ADR-0013, ADR-0025]
template_version: 1
id: ADR-0038
title: "Allow the entry header action to wrap at large text sizes"
status: accepted
date: "2026-10-19"
decision_basis: "Authorized nearby accessibility fix discovered during requested validation."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0038: Allow the entry header action to wrap at large text sizes

## Decision

Constrain the header action with Flexible and keep a minimum gap from the menu,
allowing its text to wrap without horizontal overflow.

## Context and drivers

The signed-in 320-pixel viewport at 200% text overflowed by 17 pixels. The original
signed-out responsive tests did not exercise the wider Sign Out label.

## Scope

- Applies to: entry_header.dart and its large-text regression test.
- Excludes: typography changes, smaller touch targets, or a new navigation design.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Flexible action | Preserves text scaling and existing layout | May wrap at narrow sizes | Selected for intrinsic sizing |
| Shrink or clip text | Fits one line | Discards accessibility scaling or content | Rejected |

## Consequences

- Benefit: keeps menu and account actions reachable with large text.
- Risk: the action may become taller at large scaling.
- Mitigation: keep the header in the existing scrolling entry composition.

## Implementation and traceability

- [Work evidence](../changes/2026-10-19-pin-theme-qr.md) records the regression.
- No dependency, backend, or data change is required.

## Verification

- Acceptance: the signed-in 320px/200% test has no RenderFlex overflow.
- Result: final regression run recorded in the work evidence.
- Limits: viewport simulation does not establish screen-reader/device coverage.

## Reversal and revisit

- Reversal: replace with another intrinsically sized accessible header.
- Revisit when: more actions or approved navigation changes require a new layout.

## References

- [Approved composition](0013-approved-entry-composition.md).
- [Engineering rules](../../AGENTS.md).
