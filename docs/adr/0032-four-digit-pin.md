---
metadata_version: 1
purpose: Record the decision to require four-digit app PINs distinct from tag suffixes.
owner: unassigned
related_adrs: [ADR-0025, ADR-0026, ADR-0027]
template_version: 1
id: ADR-0032
title: "Require four-digit app PINs distinct from tag suffixes"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user approval of the PIN, theme and QR implementation plan."
implementation: implemented
supersedes: [ADR-0018]
superseded_by: []
---
# ADR-0032: Require four-digit app PINs distinct from tag suffixes

## Decision

Require four numeric digits and confirmation after verified sign-in; reject the account tag suffix at the UI and native enrollment boundaries.

## Context and drivers

The user specifies four digits, permits 1234, and forbids 4821 for #QF4821. Existing salt, KDF, secure storage and throttle remain.

## Scope

- Applies to: lib/core/security/ and lib/features/auth/.
- Excludes: independent choices in the [decision index](README.md).

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Approved plan | Matches the requested behavior | Needs scoped tests and platform validation | Selected under direct implementation authorization |
| Retain previous behavior | No migration work | Does not meet the approved request | Rejected by the user requirement |

## Consequences

- Benefit: the observable behavior matches the approved plan.
- Risk: local tests cannot establish live backend or biometric-device correctness.
- Mitigation: isolate synthetic fixtures and retain explicit unsupported-target limits.

## Implementation and traceability

- [Work evidence](../changes/2026-10-19-pin-theme-qr.md) owns file coverage and results.
- [Dependencies](../dependencies.md) owns package acquisition and integrity records.

## Verification

- Acceptance: tests cover this decision's success, denial and lifecycle behavior.
- Result: controller, widget and persistence regression evidence is recorded in the work log;
  real hardware/backend verification remains blocked.
- Limits: no publication, native hardware, or production-readiness claim.

## Reversal and revisit

- Reversal: replace through a focused successor; never weaken authentication silently.
- Revisit when: verified platform constraints or an approved product change require it.

## References

- User-approved implementation plan, 2026-10-19, recorded in the work evidence.
- [Engineering rules](../../AGENTS.md).
