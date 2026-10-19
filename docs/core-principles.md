---
metadata_version: 1
purpose: Preserve the detailed reusable engineering principles linked by AGENTS.md.
owner: unassigned
related_adrs: [ADR-0002, ADR-0039, ADR-0040]
---
# Core engineering principles

Read these rules before implementation, review, or cleanup. They retain the existing
DRY, KISS, Boy Scout, craftsmanship, and verification requirements moved out of the root router.
Follow [AGENTS.md](../AGENTS.md) and the [ATOMIC policy](atomic-and-adr-policy.md).

## 2. DRY — Do Not Repeat Yourself

- Before adding any function, component, endpoint, document, script, configuration, or asset, establish its purpose and search for an existing equivalent.
- Reuse or extend the canonical implementation when responsibilities match. Keep one authoritative definition for business rules, schemas, design tokens, and configuration; derive consumers where practical.
- Consolidate repeated business logic with tests proving preserved behavior. Avoid abstractions based only on superficial similarity; independent concepts may legitimately use similar code.
- Do not introduce parallel versions, copied utilities, duplicate dependency systems, or multiple competing sources of truth without a documented need.
- Remove superseded code and documentation only after checking references, compatibility, and ownership. Link to canonical information instead of copying it everywhere.

## 3. KISS — Keep It Super Simple

- Prefer explicit control flow, descriptive names, small cohesive modules, standard library features, established platform capabilities, and supported stable tools.
- Choose the least complex design that satisfies actual requirements and foreseeable change. Explain each additional service, abstraction, dependency, cache, queue, or configuration layer.
- Begin with a modular application and clear interfaces unless evidence justifies distribution. Do not introduce microservices, speculative extension systems, or global coordination for hypothetical future scale.
- Optimize measured bottlenecks. Avoid cleverness, deep inheritance, tangled callbacks, broad global state, hidden side effects, and oversized catch-all files.
- Prefer one obvious workflow for setup, build, test, and release. Automate repeatable work after understanding it.
- Modern means supported, appropriate, and maintainable; it does not mean adopting every new framework or performing unrelated upgrades.

### Efficient execution

- MUST choose the smallest complete workflow that satisfies the authorized scope.
  Batch related reads and edits; reuse applicable patterns, research, and records.
  Do not expand a narrow task into unrelated cleanup or extra infrastructure.
- MUST plan validation once, including likely prerequisites and expensive steps.
  Do not run overlapping release builds or heavyweight suites that compete for
  the same machine resources. Parallelize only independent work with capacity.
- MUST avoid repeating successful checks without a relevant change, new failure,
  changed environment, or explicit gate requirement. Reuse evidence only for the
  inputs and environment it actually covers; changed snapshots invalidate it.
- MUST stop repeating a known blocked operation until its prerequisite changes.
  Record the blocker and continue independent work; a required blocked check
  remains BLOCKED and cannot authorize completion, committing, or release.
- Use bounded waits and useful progress updates instead of frequent unchanged
  polling. Report commands, durations when useful, failures, and remaining work;
  never equate speed with skipped requirements or unsupported success claims.
- Verification method: review command history, changed inputs, check durations,
  and the work record for redundant or competing runs. Evidence: actual task
  logs/reports. Enforcement: manual process review; time savings are unverified
  until measured on later work.

## 4. Boy Scout rule — Improve what you touch

- During implementation, inspection, review, and testing, fix safe local defects, unnecessary complexity, stale comments, inconsistent names, broken references, and unused code you can confidently verify.
- Keep cleanup connected to the task and its affected area. Preserve public behavior unless a behavior change is intended and tested. Separate substantial refactors from functional changes where practical.
- Do not perform sweeping renames, dependency migrations, formatting churn, or architectural rewrites merely because you noticed an imperfection.
- Investigate apparently purposeless code before deleting it. Complete it only when its intended purpose is established and within scope. Do not invent features to justify dead code.
- Record larger or uncertain issues with location, evidence, impact, priority, proposed resolution, and a verification method. Bring them to the user's attention when a decision is needed.
- No abandoned scaffolding, unexplained TODOs, silent exceptions, fake production data, or disconnected UI controls. Any intentional unfinished work needs a tracked reason and next action.

## 7. Professional craftsmanship — No AI slop

