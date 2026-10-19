---
metadata_version: 1
purpose: Index the engineering decisions committed in this change sequence.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005, ADR-0041]
---
# Decision index

Read [the policy](../atomic-and-adr-policy.md) and use [the template](adr-template.md).
Exactly one decision belongs in each ADR; complete records stay below 250 lines.

| ID | Decision | Status |
| --- | --- | --- |
| ADR-0002 | [Use atomic responsibility boundaries](0002-atomic-responsibilities.md) | accepted |
| ADR-0003 | [Capture every decision and change automatically](0003-automatic-decision-coverage.md) | accepted |
| ADR-0004 | [Use one ADR template with a 249-line maximum](0004-bounded-adr-template.md) | accepted |
| ADR-0005 | [Associate concise format-safe metadata with every file](0005-file-metadata.md) | accepted |
| ADR-0041 | [Authorize three local commits with blocked verification](0041-three-local-commit-exception.md) | accepted |

## Existing adoption gaps

Application decisions and implementation belong to a separate workstream and are
not introduced by these engineering commits. No full-repository compliance claim.

## Policy validation

2026-10-19: local Python with the already installed PyYAML parsed all 13 changed
metadata-bearing documents/sidecars. Required fields, unique/resolving ADR IDs,
template sections, line limits, local links/anchors, and the sidecar target passed.
The four new ADRs are 69–71 lines; the template is 76 lines. Root plus active global
instructions total 31,926 bytes, within the default 32 KiB loading budget.
Review confirmed the change-to-ADR mapping above; the commit template still has its
12 required sections. No application code was changed by this task and no app
build/test result is asserted. No tools/packages were installed or Git commits made.

## Commit authorization

[ADR-0041](0041-three-local-commit-exception.md) records the explicit exception
for this three-commit sequence. It does not change normal gate requirements.
