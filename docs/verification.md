---
metadata_version: 1
purpose: Explain the shared verifier, policy, evidence, and local hook lifecycle.
owner: unassigned
related_adrs: [ADR-0006, ADR-0007, ADR-0008, ADR-0009, ADR-0010, ADR-0011, ADR-0012, ADR-0039, ADR-0040]
---
# Verification

From the repository root, with the policy-pinned Flutter SDK's Dart on PATH:

```text
dart tool/verify.dart
```

The bootstrap uses only Dart's standard library, validates configuration and SDK
pins, and runs locked dependency restoration before loading YAML-aware workers.
It discovers Flutter from its own SDK, `FLUTTER_ROOT`, PATH, or the explicit
`--flutter-sdk=/path/to/flutter` option. Machine-specific locations stay local.
The pinned versions and exact commands live in
[engineering-policy.json](../config/engineering-policy.json) and its registries.

## What is checked

- Formatting without source rewrites; Flutter analysis.
- Separate verifier, application, and integration suites, with discovered tests.
- All policy-required release builds on suitable hosts, including unsigned iOS.
- Metadata, ADR structure/index/links, physical lines, decision coverage, and
  mandatory-rule inventory freshness.
- Git whitespace/conflict checks; final snapshot/parent consistency.
- Full commit subject, sections, per-file ledger/counts, and coverage when given
  a message file. Message prose alone is never evidence of a passing gate.

Application tests cannot be substituted with tooling tests. Missing suites,
skipped tests, unavailable tools, or unsupported native runners cannot pass.
The integration test is synthetic-adapter coverage; it does not verify Supabase,
RLS, real biometric hardware, or every native device capability.

The default run copies working inputs into an owned temporary workspace and checks
that both the original inputs and copied source stay unchanged. It does not stage,
stash, format, or commit. Dependency/build caches and ignored reports may be written. An enforced
lockfile must remain unchanged. Verification is not a dependency-upgrade command.

## Results and reports

| Exit | Meaning |
| --- | --- |
| 0 | Every registered required check passed |
| 1 | At least one check failed |
| 2 | Required verification is blocked or evidence is incomplete |
| 3 | Invocation, configuration, or receipt is invalid |

Invalid results take precedence over failures; failures precede blockages.
Reports include the schema version, snapshot/parent/base, policy and lockfile
digests, pinned tool versions, host, timestamp, check results, and durations.
Default evidence: ignored `output/verification/latest.json`. Use
`--output=/absolute/report.json` for an explicitly selected report location.
Reports may contain build diagnostics; review/redact them before external sharing.

The [requirement records](../config/policy/requirements) identify each normative
source statement, its verification method, evidence, and enforcement state.
Inventory validation proves coverage/freshness of those records. It does not turn
manual or unenforced requirements into verified application behavior. Unknown
requirements stay visibly unverified until actual evidence supports a change.

After deliberately changing normative source rules, run
`dart tool/refresh_requirements.dart`, review the record changes, and rerun the
gate. This explicit authoring operation preserves existing evidence only for
unchanged rule identities. The verifier never refreshes records to make them pass.
JSON Lines uses one readable machine record per line; files are sharded within
the configured physical-line target rather than combining hundreds in one file.
Exception fragments are likewise referenced by `config/policy/exceptions.json`;
their contents participate in the policy digest and strict schema validation.

| Enforcement | Meaning |
| --- | --- |
| automated | A named executable check enforces the recorded rule's stated scope |
| manual | A named human/review procedure is required; no technical guarantee is claimed |
| partial | Automation covers only part of the rule; the remaining review is explicit |
| unenforced | No active control currently enforces the requirement |

Every mode is separate from verified/unverified evidence status. Inventory
extraction checks named source statements; semantic review must also identify
mandatory requirements that prose heuristics cannot reliably recognize.

## Changed files and legacy findings

New/edited files block on policy violations. Unchanged legacy findings remain
visible in the report. Git-untracked files count as new inputs; the current app
foundation must satisfy adoption requirements before its first source commit.
No broad grandfathering or hidden ignore rule is applied to make the gate green.

Generated files and size exceptions must follow policy records and their ADRs.
ADRs have no size exception. Atomicity and rationale quality still need review;
structural checks cannot establish that a decision is wise or genuinely singular.

## Exact staged verification