- Produce deliberate, idiomatic code and a coherent product grounded in user needs and the project's visual direction. Use precise domain names and purposeful composition.
- No filler documentation, fabricated evidence, repetitive boilerplate, generic placeholder copy, dead interactions, invented testimonials, magic constants without context, or abstractions added only to appear sophisticated.
- Reuse standard algorithms, trusted libraries, and established interaction patterns. Originality belongs in product value and thoughtful design; security and correctness do not benefit from novelty for its own sake.
- Follow the approved mockups and design system where they exist. Resolve gaps intentionally. Maintain consistent typography, spacing, color, motion, terminology, error messages, and component behavior.
- Review generated code as critically as human-written code. Verify API existence, licenses, edge cases, and behavior. Never paste code you cannot explain and test.
- Do not disguise authorship, falsify provenance, remove required attribution, or optimize for evading AI detection. The quality standard is useful, maintainable work that withstands human review.

## 8. Tests, evidence, and auditability

- Every new or changed executable behavior MUST have meaningful verification. Add or update automated tests for logic, integrations, and regressions; reuse existing coverage when it already proves unchanged behavior. Explain any coverage gap explicitly.
- Use unit tests for domain rules, integration tests for persistence/contracts/security boundaries, and a focused end-to-end suite for critical user journeys. Test externally observable behavior rather than duplicating implementation details.
- Cover applicable success, invalid input, denied access, empty/loading/error states, retries, duplicates, timeout, cancellation, concurrency, offline recovery, and backward compatibility.
- For bug fixes, add a regression test that reproduces the defect when practical. For security fixes, include the denied/abuse path. Do not snapshot broken output or update expected results without understanding the behavior change.
- Keep tests deterministic and isolated. Control clocks, randomness, and external services; use synthetic data. Avoid live production accounts and fragile fixed sleeps. Integration tests must exercise real relevant boundaries, not only mocks.
- Run formatting/lint, type/static checks, affected tests, and appropriate builds using actual project commands. Run the broader regression suite when shared contracts or risk justify it. CI should enforce required checks once infrastructure exists.
- Do not invent commands, report unrun tests as passing, suppress meaningful errors, reduce assertions, or disable failing checks to finish faster. Record pre-existing failures separately from introduced failures.
- Keep output concise and actionable: command, outcome, relevant counts, duration when useful, and sanitized failure details. Keep full bulky reports in the appropriate artifact store with retention limits.
- Documentation-only changes need factual/link/consistency review, not artificial unit tests. Declarative files, generated files, and native UI may need schema validation, generation checks, platform tools, or manual checks; record the method.
- Validate release-critical behavior on real supported devices when hardware, sensors, background execution, permissions, or OS integration matter. Clearly label emulation and viewport simulation; they do not prove physical-device behavior.

### Validation scheduling and fix loop

- MUST defer routine test execution, full analysis, broad validation, and release
  builds until the coherent implementation, test changes, documentation, metadata,
  and ADRs are ready for review. Write needed tests with the code; run them during
  the final validation phase rather than repeatedly after every small edit.
- Early exceptions are limited to cheap prerequisite checks or a focused defect
  reproduction/technical spike that resolves material risk, security uncertainty,
  or a likely wrong approach. Follow an explicit request for an earlier check.
  Record why the early check is necessary; do not launch the full gate for it.
- At the end, inspect the diff and run applicable checks in increasing cost order:
  document/schema/format checks, static analysis, affected tests, required broader
  suites, then expensive builds/device checks. Use canonical project commands.
  This orders work; it does not remove checks required by the shared gate.
- After failures, diagnose and fix in-scope causes, then rerun the failing checks
  and checks invalidated by the fix. Broaden again only when affected contracts,
  risk, or the final commit/release gate requires it. Never rerun everything merely
  because another check finished or an unrelated file was viewed.
- Before an expensive run, confirm prerequisites and a stable candidate. If other
  work changes its inputs, mark its evidence stale; retain useful diagnostics
  without treating them as proof of the changed candidate.
- Finish only with applicable checks passing or explicit FAIL/BLOCKED limitations.
  Failed, missing, skipped, stale, or blocked required checks still prevent a
  commit/release. Documentation-only work uses document checks before handoff;
  any later commit must still satisfy the complete existing commit policy.
- Verification method: inspect the edit/check sequence and fix/rerun rationale.
  Evidence: command outcomes and the task work record. Enforcement: manual process
  review; the existing shared verifier and hooks retain their current behavior.
