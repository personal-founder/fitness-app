---
metadata_version: 1
purpose: Preserve all eight engineering improvements with acceptance and honest evidence.
owner: unassigned
related_adrs: [ADR-0006, ADR-0007, ADR-0008, ADR-0010, ADR-0012]
---
# Engineering improvement tracker

All eight items remain tracked. Implementation and verification are separate.
The current authorized scope is items 1–2, their foundational validators, and local
hooks. Application fixes, device certification, and remote protection are separate.

| ID | Improvement | Implementation | Verification | Dependencies | Next action |
| --- | --- | --- | --- | --- | --- |
| ENG-01 | One verification command | Implemented with local hooks | Local regression tests passed; complete platform gate remains unverified | ENG-02; SDK; native runner evidence | Inspect full-run evidence, then obtain matching native runner results |
| ENG-02 | Machine-readable policy | Implemented with bounded referenced registries | Schema and rejection fixtures passed; live configuration loads | Accepted rule conventions | Keep registry/source evidence fresh when rules change |
| ENG-03 | ADR and metadata validator | Foundations implemented in ENG-01 | Structural fixtures passed; semantic review remains manual | ENG-02 | Expand semantic/coverage automation only with meaningful tests |
| ENG-04 | Platform verification matrix | Required targets/host builds configured | Native/device results unverified | Platform runners, devices, permissions | Run hosted shards, then add device/sensor verification |
| ENG-05 | Critical behavior contracts | Deferred | Unverified | Approved auth scope and product criteria | Specify observable journeys and map them to tests |
| ENG-06 | Security boundary tests | Deferred | Unverified | Test Supabase environment and synthetic accounts | Prove RLS, storage isolation, session denial, and private diagnostics |
| ENG-07 | Exception and debt register | Minimal size-exception data only | Unverified beyond tooling checks | Rule owners and review process | Add ownership/revisit lifecycle for broader debt without duplicating ADRs |
| ENG-08 | Reproducible onboarding | Verifier setup documented only | Clean-clone/native setup unverified | SDKs, CI, environment documentation | Verify clean setup on each supported development host |

## Acceptance and evidence

- ENG-01: one entry point reports all required checks, fails closed, preserves user
  work, and is shared by hooks/CI. Evidence: controlled process/Git fixture tests
  plus actual [implementation results](changes/verification-implementation.md).
- ENG-02: all validator values come from valid versioned registries; unknown keys,
  malformed values, broken references, and unsupported versions fail. Evidence:
  configuration regression tests and the actual runner load.
- ENG-03: structural metadata/ADR/line/link/coverage defects are detected. Human
  meaning, ownership accuracy, and atomic decision quality remain review obligations.
- ENG-04: every target has snapshot-bound build evidence and clearly identified
  device coverage; configuring a job is insufficient evidence.
- ENG-05: each critical behavior has explicit acceptance criteria and tests that
  reproduce failure, not only snapshots of implementation output.
- ENG-06: denied cross-user access and privacy leaks are tested against actual
  security boundaries; mocks alone do not establish backend isolation.
- ENG-07: each exception has a reason, governing ADR, responsible owner, risk,
  revisit condition, and resolution state; no silent permanent exemptions.
- ENG-08: a clean checkout can reach the expected checks with documented tools and
  value-free configuration, without undocumented local machine assumptions.

## Mandatory-rule evidence

The [policy entry point](../config/engineering-policy.json) references the
source-linked requirement register. Each record identifies its verification method,
available evidence, enforcement status, and verified/unverified state. No evidence
means unverified. A documented control, a generated inventory, or an accepted ADR
does not establish implementation, a passing test, or installed enforcement.

Ownership is currently unassigned where no responsible person/team was supplied.
Do not invent ownership, approvals, successful CI runs, or completion dates.

## Current evidence and adoption

- Regression evidence, actual gate outcomes, setup/hook evidence, and known
  limitations are recorded in [the implementation record](changes/verification-implementation.md).
- Changed-file policy checks passed in the initial inspected snapshot. The untouched
  `docs/examples/commit-message.txt` lacks metadata and remains visible adoption work.
- The requirement register explicitly preserves unverified rule states. Inventory
  freshness is not proof of SaaS security, release readiness, or device coverage.
- The installed pre-commit hook rejects the current incomplete index: the new
  configuration/tooling is not staged. Its test preserved the index and HEAD.
- All six platform builds remain mandatory. Missing matching runner evidence
  blocks completion; no host-only result can substitute for it.
- The initial full run passed 30 application tests and the web release build.
  Windows native compilation lacks the Visual C++ ATL header `atlstr.h`; native
  integration requires the same build prerequisites. The other four platform
  builds need matching Linux/macOS runner evidence. No SDK component was installed.
- The initial tooling run inside the isolated workspace exposed an active-directory
  cleanup defect, now guarded with a subprocess regression. Integration device
  selection was also made explicit after a device-choice failure.
- Concurrent application edits changed the initial snapshot and introduced
  unfinished ADR references during inspection. The verifier reported them;
  application repair remains outside this implementation's authorized scope.
- Final captured gate: 38 verifier tests passed; web release build passed. The
  application suite had 29 passes and one failure in the tag/background/sign-out
  journey. Formatting failed in `appearance_settings.dart`; analysis reported
  Riverpod protected/test-only state access in `session_lock.dart`. Policy checks
  reported unfinished ADR-0032–0037 links and two application file-length issues.
  The snapshot changed during the run. These results do not assert the live app
  still has those defects after concurrent edits; obtain fresh evidence after it
  settles. No failure was waived, and the complete gate exited 1.