```text
dart tool/verify.dart --staged
dart tool/verify.dart --staged --message=/absolute/commit-message.txt
```

The staged export uses indexed blobs, not unstaged fixes, in a temporary directory.
It preserves executable modes, blocks conflicted/symlink/submodule/LFS entries until
safe support is added, and deletes only its own temporary workspace afterward.
Reports stay outside that snapshot to avoid self-referencing digests.

The normal base is HEAD. For an amended commit, explicitly select its actual
comparison parent using `--base=HEAD^`; a root commit can use `--base=empty`.
Supply the same base to hooks through `MACRO_VERIFY_BASE`. Git does not expose a
reliable amend flag to pre-commit/commit-msg hooks. Squash/merge/cherry-pick work
needs renewed evidence and a message matching the final candidate and base.

## Platform evidence and CI

A single host does not prove all required targets. Host-incompatible builds remain
BLOCKED. Run `--shard=windows`, `--shard=linux`, or `--shard=macos` only on that
actual host; shard reports retain BLOCKED outcomes for foreign targets.

An explicit trusted report directory can provide missing platform evidence:

```text
dart tool/verify.dart --staged --evidence-dir=/trusted/reports
dart tool/verify.dart --staged --aggregate=/trusted/reports
```

Only combine reports from runs you trust. Digests identify matching inputs; they
do not authenticate who ran a check. Local receipts are not cryptographic
attestations. Never import reports from arbitrary pull requests or unknown users.
Malformed, expired, contradictory, host-incompatible, or mismatched reports fail.
Missing required targets block. A failure cannot be masked by another passing copy.

The workflow runs on Linux/Windows/macOS, uploads reports, and aggregates the same
candidate. Worker steps explicitly tolerate exit 2 only to collect foreign-host
blockages; the aggregate remains strict. Hosted CI results exist only after the
workflow actually runs. Branch protection and signing/publication are not installed
by this change. Post-commit CI does not retroactively authorize a local commit.
Integration suites select the configured desktop device explicitly. Linux CI runs
under Xvfb; this establishes a display environment, not physical-device coverage.

## Local hooks

```text
dart tool/hooks.dart install
dart tool/hooks.dart remove
```

Installation records/restores local hook settings, sets `core.hooksPath` to
`.githooks`, and stores the discovered SDK in local Git configuration. Existing
custom hooks are detected and preserved; integration is required rather than
overwriting them. Hook scripts and sidecars must be included in the next authorized
commit to travel to another clone; every clone needs activation.

Pre-commit runs the complete staged gate. Commit-msg validates the actual message
against matching passing pre-commit evidence. For multiple-platform local evidence,
set `MACRO_VERIFY_EVIDENCE` to the explicit trusted directory. Hooks preserve the
index and working files. Missing tools/evidence block, including during outages.
Git can bypass local hooks; policy forbids doing so. Remote protection is a
separate, visibly deferred control.

Binary ledger rows use `LOC: N/A (binary)` and include exact sizes as
`old=0B new=123B` in the explanation. LFS pointer explanations identify
`LFS sha256:` followed by the object ID; text counts describe the pointer only.

## Maintenance and validation

Follow [validation scheduling and the fix loop](core-principles.md#validation-scheduling-and-fix-loop)
and [efficient execution](core-principles.md#efficient-execution). Finish related
edits before routine validation, check inexpensive prerequisites early, and reserve
expensive builds for the stable candidate. Fix failures, then rerun affected checks.
This scheduling policy changes no verifier command, required target, hook, or
evidence-matching rule. A known blocked prerequisite remains a commit blocker.

See [the tracker](engineering-improvements.md) and
[implementation evidence](changes/verification-implementation.md).
Run verifier regression tests with `flutter test test/tooling` after changing
tooling; this test command does not claim the full application gate passed.
Configuration changes need updated records/docs and new snapshot evidence.

## Primary implementation references

- [Dart locked dependency restoration](https://dart.dev/tools/pub/cmd/pub-get).
- [Flutter integration tests and Linux CI displays](https://docs.flutter.dev/testing/integration-tests).
- [Git hooks and their bypass limitations](https://git-scm.com/docs/githooks).
- [Git indexed snapshots](https://git-scm.com/docs/git-write-tree).
- [GitHub Actions secure use and immutable action pins](https://docs.github.com/en/actions/reference/security/secure-use).
- [YAML parser package and license](https://pub.dev/packages/yaml).
