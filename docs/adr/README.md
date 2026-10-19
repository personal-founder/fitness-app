---
metadata_version: 1
purpose: Index the engineering decisions committed in this change sequence.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005, ADR-0006, ADR-0007, ADR-0008, ADR-0009, ADR-0010, ADR-0011, ADR-0012, ADR-0031, ADR-0039, ADR-0040, ADR-0041]
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
| ADR-0006 | [Require evidence and enforcement status for mandatory rules](0006-requirement-evidence.md) | accepted |
| ADR-0007 | [Use one cross-platform verification command](0007-shared-verifier.md) | accepted |
| ADR-0008 | [Define machine-readable policy values once](0008-policy-configuration.md) | accepted |
| ADR-0009 | [Verify the exact staged candidate in isolation](0009-isolated-staged-verification.md) | accepted |
| ADR-0010 | [Enforce verification through local Git hooks](0010-local-verification-hooks.md) | accepted |
| ADR-0011 | [Combine matching evidence from trusted platform runners](0011-platform-evidence.md) | accepted |
| ADR-0012 | [Run the shared gate across suitable CI hosts](0012-verification-ci.md) | accepted |
| ADR-0031 | [Isolate working-copy checks from user source](0031-working-copy-isolation.md) | accepted |
| ADR-0039 | [Batch routine validation at the end of coherent work](0039-end-of-work-validation.md) | accepted |
| ADR-0040 | [Avoid redundant and competing engineering work](0040-efficient-execution.md) | accepted |
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
