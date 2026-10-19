---
metadata_version: 1
purpose: Define concise file metadata without breaking native formats or duplicating history.
owner: unassigned
related_adrs: [ADR-0005, ADR-0008]
---

Executable fields, statuses, commit contracts, and limits are defined in the
[machine-readable policy](../config/engineering-policy.json). Read its referenced
registries before changing this standard or its validators.
# File metadata standard

Every repository-owned file MUST have associated metadata. For new/edited files,
agents add or update it automatically in the same change. Existing untouched files
remain an explicit adoption backlog; this policy does not claim a completed retrofit.
Do not modify unrelated application code just to add headers during a narrow task.

## Shared required fields

| Key | Type | Meaning |
| --- | --- | --- |
| `metadata_version` | Integer | `1` for this project schema, not the file revision |
| `purpose` | String | One sentence explaining the file's responsibility |
| `owner` | String | Verified responsible team/role, or `unassigned`; never invent a person |
| `related_adrs` | String list | Governing/relevant stable IDs, such as `[ADR-0005]` |

These fields are project conventions, not an industry-wide universal schema.
Use concise facts. If an imported legacy file has no established governing ADR,
use `[]` and record the gap; new choices still require ADR coverage. A file that
implements several decisions may list several IDs without bundling those decisions.

Optional fields only when they add information: `source` (provenance),
`generated_by` (generator and reproducible command/reference), `data_classification`
(established classification), `replaces`, `validation` (stable check reference).
Do not invent ownership, licensing, approvals, classification, or provenance.

## Placement by file format

| Format | Placement |
| --- | --- |
| Maintained Markdown | YAML front matter at the beginning, if the consumer supports it |
| Dart, TypeScript, JavaScript, other code | Short native comment block near the top |
| Shell, Python, YAML, TOML, SQL | Valid native comments; preserve required first-line directives |
| JSON, binary assets, exact-output templates, unsupported parsers | Adjacent `<filename>.meta.yaml` sidecar |
| Generated/vendor/imported originals | Preserve originals; use a sidecar with source/generator evidence |
| Large uniform generated/vendor trees | Explicit directory manifest with unambiguous path coverage; no blanket unknown ownership |

Preserve shebangs, encoding declarations, mandatory directives, existing copyright,
tool-generated banners, and parser requirements. Do not add arbitrary fields to
strict schemas or put comments in JSON. If front matter is unsupported, use a
sidecar rather than changing rendering or semantics. Flutter's `.metadata` is a
Flutter-managed file; do not repurpose it as this metadata registry.

Code example (project keys, not license declarations):

```dart
// metadata_version: 1
// purpose: Convert workout durations without changing their units.
// owner: unassigned
// related_adrs: [ADR-NNNN]
```

Replace the illustrative ID with a real decision. These comments also satisfy the
file-purpose note requirement; do not add a second redundant banner. Add targeted
inline explanations for non-obvious logic as required by the engineering policy.

Sidecars contain the shared fields plus `target`, a relative path from the sidecar
to the file described. A sidecar describes that file; its role and relationship are
intrinsic, so it does not need a recursive sidecar of its own. Directory manifests
must document matching/precedence, cover every intended file, and detect unmatched
or conflicting entries; prefer simple sidecars until a manifest is warranted.

## Stable, private, maintainable information

- Do not duplicate filename, LOC count, every import, changelog, author list, commit
  hash, or "last modified" timestamp in every header. Git/tools own volatile history.
  ADR decision dates and schema/template versions have distinct meanings and remain.
- Keep personal email addresses, credentials, sensitive paths, health records,
  internal tokens, and private URLs out of metadata. Metadata can become public.
- On rename, update the sidecar target and links; move/remove its sidecar with the
  described file. On responsibility change, update purpose and governing ADRs.
- Required license/copyright notices remain authoritative. When verified licensing
  is available, use recognized `SPDX-License-Identifier` and copyright notices.
  Do not select a license, claim copyright ownership, or overwrite third-party
  notices merely to satisfy this policy. Unknown licensing is a recorded gap.
- REUSE `.license` sidecars/`REUSE.toml` are specifically for licensing; our
  `.meta.yaml` operational sidecars do not establish REUSE/SPDX compliance.
- Metadata counts toward physical line limits, including the 249-line ADR maximum.
  Keep headers small; they are not a substitute for readable code or detailed ADRs.
- Local ignored build caches and `.git` internals are not maintained project files.
  Record shipped/generated artifacts through their source and provenance rather
  than editing every temporary compiler output. Checked-in assets still need coverage.

## Review

For every changed file, verify valid syntax/placement, required keys, truthful
values, resolving ADR IDs, and no contradictory header/sidecar. Check sidecar
targets exist. Use one metadata source per file, apart from required license notices.
Ensure parsers/build consumers still accept the file. Missing metadata is a review
finding, not proof the entire app is broken. It must be resolved for changed files
before completion/commit or recorded as a specific immutable-source constraint.

## Research

Checked 2026-10-19:

- [MADR YAML metadata](https://adr.github.io/madr/decisions/0013-use-yaml-front-matter-for-meta-data.html)
  supports structured document metadata, with renderer limitations acknowledged.
- [REUSE specification 3.3](https://reuse.software/spec-3.3/) defines established
  per-file licensing headers and alternatives for uncommentable files. We reuse
  the safe-placement principle, not its compliance claim for custom operational keys.

No external tool installation is necessary for these conventions. Automated linting
may be added with tests later; do not describe this prose as an installed validator.
