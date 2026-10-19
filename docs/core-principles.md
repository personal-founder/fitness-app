---
metadata_version: 1
purpose: Preserve the detailed reusable engineering principles linked by AGENTS.md.
owner: unassigned
related_adrs: [ADR-0002]
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
