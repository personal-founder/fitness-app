---
metadata_version: 1
purpose: Define detailed security, documentation, reliability, and release requirements.
owner: unassigned
related_adrs: [ADR-0003, ADR-0004, ADR-0005]
---
# Fitness App — Detailed Engineering Standards

These requirements supplement the root [AGENTS.md](../AGENTS.md). Read the security and fitness-data sections before implementing or reviewing executable app code. Read recordkeeping requirements before dependency/download/decision work or implementation closeout; read reliability requirements before architecture, persistence, networking, performance, or deployment work; read publishing requirements before policy-sensitive feature work and every release. Follow the root policy's instruction precedence, scope, verification, and authorization rules. These are project requirements, not claims that controls already exist.

Source identifiers refer to the [research references in AGENTS.md](../AGENTS.md#16-research-references-and-maintenance). Do not duplicate these standards in nested instruction files; link here and add only specific local requirements.

## 5. Security and privacy by design

No engineer or tool can guarantee zero vulnerabilities or zero leaks. MUST minimize exposure through layered, testable controls, explicit risk review, and incident readiness. Never claim perfect security or compliance based on passing tests alone.

- **Model threats:** For authentication, billing, sensitive data, external integrations, and new trust boundaries, identify assets, actors, abuse cases, entry points, controls, and residual risks. Use OWASP ASVS for applicable server/web controls and MASVS/MASTG for mobile verification [S2–S4]. Record versions and applicable control IDs.
- **Minimize data:** Collect only what an implemented feature needs. Document purpose, recipients/processors, storage location, retention, deletion, and permission/consent behavior. Default accounts and fitness information to private; sharing must be deliberate and reversible.
- **Protect secrets:** Keep credentials, tokens, signing keys, and sensitive configuration out of source, client bundles, logs, prompts, screenshots, fixtures, and build artifacts. Use a secret manager or platform-protected storage; provide value-free setup examples. Scan changes and release artifacts for exposure. If a secret leaks, contain access and coordinate rotation; deleting a line is insufficient.
- **Enforce authorization:** Authenticate and authorize on the trusted server for every protected operation and object. Enforce ownership and tenant boundaries across queries, jobs, caches, storage, exports, and admin tools. Client-side visibility is not access control. Test cross-user and cross-tenant denial.
- **Secure authentication:** Prefer maintained authentication solutions and established protocols. Use platform-appropriate OAuth/OIDC flows, secure sessions, expiration, revocation, recovery, and brute-force protections. Require strong authentication for privileged access. Never invent cryptography or store plaintext passwords.
- **Validate boundaries:** Parse and validate untrusted input with explicit types, lengths, ranges, and allowlists where appropriate. Parameterize database queries; encode output for its context. Defend applicable surfaces against injection, XSS, CSRF, SSRF, path traversal, unsafe uploads, and command execution.
- **Protect storage and transport:** Use authenticated encrypted transport with certificate validation. Encrypt sensitive stored data and backups using established services; separate key management from data access. Use OS secure storage for mobile/desktop credentials. Do not disable TLS checks or hard-code encryption keys.
- **Limit privilege and abuse:** Apply least privilege, resource limits, rate limits, timeouts, and restricted network access where appropriate. Restrict admin/debug interfaces. Web CORS and security headers must match the actual deployment, not permissive development defaults.
- **Keep observability private:** Use structured, redacted diagnostics. Do not log raw health records, credentials, payment data, or full request bodies by default. Define access, retention, and deletion for logs and crash reports. Security audit events should record who did what and the outcome without sensitive payloads.
- **Plan recovery:** Document vulnerability reporting, incident containment, key rotation, backup restoration, and breach escalation before production. Do not send notifications or rotate production secrets without applicable authorization.
- **Verify controls:** Use relevant secret/dependency/static scans and negative security tests. Review scanner findings, applicability, and remediation rather than treating scans as a security guarantee. Do not accumulate tools that duplicate checks without value.

## 6. Fitness data and user safety

- Treat health metrics, workouts, body measurements, photos, location routes, and inferred health information as sensitive. Keep them out of public URLs, analytics events, shared caches, test fixtures, and AI prompts unless a specifically approved design safely requires them.
- Request HealthKit, Health Connect, sensor, camera, location, and notification permissions only when needed, with understandable explanations. Support denial, partial access, revocation, and disconnected devices without crashes or misleading results.
- Keep imported data provenance, measurement units, source timestamps, and correction behavior clear. Test metric/imperial conversions, rounding, time zones, daylight-saving changes, duplicate imports, and conflicting offline edits. Do not interpret missing measurements as zero.
- Clearly separate general fitness guidance from medical diagnosis or treatment. Substantiate health claims and obtain qualified review when functionality could affect safety. Do not fabricate clinical validation, guaranteed outcomes, or regulatory approval.
- Make export and account deletion usable and verifiable where applicable. Cover downstream processors, derived records, local caches, and backup-retention exceptions. Prevent deleted records from silently reappearing through sync or restoration.
- Do not monetize sensitive health data through advertising profiles. Evaluate third-party analytics/SDK collection before integrating them. Store disclosures must match actual behavior [S5–S8].
- Determine launch regions, age audience, data-controller responsibilities, and applicable privacy/consumer-health obligations before launch. Escalate legal determinations to qualified review; being a fitness app does not automatically establish or eliminate a legal obligation.
- If community or generative-AI features are introduced, assess moderation, reporting/blocking, abuse prevention, harmful advice, consent, and applicable store requirements before shipping them.

## File-size limits

Executable values live in [the policy registries](../config/engineering-policy.json).
The verifier checks these published limits for consistency with that configuration.

Apply these limits when creating, editing, reviewing, or preparing files for a commit. Keep each file focused and easy to understand.

| File category | Default target | Justified extension | Exceptional size |
| --- | --- | --- | --- |
| Human-maintained code, including application code, tests, scripts, and code-based configuration | Fewer than 75 lines: maximum 74 | 75–150 lines inclusive | More than 150 only when no reasonable alternative exists |
| Markdown documentation, notes, instructions, and similar prose files, excluding ADRs | Fewer than 400 lines: maximum 399 | 400–800 lines inclusive | More than 800 only when no reasonable alternative exists |
| Complete ADRs, including front matter and all sections | Fewer than 250 lines: maximum 249 | None | None; link supporting material without splitting a single decision |

- Count all physical lines, including blanks, comments, imports, headings, tables, and fenced examples. Count a final unterminated line as one line. Markdown code examples count toward their document's limit. These are total file lengths, separate from a commit ledger's added/deleted LOC.
- Use the default target first. An extension up to 150 code lines or 800 non-ADR documentation lines requires a concrete reason why keeping the content together improves clarity or preserves a cohesive responsibility. Record the path, count, and reason with ADR coverage under [the decision policy](atomic-and-adr-policy.md). ADRs cannot exceed 249 lines.
- Exceed 150/800 only after checking reasonable ways to simplify, reuse, or split the file. Document the constraint, alternatives considered, why each reasonable alternative fails, actual count, and a condition for revisiting the exception. Convenience or avoiding a refactor is not sufficient. Surface unresolved exceptions for review; do not silently waive the limits.
- Split code at meaningful responsibility boundaries, with clear names and interfaces. Split long documents by topic and retain an index or links. Do not replace one understandable file with arbitrary fragments, circular dependencies, or duplicated content merely to satisfy a number.
- Never compress statements onto single lines, minify source, remove useful comments/tests, omit error handling, or use abnormally long prose lines to evade the limits. Preserve normal formatter behavior and readable paragraphs.
- Do not hand-split generated/vendor files, lockfiles, or externally mandated formats. If they exceed the relevant limit, identify their source/generator or format constraint and record why a safe split is unavailable. Apply the limits to maintained generators/templates where practical. This is a documented constraint, not a blanket exemption for handwritten code.
- Before finishing and again before committing, inspect the complete lengths of changed files. Bring touched oversized files into compliance when safely in scope; otherwise record and report the justified exception. Do not start unrelated repository-wide rewrites. Missing justification is an unresolved review finding, not a passing size check.

## 10. Decisions, downloads, and durable records

Record material decisions, behavior changes, introduced artifacts, verification, and unresolved risks. Do not record secrets, unnecessary personal information, internal chain-of-thought, or transcripts of every keystroke. Record concise rationale and evidence that another person can use.

Reuse equivalent existing records. The following are **default future locations**, not claims that these files exist. Create each only when there is real content or a relevant milestone; do not generate empty bureaucracy.

| Record | Default location | Required content |
| --- | --- | --- |
| Project onboarding | `README.md` | Purpose, supported platforms, setup, verified build/test commands, documentation links |
| Architecture decisions | `docs/adr/NNNN-short-decision.md` | Status/date, context, constraints, alternatives, decision, tradeoffs, security/privacy impact, verification and reversal/migration approach |
| Work records | `docs/changes/YYYY-MM-DD-short-topic.md` | Request/outcome, affected areas, reuse/research, checks, cleanup, remaining risks; link canonical PR/issue evidence when available |
| Downloads and dependencies | `docs/dependencies.md` | Artifact identity/version, source, purpose, reuse alternatives, license, integrity verification, destination/scope, install command, permissions/network/data impact, update/removal path |
| Data handling and threats | `docs/security-and-privacy.md` | Data inventory/flows, trust boundaries, control evidence, retention/deletion, processors, unresolved risks |
| Contribution guide | `CONTRIBUTING.md` | Conventions, reproducible setup, review/ownership workflow, checks and contribution process |
| Support matrix | `docs/platform-support.md` | Supported OS/device/architecture/browser versions, distribution channels, verified coverage and exclusions |
| Release evidence | `docs/releases/` | Release-specific requirement checks, source dates, artifacts, tests, approvals and rollback readiness |
| Operational runbooks | `docs/runbooks/` | Deployment, recovery, backup restore, incident response, support and troubleshooting as services are introduced |

- Automatically create one ADR for every new decision or independent change, including small implementation, documentation, dependency, cleanup, and process choices. Reuse an existing decision with explicit coverage when it actually applies. Follow [the decision policy](atomic-and-adr-policy.md) and [template](adr/adr-template.md); mark superseded decisions and link replacements.
- Before downloading/installing any package, SDK, CLI, runtime, model, font, image, dataset, binary, or script, identify why it is needed, whether something existing suffices, its source, license, and relevant risks. Record what was actually obtained and how it was verified.
- Prefer trusted registries and official publishers. Pin dependencies and use supported lockfiles with integrity metadata. Review install hooks and unusual permissions. Verify publisher signatures/checksums where available; a locally calculated hash alone does not establish authenticity.
- Do not execute remote scripts blindly, install unexplained global tools, or bundle assets with unknown redistribution rights. Keep proprietary user assets private and retain required notices.
- Use manifests, lockfiles, and release SBOMs as machine-readable dependency records. One human-readable entry may reference these for transitive packages; do not duplicate thousands of entries manually. Record deliberate manual downloads individually. Normal web-page reads need research citations, not a download ledger entry.
- Track updates/removals and resolve relevant vulnerability/license findings. A new major version requires compatibility review. Avoid unsupported dependencies without a documented mitigation and exit path.
- Where code or assets are generated, record the source/generator and reproducible generation command when available. Keep generated output identifiable; preserve truthful provenance.

## 11. Performance, reliability, and growth

- Design clear module interfaces so the application and team can grow. Do not claim support for millions of users without representative load tests, capacity analysis, operating limits, and costs.
- Define measurable budgets when the relevant feature is introduced: startup, interaction latency, API percentiles, memory, battery, network volume, bundle/install size, build/test time, and cost per workload. Record measurement conditions and baselines before optimizing.
- Use appropriate indexes, bounded queries, pagination, efficient assets, and background work. Avoid unbounded collections, N+1 queries, excessive polling, blocking UI work, and uncontrolled fan-out.
- Introduce caches only with ownership, invalidation, freshness, privacy, and failure behavior defined. Include user/tenant context in cache boundaries where needed.
- Use timeouts, bounded retries with backoff/jitter, cancellation, idempotency, and backpressure where appropriate. Never retry destructive or non-idempotent actions blindly. Explain offline sync and conflict resolution instead of silently overwriting data.
- Preserve data integrity with constraints, transactions, migrations, and explicit invariants. Keep API/database changes compatible with supported older clients; mobile adoption is not instantaneous. Test migration, recovery, and rollback or documented roll-forward paths.
- Establish service objectives, redacted metrics, actionable alerts, and operational ownership before production. Test backup restoration and define acceptable recovery time and data loss. Add redundancy based on measured availability requirements, not as duplicate code everywhere.
- Use reproducible environments, pinned tools, trusted build caches, and appropriately parallel checks to keep builds/tests fast. Do not cache secrets or skip correctness checks to improve timing.
- Support team growth through reviewable changes, documented contracts, ownership, onboarding, automated checks, and consistent tooling. Add governance as collaboration grows; do not build a thousand-person process for one contributor.

## 13. Publishing standard — Continuous release readiness

Before implementing a feature affected by store policy, review its relevant requirements. Before every release, recheck all applicable official requirements for the exact platform, region, distribution channel, account type, feature set, and submission date. Record the source URL, date checked, effective date, applicability, evidence, and unresolved issues. Do not treat this file as a frozen legal or store checklist.

| Surface | Required review areas |
| --- | --- |
| iOS / Apple distribution | Review guidelines; current SDK/submission requirements; entitlements and permissions; privacy disclosures/manifests and relevant SDK requirements; health integrations; account deletion; authentication and purchase/subscription rules; age/content ratings; reviewer access; metadata and real-device behavior [S5–S6] |
| Android / Google Play | Developer policies; current target API/submission and testing requirements; signing and packaging; permissions; Data safety disclosures; health declarations/integrations; in-app and external account-deletion paths where required; billing/subscriptions; ratings; reviewer access [S7–S8] |
| macOS | Requirements for the chosen channel: Mac App Store rules or Developer ID distribution, signing/notarization, sandbox/entitlements where applicable, update security and installation/removal [S9] |
| Windows | Requirements for the chosen package/channel: Store policies and certification where used, appropriate signing, installer/update integrity, permissions, clean uninstall, privacy and accurate listing [S10] |
| Other desktop / web distribution | Explicitly select supported targets first; review applicable packaging, signing/update, browser, accessibility, hosting, privacy and consumer requirements for that channel |

- Keep privacy policies, consent prompts, disclosures, permission declarations, and store listings aligned with actual code and SDK behavior.
- Test installation, upgrade, migration, sign-in/out, purchase/restore/cancellation where applicable, account deletion, offline recovery, and uninstall on supported targets. Verify release builds, not only development previews.
- For paid features, verify entitlements on a trusted backend, validate provider events, handle replay/duplicate/out-of-order events and refunds, and test sandbox purchase flows. Do not infer payment permission from a local client flag.
- Produce release provenance, dependency/license inventory, versioned artifacts, release notes, and a recovery plan. Protect signing credentials and CI permissions. Separate development, test, and production environments.
- Block release on known exploitable critical/high vulnerabilities in shipped paths, exposed secrets, broken access control, unverified destructive migrations, known data loss, or unmet mandatory submission requirements. Record other accepted risks with an authorized owner and review date.
- Do not promise store acceptance. Report readiness against evidence and unresolved requirements. Submission and publication require user authorization.

## 14. Primary engineering references

Source register prepared 2026-10-19; these are guidance, not certifications.

- **[S1] Agent instruction discovery:** [OpenAI — Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md). Codex discovery depends on workspace/root, overrides, and instruction-size limits. Keep this root policy concise enough to load with other instructions; move detailed procedures into linked documents as the project grows.
- **[S2] Web/server security verification:** [OWASP ASVS](https://owasp.org/projects/asvs).
- **[S3] Mobile security verification:** [OWASP MASVS](https://mas.owasp.org/MASVS/).
- **[S4] Secure development lifecycle:** [NIST SSDF, SP 800-218](https://csrc.nist.gov/pubs/sp/800/218/final).
- **[S5] Apple release policy:** [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/).
- **[S6] Apple account lifecycle:** [Offering account deletion in your app](https://developer.apple.com/support/offering-account-deletion-in-your-app/).
- **[S7] Google Play health policy:** [Health Content and Services](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en).
- **[S8] Google Play account lifecycle:** [Account deletion requirements](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en).
- **[S9] macOS distribution:** [Notarizing macOS software before distribution](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution).
- **[S10] Windows distribution:** [Microsoft Store Policies](https://learn.microsoft.com/en-us/windows/apps/publish/store-policies). Check effective dates: a published revision may apply to a future release date.
- **[S11] Web accessibility:** [W3C WCAG 2.2](https://www.w3.org/TR/WCAG22/).
