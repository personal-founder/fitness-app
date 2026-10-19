---
metadata_version: 1
purpose: Preserve exact asset paths in commit ledgers without triggering email prose detection.
owner: unassigned
related_adrs: [ADR-0011, ADR-0025]
template_version: 1
id: ADR-0047
title: "Escape at signs in commit ledger paths"
status: accepted
date: "2026-10-19"
decision_basis: "Routine in-scope correction discovered while preparing the authorized complete commit message."
implementation: implemented
supersedes: []
superseded_by: []
---
# ADR-0047: Escape at signs in commit ledger paths

## Decision

Extend the existing JSON path representation to escape at signs as `\u0040`.
The canonical diff ledger and its validator use the same reversible representation.

## Context and drivers

Flutter's Apple platform templates contain names such as `Icon-App-20x20@2x.png`.
Complete ledgers must identify those files, but the existing message email rule
mistakes the filename for an email address. Renaming platform assets or omitting
them would damage correctness or traceability.

## Scope

- Only the display encoding of unusual paths in commit ledgers and coverage rows.
- Preserve real paths, file contents, Git names and the email detection rule.
- No change to required checks, native waivers or receipt matching.

## Options and rationale

| Option | Benefit | Cost or risk | Outcome and reason |
| --- | --- | --- | --- |
| Reversible JSON path escaping | Complete truthful ledger; unchanged email rule | Encoded paths are longer | Selected; extends the existing convention |
| Disable email detection | Simple | Allows accidental personal addresses in prose | Rejected |
| Rename or omit assets | Avoids the textual match | Invalid references or incomplete ledger | Rejected |

## Consequences

- Existing ordinary path rendering remains unchanged.
- At-sign paths now have a quoted JSON representation with a Unicode escape.
- Consumers should decode the JSON path when an original path is required.

## Implementation and traceability

- `tool/verification/changes.dart` owns the shared display representation.
- `test/tooling/commit_path_test.dart` exercises real staged fixture paths,
  reversible decoding, complete message acceptance and email-prose rejection.
- Commit preparation uses canonical changes rather than a parallel path formatter.

## Verification

- Acceptance: a complete at-sign asset ledger validates; literal email prose fails.
- Result: actual staged test outcomes and message validation are recorded in the
  commit message and external verification evidence.
- Limits: this change does not add general support for unsupported Git entry types.

## Reversal and revisit

- Reversal: restore prior encoding and accept that affected messages fail validation.
- Revisit when: the message schema or machine-readable ledger format changes.

## References

- [Commit standard](../commit-standard.md).
- [Verification](../verification.md).
