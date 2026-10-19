---
metadata_version: 1
purpose: Record how files expose their purpose, ownership, and governing decisions.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004]
template_version: 1
id: ADR-0005
title: "Associate concise format-safe metadata with every file"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user requirement; implementation details within this documentation task."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0005: Associate concise format-safe metadata with every file

## Decision

Associate metadata_version, purpose, owner, and related_adrs with every
maintained project file, using native headers or format-safe sidecars.

## Context and drivers

- The user requested metadata for each file, useful to people and agents.
- JSON, binary assets, generators, and exact-output templates cannot accept arbitrary headers.

## Scope

- Applies to repository-maintained source, docs, configuration, templates, and assets.
- Excludes editing Git internals and ignored compiler caches; provenance covers outputs.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Native headers plus sidecars | Discoverable without parser damage | Small maintenance cost | Selected |
| Embed the same header in every format | Uniform appearance | Breaks JSON/assets/templates | Rejected |
| Duplicate full Git history in headers | Looks comprehensive | Quickly becomes stale | Rejected |

## Consequences

- Benefits: purpose and decision links stay near the artifact.
- Costs and risks: stale links, false ownership, or invalid syntax can mislead users.
- Mitigation: use unassigned for unknown owners, check consumers, keep fields minimal.

## Implementation and traceability

- docs/file-metadata.md defines keys, placement, lifecycle, and provenance rules.
- Changed Markdown files receive front matter; .gitmessage uses a .meta.yaml sidecar.
- Existing untouched application/reference files remain a declared adoption backlog.
- No license selection or application source changes are introduced.

## Verification

- Acceptance: Each file changed here has valid metadata placement and resolving decision IDs.
- Result: PASS for metadata parsing, required sections, line limits, and local
  references; see [the recorded review](README.md#policy-validation).
- Limits: No full repository metadata retrofit or automated compliance tool is claimed.

## Reversal and revisit

- Reversal: Use a successor ADR; migrate metadata carefully without dropping required license notices.
- Revisit when: A consumer rejects metadata or lookup cost justifies an explicit directory manifest.

## References

- Direct user request in this chat, 2026-10-19: each file needs metadata.
- [Metadata rules](../file-metadata.md).
- [REUSE 3.3](https://reuse.software/spec-3.3/), checked 2026-10-19.
- [MADR metadata](https://adr.github.io/madr/decisions/0013-use-yaml-front-matter-for-meta-data.html), checked 2026-10-19.
