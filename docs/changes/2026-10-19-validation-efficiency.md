---
metadata_version: 1
purpose: Record the requested validation timing and efficient execution rules.
owner: unassigned
related_adrs: [ADR-0039, ADR-0040, ADR-0041]
---
# Validation scheduling and efficient execution

The user requested routine testing/validation at the end of work, followed by
fixes, and an explicit efficiency rule. Existing principles, the shared verifier,
and the mandatory ADR template were reused. No new dependency or download.

| Changed path | Governing decision | Application |
| --- | --- | --- |
| AGENTS.md | ADR-0039, ADR-0040 | Route the work loop to both canonical rules |
| docs/core-principles.md | ADR-0039, ADR-0040 | Define scheduling, fix loops, and efficient execution |
| docs/verification.md | ADR-0039, ADR-0040 | Link scheduling without altering mandatory checks |
| docs/adr/README.md and the two new ADRs | ADR-0039, ADR-0040 | Record two independent process choices |
| This work record | ADR-0039, ADR-0040 | Preserve scope, coverage, actual checks, and manual enforcement limits |
| config/policy/requirements/ | ADR-0006, ADR-0008 reused | Refresh source-linked records without asserting compliance |

Routine checks follow the completed coherent edit batch. Small prerequisite checks
and justified risk-reducing reproductions remain permitted early. Failed checks
are fixed before affected checks are repeated. Required commit/release gates and
evidence identity rules are unchanged; blockers cannot be waived for speed.

## Verification and enforcement

Focused document validation checks metadata, ADR schema/headings/IDs/index,
references, file sizes, instruction size, and requirement-register freshness.
Results are recorded under ignored output/validation-efficiency/.
Actual result: all focused document checks passed (exit 0), including changed-file
metadata/ADR/link/length checks, policy consistency, and 376 source-linked records
remaining explicitly unverified. Combined root/global instructions: 31,935 bytes.
Scheduling and efficiency remain manual review obligations, not new automated
enforcement. Performance savings remain unverified until later tasks measure them.
Application tests/builds are not relevant to this instruction-only handoff;
no application behavior or executable verifier changed. The existing complete
gate still applies before any future authorized commit. No Git staging, commit,
push, deployment, or remote setting changes were made.

## Local commit preparation

The original task results above describe its larger working-copy snapshot.
The user subsequently authorized three local engineering commits and explicitly
approved the one-time blocked-verification exception in
[ADR-0041](../adr/0041-three-local-commit-exception.md).
The engineering-only final candidate registers 374 mandatory statements; the
historical count of 376 includes instructions retained only in the application
working copy. Every statement remains visibly unverified.

Candidate metadata, ADR, link, length, policy consistency, and commit-ledger checks
passed. The unchanged tooling and locked dependency baseline passed 38 isolated
tests, formatting, and analysis. These checks do not satisfy the blocked complete
application/native gate. Application work remains outside the three commits;
permanent hook settings and gate policy remain unchanged. Complete per-file line
counts, candidate trees, parents, exclusions, and actual evidence are in the commit
bodies and ignored output/commit-preparation/ records. No publication is authorized.
