---
metadata_version: 1
purpose: Preserve the historical foundation record and point to focused successors.
owner: unassigned
related_adrs: [ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0001
title: "Adopt a modular authentication foundation"
status: superseded
date: "2026-10-19"
decision_basis: "Original user implementation request; normalized after the atomic-record policy changed during this task."
implementation: partial
supersedes: []
superseded_by: [ADR-0013, ADR-0014, ADR-0015, ADR-0016, ADR-0017, ADR-0018, ADR-0019, ADR-0020, ADR-0021, ADR-0022, ADR-0023, ADR-0024, ADR-0025, ADR-0026, ADR-0027, ADR-0028, ADR-0029, ADR-0030]
---
# ADR-0001: Adopt a modular authentication foundation

## Decision

The initial record selected a modular Flutter authentication foundation. Its
independent choices now have focused successor records; this historical record
does not override them. The original text is preserved unchanged in
[the archived source](../reference/legacy-auth-foundation-record.md).

## Context and drivers

The user selected the Flutter/Supabase stack and narrowed implementation to entry
views. The original combined record was written before the workspace adopted a
strict one-decision template during this same implementation session.

## Scope

- Applies to the original organizing decision and its traceable migration.
- Excludes current component choices, which the focused successors own.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Preserve source and link focused successors | Retains provenance and satisfies atomic records | More index entries | Selected under the new policy |
| Silently rewrite the original rationale | Fewer files | Loses historical context | Rejected |

## Consequences

- Original acceptance is not proof of completed or tested integrations.
- No historical approval is invented; normalization date is the actual task date.
- Current platform, security and validation limitations remain explicit.

## Implementation and traceability

- Original source is archived byte-for-byte; successors are indexed in [README](README.md).
- [Work record](../changes/2026-10-19-auth-foundation.md) maps implementation and checks.
- [Dependencies](../dependencies.md) owns acquisitions, separate from this historical record.

## Verification

- Acceptance: original source retained, successor IDs resolve, required sections present.
- Result: source preservation and metadata/link checks recorded in the work record.
- Limits: no new application test claim arises from this document normalization.

## Reversal and revisit

- Reversal: preserve the archive and use an explicit successor instead of deleting history.
- Revisit when a documented successor is replaced or an archival link changes.

## References

- [Original combined record](../reference/legacy-auth-foundation-record.md).
- [Atomic record policy](../atomic-and-adr-policy.md).
