---
metadata_version: 1
purpose: Record source-preserving isolation for working-copy verification.
owner: unassigned
related_adrs: [ADR-0009]
template_version: 1
id: ADR-0031
title: "Isolate working-copy checks from user source"
status: accepted
date: "2026-10-19"
decision_basis: "The approved plan requires preserving user work during verification."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0031: Isolate working-copy checks from user source

## Decision

Copy working inputs into an owned temporary workspace before dependency restoration,
tests, or builds. Check copied and original bytes for unexpected changes.

## Context and drivers

Native tools and dependency restoration can regenerate source. Running them directly
in user work could silently repair a broken candidate or overwrite unrelated edits.

## Scope

- Applies to working-copy verification; staged isolation remains ADR-0009.
- Excludes hidden local configuration, publication, and unrelated app repair.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Isolated working copy | Preserves user work and exact inputs | Additional temporary disk/build work | Selected for the preservation requirement |
| Run restoration in place | Less copying | Can mutate source while validating it | Rejected |

## Consequences

- Benefits: verification cannot silently normalize original source files.
- Costs and risks: fresh builds cost time; ignored environment inputs are unavailable.
- Mitigation: use locked shared dependency caches and explicit configuration inputs.

## Implementation and traceability

- tool/verification/working.dart exports inputs and checks restoration changes.
- Context checks source/copy digests; only owned temporary directories are removed.
- Existing hashing and snapshot conventions are reused.

## Verification

- Acceptance: regeneration in the copy is rejected while the original stays unchanged.
- Result: see test/tooling/isolation_test.dart and the final implementation evidence.
- Limits: a passing fixture does not establish native/device release readiness.

## Reversal and revisit

- Reversal: supersede this decision and demonstrate equivalent preservation guarantees.
- Revisit when: measurements justify a safe immutable-cache optimization.

## References

- [Implementation evidence](../changes/verification-implementation.md).
- [Verification guide](../verification.md).
