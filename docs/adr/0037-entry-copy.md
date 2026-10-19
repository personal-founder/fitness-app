---
metadata_version: 1
purpose: Record the decision to use the requested concise lock labels and dynamic identity.
owner: unassigned
related_adrs: [ADR-0025, ADR-0026, ADR-0027]
template_version: 1
id: ADR-0037
title: "Use the requested concise lock labels and dynamic identity"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user approval of the PIN, theme and QR implementation plan."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0037: Use the requested concise lock labels and dynamic identity

## Decision

Use Enter Passcode, Use Device Biometrics, Forgot Passcode?, and Signed in as the selected display identity. Forgot Passcode is an intentionally inactive clickable control.

## Context and drivers

The user explicitly requested these strings and no recovery action yet. Preserve existing approved composition.

## Scope

- Applies to: Entry copy and recovery-control semantics.
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
