---
metadata_version: 1
purpose: Record the bounded authorization for three local commits with blocked checks.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005]
template_version: 1
id: ADR-0041
title: "Authorize three local commits with blocked verification"
status: accepted
date: "2026-10-19"
decision_basis: "Explicit user approval of the one-time exception after blockers were disclosed."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0041: Authorize three local commits with blocked verification

## Decision

Allow exactly three local commits for this conversation's engineering work despite
blocked verification. Preserve permanent gate policy and disclose actual results.

## Context and drivers

The user requested three logically ordered commits, then explicitly approved a
one-time exception after the missing native verification evidence was explained.
The application foundation belongs to another concurrent conversation and is not
part of these commits. Mixed files require selective staging.

## Scope

- Applies to engineering standards, verification tooling, and efficiency policy.
- Excludes application features, remote actions, publication, and future commits.
- Native checks, missing application inputs, and unavailable matching evidence
  remain visibly blocked rather than being represented as successful.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Three explicitly exempted local commits | Preserves reviewable work now | Complete app/native gate remains blocked | Selected by explicit user approval |
| Wait for the entire application gate | Retains ordinary gate behavior | Cannot complete requested local commits now | User authorized the bounded exception |

## Consequences

- Benefits: focused history and per-file evidence without unrelated app features.
- Costs and risks: these commits do not establish a working six-target application.
- Mitigation: record blocked checks, isolate staged content, validate available
  documentation/tooling, and leave the normal hook configuration unchanged.

## Implementation and traceability

- Commit order: engineering standards; shared verification; efficient execution.
- Use staged blobs for mixed files while preserving their working copies.
- Only the three authorized commit invocations may override local hooks.
- Reuse the existing commit template, Git line counts, and atomic coverage rules.
- Commit bodies record candidate trees, parents, actual evidence, and exceptions.

## Verification

- Acceptance: exactly three local commits; complete ledgers; unrelated work retained.
- Result: execution evidence and messages retained in ignored output/commit-preparation/.
- Limits: full platform/app checks remain blocked; no release readiness is asserted.

## Reversal and revisit

- Reversal: review and authorize ordinary revert commits; retain unrelated work.
- Revisit when: any further exception is requested; this grant does not extend.

## References

- Explicit user answer on 2026-10-19: Yes, authorize a one-time exception.
- [Commit standard](../commit-standard.md).
- [Automatic coverage policy](../atomic-and-adr-policy.md).
