---
metadata_version: 1
purpose: Record the verification implementation, decisions, actual checks, and gaps.
owner: unassigned
related_adrs: [ADR-0006, ADR-0007, ADR-0008, ADR-0009, ADR-0010, ADR-0011, ADR-0012]
---
# Verification implementation evidence

## Authorization and boundaries

Implement the user-approved verifier/policy plan, activate local hooks, and track
all eight improvements. No repository commit, push, deployment, or remote branch
protection change is authorized. Preserve ongoing application implementation.

## Reuse and decisions

- Reuse Flutter/Dart, the installed pinned SDK, locked cryptography hashing, the
  existing application/integration suites, ADR conventions, and the existing CI.
- Promote already locked yaml 3.1.4 from transitive to direct development use;
  purpose: parse real YAML front matter/headers/sidecars. Source: pub.dev YAML,
  license MIT, integrity retained in pubspec.lock. No version upgrade intended.
- Existing SDK/locked dependencies are restored for verification. No new global
  tool, paid service, or production credential is needed.
- CI setup obtains the configured official Flutter revision and OS build packages.
  Artifact actions are pinned to verified official release commits: checkout
  v7.0.1, upload-artifact v7.0.2, download-artifact v8.0.2. Full SHAs live once in
  the workflow. Provenance: official actions repositories and release/action manifests.
  These run only
  when the user later authorizes publication of this workflow and CI executes it.

## Change-to-decision coverage

| Changed area | Governing decisions | Application |
| --- | --- | --- |
| Root policy, tracker, requirement records | ADR-0006 | Evidence/verification/enforcement are distinct |
| Shared runner, checks, report model, tests | ADR-0007 | One reusable gate with explicit outcomes |
| Config registries, pubspec/lockfile and sidecars | ADR-0008 | Values defined once; real YAML parsing |
| Git export, snapshot, parent checks, staging tests | ADR-0009 | Validate exact staged bytes without changing user work |
| Hook scripts, installer and hook fixtures | ADR-0010 | Local activation and restored prior configuration |
| Receipt validation/aggregation and tests | ADR-0011 | Explicit trust and matching evidence |
| CI workflow/setup/shard scripts | ADR-0012 | Host-appropriate builds and strict aggregation |
| New ADRs, index, docs, file metadata | ADR-0003/0004/0005 reused | Automatic atomic capture and safe metadata |

Working-copy source preservation also follows [ADR-0031](../adr/0031-working-copy-isolation.md).

## Actual validation

Local verifier regression tests passed, including temporary Git repositories,
controlled command runners, actual hook fixture commits, malformed/stale reports,
and separate application/tooling-suite checks. The final counts and complete
command outcomes are preserved in ignored evidence:

- `output/verification-implementation/tooling-tests.log`: regression suite results.
- `output/verification-implementation/tooling-analysis.log`: focused static analysis.
- `output/verification-implementation/policy-inventory.log`: changed/legacy policy,
  documentation consistency, and visibly unverified requirement counts.
- `output/verification-implementation/hook-activation.json`: local activation,
  rejection exit, identical before/after index tree and parent.
- `output/verification/full-working.json`: initial end-to-end diagnostic run.
- `output/verification/final-working.json`: final candidate gate evidence when run.

The real installed hook rejected the incomplete index with exit 3 because the
policy entry point is not staged. Installation exited 0; local `core.hooksPath`
is `.githooks`, with the SDK path stored only in local Git configuration.
No actual project commit was attempted or created.

The first end-to-end attempts found and fixed mixed Windows path separator
comparison and repeated requirement refresh deleting its own records. Regressions
now cover both. Native integration device selection is explicit and Linux CI uses
Xvfb, following the primary sources linked in the verification guide.
The first full isolated run also exposed a cleanup fixture attempting to delete
its active temporary workspace. Cleanup now rejects the active directory and its
ancestors; a separate subprocess exercises that exact context. The original
application workspace was not the deletion target and was preserved.

Initial full-run results: formatting, analysis, 30 application tests, and the web
release build passed. Tooling recorded 34 pass/1 failure before the cleanup fix.
Integration stopped at device selection before explicit host devices were added.
Windows compilation reported missing `atlstr.h` from the Visual C++ ATL component;
this known missing prerequisite is now classified BLOCKED with its diagnostics.
Android, iOS, macOS, and Linux await their suitable runner evidence. The snapshot
changed during concurrent application work and final hardening, so those initial
results cannot authorize a commit of the final candidate. Final evidence must be
read independently; none of these failures were waived.

Changed-file policy checks passed in the initial snapshot; subsequent concurrent
application ADRs had unfinished links during inspection and were reported without
unrelated repairs. One untouched example lacks metadata and stays
visible. The register initially inventories 336 statements, all unverified; its
count can change with deliberately updated source rules. The full gate must remain
failed/blocked whenever application or platform requirements have not passed.
Fixtures establish verifier behavior only. Hosted CI has not run for this change.

### Final captured run

`final-working.json` records exit 1: all 38 tooling regressions passed, and the web
release build passed. Application results were 29 pass/1 failure in the tag,
background masking, and sign-out journey. Formatting reported
`lib/features/welcome/appearance_settings.dart`; analysis reported protected and
test-only Riverpod state access in `lib/features/auth/session_lock.dart`.
Policy findings included unfinished ADR-0032–0037 evidence links and the 75-line
`entry_field.dart` / 77-line `profile_share.dart` application files.

Windows integration and release compilation were BLOCKED by missing ATL; the
other four native targets require Linux/macOS runner evidence. Snapshot checks
failed because concurrent work changed inputs. The report describes its captured
snapshot, not subsequent edits. Final documentation/evidence reconciliation does
not turn this failed run into passing evidence. Original application source,
staged content, and HEAD were preserved by this implementation.

Final reconciliation: tooling analysis reports no issues; formatting checks all
59 tooling/test files without changes. The fresh requirement inventory contains
353 visibly unverified statements. Existing root research references were moved
unchanged to the engineering standards and linked from AGENTS.md after concurrent
additions exceeded the instruction-loading budget; combined root/global text is
31,615 bytes at this check. No operational rule was removed. Documentation updates
after the captured run require fresh candidate evidence before any future commit.

## Remaining work and rollback

All six targets remain required. Hosted workflows, device behavior, Supabase/RLS,
remote branch protection, and whole-repository metadata adoption require their own
evidence. Refer to the eight-item tracker for deferred scope.

Remove hooks with the documented installer removal operation before reverting
tooling. Restore prior local settings from the installation record; never reset
unrelated application files. No application data migration is introduced.
