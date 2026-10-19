---
metadata_version: 1
purpose: Index decisions and identify adoption gaps without rewriting historical rationale.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0005, ADR-0039, ADR-0040, ADR-0041]
---
# Decision index

## Authentication foundation records

The application task uses IDs 0013–0030 after resolving concurrent allocations of
0010–0012 to tooling records. These focused records extract current implementation
boundaries from ADR-0001 without rewriting its historical text.

| ID | Decision | Status |
| --- | --- | --- |
| ADR-0028 | [Use Flutter for six application targets](0028-flutter-targets.md) | accepted |
| ADR-0029 | [Use Riverpod for injected session state](0029-riverpod-state.md) | accepted |
| ADR-0030 | [Derive GoRouter routes from session phase](0030-guarded-entry-routes.md) | accepted |
| ADR-0013 | [Share one theme-aware entry composition](0013-approved-entry-composition.md) | accepted |
| ADR-0014 | [Use genuine Supabase email authentication](0014-supabase-email-auth.md) | accepted |
| ADR-0015 | [Restrict profile records to their owners](0015-profile-owner-access.md) | accepted |
| ADR-0016 | [Issue immutable random account tags on the server](0016-random-account-tags.md) | accepted |
| ADR-0017 | [Keep avatar objects private and owner-scoped](0017-private-avatar-bucket.md) | accepted |
| ADR-0018 | [Use a protected verifier for the separate app passcode](0018-separate-app-passcode.md) | superseded |
| ADR-0019 | [Delegate alternate unlock to device authentication](0019-biometric-alternative.md) | accepted |
| ADR-0020 | [Persist native sessions in platform secure storage](0020-protected-native-sessions.md) | accepted |
| ADR-0021 | [Keep unsupported-platform sessions in memory](0021-browser-session-fallback.md) | accepted |
| ADR-0022 | [Limit the initial Drift database to non-sensitive preferences](0022-drift-preferences.md) | accepted |
| ADR-0023 | [Isolate King James in a labeled design preview](0023-king-james-preview.md) | superseded |
| ADR-0024 | [Limit this milestone to authentication entry views](0024-auth-only-milestone.md) | superseded |
| ADR-0025 | [Verify the entry milestone with repeatable checks](0025-verification-workflow.md) | accepted |
| ADR-0026 | [Pin current-scope package versions and acquisition evidence](0026-pinned-package-provenance.md) | accepted |
| ADR-0027 | [Use documented line extensions for cohesive entry units](0027-cohesive-source-extensions.md) | accepted |


Read [the policy](../atomic-and-adr-policy.md) before using [the template](adr-template.md).
Each new ADR records one decision and stays below 250 physical lines.
Allocate the next unused number after checking this index and the directory.

| ID | Decision | Status | Adoption |
| --- | --- | --- | --- |
| ADR-0001 | [Flutter authentication foundation](0001-auth-foundation.md) | superseded | Original text archived; focused successors own current choices |
| ADR-0002 | [Use atomic responsibility boundaries](0002-atomic-responsibilities.md) | accepted | Current template |
| ADR-0003 | [Capture every decision/change automatically](0003-automatic-decision-coverage.md) | accepted | Current template |
| ADR-0004 | [Use one bounded ADR template](0004-bounded-adr-template.md) | accepted | Current template |
| ADR-0005 | [Associate metadata with every file](0005-file-metadata.md) | accepted | Current template |
| ADR-0006 | [Require evidence and enforcement status for mandatory rules](0006-requirement-evidence.md) | accepted | Implementation evidence tracked separately |
| ADR-0007 | [Use one cross-platform verification command](0007-shared-verifier.md) | accepted | Implementation evidence tracked separately |
| ADR-0008 | [Define machine-readable policy values once](0008-policy-configuration.md) | accepted | Implementation evidence tracked separately |
| ADR-0009 | [Verify the exact staged candidate in isolation](0009-isolated-staged-verification.md) | accepted | Implementation evidence tracked separately |
| ADR-0010 | [Enforce verification through local Git hooks](0010-local-verification-hooks.md) | accepted | Implementation evidence tracked separately |
| ADR-0011 | [Combine matching evidence from trusted platform runners](0011-platform-evidence.md) | accepted | Implementation evidence tracked separately |
| ADR-0012 | [Run the shared gate across suitable CI hosts](0012-verification-ci.md) | accepted | Implementation evidence tracked separately |

