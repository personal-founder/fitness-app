---
metadata_version: 1
purpose: Record the authorized blank post-unlock dashboard destination.
owner: unassigned
related_adrs: [ADR-0030, ADR-0013, ADR-0025]
template_version: 1
id: ADR-0045
title: "Open an empty dashboard after unlock"
status: accepted
date: "2026-10-19"
decision_basis: "Direct user request for a blank King James dashboard after passcode."
implementation: implemented
supersedes: [ADR-0024]
superseded_by: []
---
# ADR-0045: Open an empty dashboard after unlock

## Decision

Replace the unlocked confirmation with a blank dashboard at `/dashboard`, retaining
the existing themed shell, menu and Sign Out. Tracker content remains deferred.

## Context and drivers

The user now explicitly authorizes this destination for King James. The prior
milestone ended with an account-ready message inside the credential panel.

## Scope

- Applies to: the unlocked destination, navigation tests and current architecture.
- Excludes: dashboard widgets, trackers, profile editing and backend changes.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Blank themed destination | Follows request and retains navigation | No dashboard features yet | Selected |
| Keep ready message | No code change | Does not deliver requested page | Rejected |

## Consequences

- Benefits: successful unlock reaches a distinct, empty dashboard.
- Costs and risks: lifecycle locking must still apply on the new screen.
- Mitigation: keep the existing observer mounted; verify background relocking.

## Implementation and traceability

- Reuse session guards and shell widgets; `/ready` redirects to the new destination.
- [Work record](../changes/2026-10-19-blank-dashboard.md) maps changed files.
- No new packages, downloads, storage or network operations.

## Verification

- Acceptance: login and locked sessions cannot open the dashboard; valid unlock
  opens it; background hides it; Sign Out returns to credentials.
- Result: see the work record for actual validation outcomes.
- Limits: synthetic adapters do not prove live authentication or native devices.

## Reversal and revisit

- Reversal: restore the ready message and prior target while retaining guards.
- Revisit when: dashboard content is explicitly requested.

## References

- User request on 2026-10-19: blank King James dashboard after passcode.
- [Architecture](../../ARCHITECTURE_AND_DATA.md).