| ADR-0031 | [Isolate working-copy checks from user source](0031-working-copy-isolation.md) | accepted | Implementation evidence tracked separately |

## Existing adoption gaps

ADR-0001 originally bundled platform, authentication, storage, preview and scope.
The application task preserved its original text in `docs/reference/`, normalized
its historical wrapper and linked focused successors. Original acceptance remains
distinct from completed implementation or test evidence.

Existing application/assets/reference files have not been audited or retrofitted for
metadata in this policy change. Enforce metadata on new/edited files, report gaps,
and backfill deliberately within the relevant task. No full-repo compliance claim.

## This policy change: coverage

| Changed path | Governing ADRs | Application |
| --- | --- | --- |
| `AGENTS.md` | ADR-0002, ADR-0003, ADR-0004, ADR-0005 | Route work to atomic/ADR/metadata rules |
| `docs/core-principles.md` | ADR-0002 | Preserve existing rules outside the root router |
| `docs/engineering-standards.md` | ADR-0003, ADR-0004, ADR-0005 | Align coverage, size limits, metadata |
| `docs/atomic-and-adr-policy.md` | ADR-0002, ADR-0003, ADR-0004 | Specify decision capture and lifecycle |
| `docs/file-metadata.md` | ADR-0005 | Define format-safe metadata |
| `docs/commit-standard.md` | ADR-0003, ADR-0004, ADR-0005 | Require coverage and metadata review |
| `.gitmessage` and `.gitmessage.meta.yaml` | ADR-0003, ADR-0004, ADR-0005 | Capture per-change ADR coverage |
| `docs/adr/adr-template.md` | ADR-0004 | Standardize full records below 250 lines |
| `docs/adr/README.md` | ADR-0003 | Index records and coverage without recursive ADRs |
| ADR-0002 through ADR-0005 files | Corresponding decision; ADR-0003/0004/0005 reused | Record this request under its own rules |

## Policy validation

2026-10-19: local Python with the already installed PyYAML parsed all 13 changed
metadata-bearing documents/sidecars. Required fields, unique/resolving ADR IDs,
template sections, line limits, local links/anchors, and the sidecar target passed.
The four new ADRs are 69–71 lines; the template is 76 lines. Root plus active global
instructions total 31,926 bytes, within the default 32 KiB loading budget.
Review confirmed the change-to-ADR mapping above; the commit template still has its
12 required sections. No application code was changed by this task and no app
build/test result is asserted. No tools/packages were installed or Git commits made.

- ADR-0032: [Require four-digit app PINs distinct from tag suffixes](0032-four-digit-pin.md) — accepted.

- ADR-0033: [Require account authentication before replacing legacy PIN records](0033-legacy-pin-reauthentication.md) — accepted.

- ADR-0034: [Unlock the isolated King James demo with 1234](0034-interactive-isolated-demo.md) — superseded.

- ADR-0035: [Persist device theme overrides with a System reset](0035-device-theme-preference.md) — accepted.

- ADR-0036: [Share only the public account tag in a profile QR](0036-profile-tag-qr.md) — accepted.

- ADR-0037: [Use the requested concise lock labels and dynamic identity](0037-entry-copy.md) — accepted.

- ADR-0038: [Allow the entry header action to wrap at large text sizes](0038-responsive-header-action.md) — accepted.

## Validation scheduling and efficiency

| ID | Decision | Status |
| --- | --- | --- |
| ADR-0039 | [Batch routine validation at the end of coherent work](0039-end-of-work-validation.md) | accepted |
| ADR-0040 | [Avoid redundant and competing engineering work](0040-efficient-execution.md) | accepted |

## Bounded local commit exception

| ID | Decision | Status |
| --- | --- | --- |
| ADR-0041 | [Authorize three local commits with blocked verification](0041-three-local-commit-exception.md) | accepted |

- ADR-0044: [Require credentials before entering the King James demo](0044-demo-credential-entry.md) — accepted.

- ADR-0042: [Remember only the synthetic demo signed-in flag](0042-remember-demo-session.md) — accepted.

- ADR-0043: [Group the authentication milestone into five application commits](0043-auth-commit-breakdown.md) — superseded.

- ADR-0045: [Open an empty dashboard after unlock](0045-blank-dashboard.md) — accepted.

- ADR-0046: [Commit the complete application milestone with a native-test waiver](0046-application-commit-native-waiver.md) — accepted.

- ADR-0047: [Escape at signs in commit ledger paths](0047-escape-asset-ledger-paths.md) — accepted.
